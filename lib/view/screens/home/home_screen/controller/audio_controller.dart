import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioController extends GetxController with GetTickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final RxBool isRecording = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble decibelLevel = 0.0.obs;

  late AnimationController waveformController;
  bool _isRecorderReady = false;
  File? recordedFile;

  @override
  void onInit() {
    super.onInit();
    waveformController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    initRecorder();
  }

  Future<void> initRecorder() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      print("❌ Microphone permission denied");
      return;
    }

    await _recorder.openRecorder();
    await _recorder
        .setSubscriptionDuration(const Duration(milliseconds: 200));
    _isRecorderReady = true;
  }

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady) return;

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
    recordedFile = File(path);
    isRecording.value = true;

    _recorder.onProgress?.listen((event) {
      decibelLevel.value = event.decibels ?? 0.0;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    isRecording.value = false;
  }

  @override
  void onClose() {
    waveformController.dispose();
    _recorder.closeRecorder();
    super.onClose();
  }
}
