import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController _cameraController;
  String statusMessage = "Scan a Bluetooth QR code for speaker connection";
  bool isConnecting = false;
  BluetoothDevice? targetDevice;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  Map<String, String>? _parseQrData(String qrData) {
    try {
      debugPrint("QR Data: $qrData");

      if (qrData.startsWith("{")) {
        final jsonData = jsonDecode(qrData);
        if (jsonData["type"] == "A2DP" || jsonData["type"] == "BLUETOOTH") {
          return {
            "mac": jsonData["mac"],
            "name": jsonData["name"],
          };
        }
      }

      if (qrData.startsWith("BT|")) {
        final parts = qrData.split("|");
        if (parts.length >= 3) {
          return {"mac": parts[1], "name": parts[2]};
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error parsing QR: $e");
      return null;
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isConnecting) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    final parsed = _parseQrData(barcode!.rawValue!);
    if (parsed == null) {
      setState(() => statusMessage = "Invalid QR format");
      return;
    }

    final mac = parsed["mac"]!;
    final name = parsed["name"]!;

    await Vibration.vibrate(duration: 100);
    _cameraController.stop();

    setState(() {
      isConnecting = true;
      statusMessage = "Connecting to $name (A2DP)...";
    });

    await _connectToSpeaker(mac, name);
  }

  Future<void> _connectToSpeaker(String mac, String name) async {
    try {
      // Check if device is already bonded
      final bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
      final alreadyBonded = bondedDevices.any((d) => d.address == mac);

      if (alreadyBonded) {
        setState(() {
          statusMessage = "Speaker already paired!\n$name\nNow set it as audio output.";
          isConnecting = false;
        });
        return;
      }

      // Try pairing using system intent (Android only)
      if (Platform.isAndroid) {
        setState(() => statusMessage = "Opening Bluetooth settings...");
        await FlutterBluetoothSerial.instance.openSettings();
      }

      // Attempt direct pairing (may not work on all cheap speakers)
      await FlutterBluetoothSerial.instance.bondDeviceAtAddress(mac);

      setState(() {
        statusMessage = "Connected to speaker: $name\nEnjoy your music 🎵";
        isConnecting = false;
      });
    } catch (e) {
      debugPrint("Error connecting: $e");
      setState(() {
        statusMessage = "Failed to connect to $name\nTry pairing manually.";
        isConnecting = false;
      });
    }
  }

  void _refreshScanner() {
    _cameraController.start();
    setState(() {
      isConnecting = false;
      statusMessage = "Scan a Bluetooth QR code for speaker connection";
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "A2DP Speaker Connector",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshScanner,
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.25,
            child: MobileScanner(
              controller: _cameraController,
              onDetect: _onDetect,
            ),
          ),
          Container(
            height: 260,
            width: 260,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Text(
                statusMessage,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (isConnecting)
            const Positioned(
              bottom: 60,
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 0),
    );
  }
}
