import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Enum to represent the connection status more clearly
enum ConnectionStatus { idle, scanning, connecting, connected, error }

class BluetoothService {
  // ValueNotifiers for reactive state management
  final ValueNotifier<ConnectionStatus> status = ValueNotifier(ConnectionStatus.idle);
  final ValueNotifier<String> statusMessage = ValueNotifier("📸 Scan a QR code to connect");
  final ValueNotifier<BluetoothDevice?> connectedDevice = ValueNotifier(null);

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  /// Main method to initiate connection from QR data
  Future<void> connectFromQr(String macAddress, String deviceName) async {
    if (status.value == ConnectionStatus.scanning || status.value == ConnectionStatus.connecting) {
      debugPrint("ℹ️ Already in a connection process.");
      return;
    }

    try {
      // Turn on Bluetooth if it's off
      if (!await FlutterBluePlus.isSupported) {
        throw "Bluetooth not supported on this device.";
      }
      if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
        statusMessage.value = " Turning on Bluetooth...";
        await FlutterBluePlus.turnOn();
      }

      // 1. Check bonded devices first for a quick connection
      status.value = ConnectionStatus.scanning;
      statusMessage.value = "🔍 Checking paired devices...";
      List<BluetoothDevice> bonded = await FlutterBluePlus.bondedDevices;
      for (var device in bonded) {
        if (device.remoteId.str.toUpperCase() == macAddress.toUpperCase()) {
          debugPrint("✅ Found device in bonded list: ${device.platformName}");
          await _connectToDevice(device);
          return;
        }
      }

      // 2. If not found, start scanning
      debugPrint("Device not found in bonded list. Starting scan...");
      statusMessage.value = "🔎 Scanning for '$deviceName'...";
      await _startScan(macAddress, deviceName);

    } catch (e) {
      _handleError("Error starting process: $e");
    }
  }

  Future<void> _startScan(String macAddress, String deviceName) async {
    bool deviceFound = false;
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
      if (deviceFound) return;
      
      for (ScanResult r in results) {
        if (r.device.remoteId.str.toUpperCase() == macAddress.toUpperCase()) {
          deviceFound = true;
          debugPrint("✅ Device found via scan: ${r.device.platformName}");
          await FlutterBluePlus.stopScan();
          _scanSubscription?.cancel();
          await _connectToDevice(r.device);
          return;
        }
      }
    });

    // Handle scan timeout
    await Future.delayed(const Duration(seconds: 15));
    if (!deviceFound && status.value == ConnectionStatus.scanning) {
      _handleError("❌ Device not found. Please make sure it's nearby and try again.");
    }
  }

  /// Connects to the given Bluetooth device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    status.value = ConnectionStatus.connecting;
    statusMessage.value = "🔗 Connecting to '${device.platformName}'...";

    // Listen to connection state changes
    _connectionStateSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        debugPrint("✅ Successfully connected!");
        status.value = ConnectionStatus.connected;
        statusMessage.value = "✅ Connected to\n${device.platformName}";
        connectedDevice.value = device;
        _connectionStateSubscription?.cancel();
      }
    });
    
    try {
      await device.connect(timeout: const Duration(seconds: 20));
    } catch (e) {
      _handleError("Connection failed. Please pair manually in settings and try again.");
    }
  }

  /// Disconnects from the current device
  Future<void> disconnect() async {
    if (connectedDevice.value != null) {
      await connectedDevice.value!.disconnect();
      debugPrint("Disconnected from ${connectedDevice.value!.platformName}");
    }
    reset();
  }

  /// Resets the service to its initial state
  void reset() {
    _scanSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    FlutterBluePlus.stopScan();
    status.value = ConnectionStatus.idle;
    statusMessage.value = "📸 Scan a QR code to connect";
    connectedDevice.value = null;
  }
  
  void _handleError(String message) {
    debugPrint(message);
    status.value = ConnectionStatus.error;
    statusMessage.value = message;
  }

  /// Cleans up resources
  void dispose() {
    reset();
    status.dispose();
    statusMessage.dispose();
    connectedDevice.dispose();
  }
}