import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hide_and_squeaks/service/api_client.dart';
import 'package:hide_and_squeaks/service/api_url.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/model/my_record_model.dart';
import 'package:hide_and_squeaks/view/screens/home/home_screen/model/sound_library_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioController extends GetxController with GetTickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final RxBool isRecording = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble decibelLevel = 0.0.obs;
  final RxBool isFetching = false.obs;
  final RxBool isFetchingSoundLibrary = false.obs;
  final AudioPlayer player = AudioPlayer();
  final RxInt currentPlayingIndex = (-1).obs;
  final RxBool isAudioLoading = false.obs;

  late AnimationController waveformController;
  bool _isRecorderReady = false;
  File? recordedFile;

  // 🎧 My recordings list from API
  final RxList<MyRecordItem> myRecordings = <MyRecordItem>[].obs;
  
  // 🎵 Sound Library list from API
  final RxList<LiveEventItem> soundLibrary = <LiveEventItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    waveformController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    initRecorder();
    fetchMyRecordings();
    fetchSoundLibrary(); // 👈 Call sound library fetch
  }

  /// 🎙 Initialize the recorder with permission
  Future<void> initRecorder() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      print("❌ Microphone permission denied");
      return;
    }

    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 200));
    _isRecorderReady = true;
  }

  /// 🎚 Toggle Recording (Start/Stop)
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  /// ▶️ Start Recording
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


    print("🎙 Recording started: $path");
  }

  /// ⏹ Stop Recording
  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    isRecording.value = false;
    print("🛑 Recording stopped: ${recordedFile?.path}");
    if (recordedFile != null) {
      await ApiClient.uploadAudioFile(recordedFile!);
    }
  }

  /// 📡 Fetch all user recordings from API
  Future<void> fetchMyRecordings() async {
    try {
      print("📥 Fetching My Recordings...");
      isFetching.value = true;

      final response = await ApiClient.getData(ApiUrl.findMyRecordSound);

      if (response.statusCode == 200) {
        final myRecordModel = MyRecordModel.fromJson(response.body);
        
        if (myRecordModel.success && myRecordModel.data != null) {
          myRecordings.assignAll(myRecordModel.data!.myRecordLibrary);
          print("✅ Total Recordings Fetched: ${myRecordings.length}");
        } else {
          print("⚠️ API returned: ${myRecordModel.message}");
        }
      } else {
        print("⚠️ HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching recordings: $e");
    } finally {
      isFetching.value = false;
    }
  }
/// 📡 Fetch Sound Library from API
/// 📡 Fetch ALL Sound Library items across all pages
Future<void> fetchSoundLibrary() async {
  try {
    print("📥 Fetching Full Sound Library...");
    isFetchingSoundLibrary.value = true;

    int currentPage = 1;
    const int limit = 10;
    int totalPages = 1;
    List<LiveEventItem> allItems = [];

    do {
      final response = await ApiClient.getData(
        "${ApiUrl.soundLibrary}?page=$currentPage&limit=$limit",
      );

      if (response.statusCode == 200) {
        final soundLibraryModel = SoundLibraryModel.fromJson(response.body);

        if (soundLibraryModel.success && soundLibraryModel.data != null) {
          final currentItems = soundLibraryModel.data!.liveEvent;
          totalPages = soundLibraryModel.data!.meta?.totalPage ?? 1;

          allItems.addAll(currentItems);
          print("✅ Page $currentPage fetched (${currentItems.length} items)");

          currentPage++;
        } else {
          print("⚠️ API returned: ${soundLibraryModel.message}");
          break;
        }
      } else {
        print("⚠️ HTTP Error: ${response.statusCode}");
        break;
      }
    } while (currentPage <= totalPages);

    soundLibrary.assignAll(allItems);
    print("🎵 Total Sound Library Items Loaded: ${soundLibrary.length}");
  } catch (e) {
    print("❌ Error fetching sound library: $e");
  } finally {
    isFetchingSoundLibrary.value = false;
  }
}


  /// 🧾 Debug print all recordings
  void printMyRecordings() {
    if (myRecordings.isEmpty) {
      print("📂 No recordings found.");
    } else {
      for (var rec in myRecordings) {
        print("🎧 ${rec.id} | ${rec.audioUrl} | ${rec.createdAt}");
      }
    }
  }

  /// 🧾 Debug print all sound library items
  void printSoundLibrary() {
    if (soundLibrary.isEmpty) {
      print("📂 No sound library items found.");
    } else {
      for (var item in soundLibrary) {
        print("🎵 ${item.id} | ${item.audioUrl} | ${item.createdAt}");
      }
    }
  }

  /// 🎵 Play or Pause Audio (My Recordings)
  Future<void> playOrPauseAudio(int index, String audioUrl) async {
    try {
      if (currentPlayingIndex.value == index && player.playing) {
        await player.pause();
        currentPlayingIndex.value = -1;
        return;
      }

      if (player.playing) {
        await player.stop();
      }

      isAudioLoading.value = true;
      currentPlayingIndex.value = index;

      String url = audioUrl.startsWith('http')
          ? audioUrl
          : '${ApiUrl.baseUrl}/$audioUrl';

      await player.setUrl(url);
      await player.play();

      isAudioLoading.value = false;

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          currentPlayingIndex.value = -1;
          isAudioLoading.value = false;
        }
      });
    } catch (e) {
      print("❌ Audio play error: $e");
      isAudioLoading.value = false;
      currentPlayingIndex.value = -1;
    }
  }

  /// 🎵 Play or Pause Sound Library Audio
  Future<void> playOrPauseSoundLibraryAudio(int index, String audioUrl) async {
    try {
      if (currentPlayingIndex.value == index && player.playing) {
        await player.pause();
        currentPlayingIndex.value = -1;
        return;
      }

      if (player.playing) {
        await player.stop();
      }

      isAudioLoading.value = true;
      currentPlayingIndex.value = index;

      String url = audioUrl.startsWith('http')
          ? audioUrl
          : '${ApiUrl.baseUrl}/$audioUrl';

      await player.setUrl(url);
      await player.play();

      isAudioLoading.value = false;

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          currentPlayingIndex.value = -1;
          isAudioLoading.value = false;
        }
      });
    } catch (e) {
      print("❌ Sound Library Audio play error: $e");
      isAudioLoading.value = false;
      currentPlayingIndex.value = -1;
    }
  }

  /// 🗑 Delete My Recording
  Future<void> deleteAudioAt(int index) async {
    if (index < 0 || index >= myRecordings.length) return;
    final item = myRecordings[index];
    final id = item.id;

    final response = await ApiClient.deleteData(ApiUrl.audiodelete(id: id));
    if (response.statusCode == 200) {
      myRecordings.removeAt(index);
      print("✅ Recording deleted: $id");
    }
  }

  /// 🔄 Refresh both lists
  Future<void> refreshAll() async {
    await Future.wait([
      fetchMyRecordings(),
      fetchSoundLibrary(),
    ]);
  }

  @override
  void onClose() {
    waveformController.dispose();
    _recorder.closeRecorder();
    player.dispose(); // 👈 Player dispose
    super.onClose();
  }
}