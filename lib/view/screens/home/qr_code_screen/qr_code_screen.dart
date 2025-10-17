import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_plus/flutter_bluetooth_serial_plus.dart';
import 'package:hide_and_squeaks/view/screens/navbar/navbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  String statusMessage = "Scan a Bluetooth QR code to connect";
  bool isConnecting = false;
  int connectionAttemptSeconds = 0;
  late Timer _attemptTimer;

  String? connectedDeviceName;
  String? connectedDeviceMac;
  BluetoothConnection? _connection;

  /// Parse QR data - Handle multiple formats
  Map<String, String>? _parseQrData(String qrData) {
    try {
      debugPrint("Raw QR Data: $qrData");

      // Format 1: JSON format
      // {"type":"BLUETOOTH","mac":"5C:D8:9E:76:7C:83","name":"HUAWEI FreeBuds SE 2"}
      if (qrData.startsWith("{")) {
        try {
          final jsonData = jsonDecode(qrData);
          if (jsonData["type"] == "BLUETOOTH" &&
              jsonData["mac"] != null &&
              jsonData["name"] != null) {
            return {
              "mac": jsonData["mac"].toString(),
              "name": jsonData["name"].toString(),
            };
          }
        } catch (e) {
          debugPrint("Not valid JSON format");
        }
      }

      // Format 2: BT:MAC:5C:D8:9E:76:7C:83:NAME:HUAWEI FreeBuds SE 2
      if (qrData.startsWith("BT:MAC:")) {
        Map<String, String> result = {};
        List<String> parts = qrData.split(":");

        for (int i = 0; i < parts.length; i += 2) {
          if (i + 1 < parts.length) {
            String key = parts[i].toLowerCase();
            String value = parts[i + 1];
            result[key] = value;
          }
        }

        String? mac = result['mac'];
        String? name = result['name'];

        if (mac != null && name != null) {
          debugPrint("Parsed Format 2 - MAC: $mac, NAME: $name");
          return result;
        }
      }

      // Format 3: BT:MAC=5C:D8:9E:76:7C:83;NAME=HUAWEI FreeBuds SE 2;
      if (qrData.startsWith("BT:MAC=")) {
        Map<String, String> result = {};
        String data = qrData.replaceFirst("BT:", "");
        List<String> pairs = data.split(";");

        for (String pair in pairs) {
          if (pair.contains("=")) {
            List<String> keyValue = pair.split("=");
            if (keyValue.length == 2) {
              String key = keyValue[0].toLowerCase();
              String value = keyValue[1];
              result[key] = value;
            }
          }
        }

        String? mac = result['mac'];
        String? name = result['name'];

        if (mac != null && name != null) {
          debugPrint("Parsed Format 3 - MAC: $mac, NAME: $name");
          return result;
        }
      }

      // Format 4: BT|5C:D8:9E:76:7C:83|HUAWEI FreeBuds SE 2
      if (qrData.startsWith("BT|")) {
        List<String> parts = qrData.split("|");
        if (parts.length >= 3) {
          String mac = parts[1];
          String name = parts[2];

          if (mac.isNotEmpty && name.isNotEmpty) {
            debugPrint("Parsed Format 4 - MAC: $mac, NAME: $name");
            return {"mac": mac, "name": name};
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint("Error parsing QR: $e");
      return null;
    }
  }

  /// Called when QR detected
  void _onDetect(BarcodeCapture capture) async {
    if (isConnecting) return;

    final Barcode? barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final String qrData = barcode.rawValue!;
    Map<String, String>? parsedData = _parseQrData(qrData);

    if (parsedData != null) {
      String targetMac = parsedData["mac"]!;
      String targetName = parsedData["name"]!;

      await Vibration.vibrate(duration: 100);
      _cameraController.stop();

      setState(() {
        isConnecting = true;
        statusMessage = "Searching for $targetName...";
      });

      _connectToDevice(targetMac, targetName);
    } else {
      setState(() => statusMessage = "Invalid QR format");
    }
  }

  /// Connect to device
  Future<void> _connectToDevice(String mac, String name) async {
    try {
      // Check if already connected to this device
      if (connectedDeviceName == mac) {
        setState(() {
          statusMessage = "Already Connected!\n\n$name\nEnjoy!";
          isConnecting = false;
        });
        debugPrint("Device already connected");
        return;
      }

      // Start timer
      connectionAttemptSeconds = 0;
      _attemptTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (isConnecting) {
          setState(() {
            connectionAttemptSeconds++;
            statusMessage =
                "Connecting to $name...\n$connectionAttemptSeconds seconds\n\n(Press Stop to cancel)";
          });
        }
      });

      setState(
          () => statusMessage = "Connecting to $name...\n0 seconds\n\n(Press Stop to cancel)");

      // Connect to device by MAC address
      _connection = await BluetoothConnection.toAddress(mac);

      if (!isConnecting) return;

      _attemptTimer.cancel();

      setState(() {
        connectedDeviceName = name;
        connectedDeviceMac = mac;
        statusMessage = "Connected!\n\n$name\nEnjoy!";
        isConnecting = false;
      });

      debugPrint("Connected in ${connectionAttemptSeconds}s");

      // Listen for disconnection
      _connection!.input!.listen((_) {}).onDone(() {
        _disconnectDevice();
      });
    } catch (e) {
      if (_attemptTimer.isActive) {
        _attemptTimer.cancel();
      }

      String errorMessage = "Connection failed";
      if (e.toString().contains("timeout")) {
        errorMessage =
            "Timeout - Device may be off\n\nSolution:\n1. Make sure device is ON\n2. Check Bluetooth Settings\n3. Try again";
      } else if (e.toString().contains("not found")) {
        errorMessage = "Device not found\n\nPair device in Settings first";
      } else if (e.toString().contains("already")) {
        errorMessage = "Device already connected";
      }

      setState(() {
        statusMessage = errorMessage;
        isConnecting = false;
      });

      debugPrint("Connection error: $e");
    }
  }

  /// Refresh scanner
  void _refreshScanner() {
    if (_attemptTimer.isActive) {
      _attemptTimer.cancel();
    }

    setState(() {
      statusMessage = "Scan a Bluetooth QR code to connect";
      isConnecting = false;
      connectionAttemptSeconds = 0;
      connectedDeviceName = null;
      connectedDeviceMac = null;
    });

    _cameraController.start();
    debugPrint("Scanner refreshed");
  }

  /// Disconnect
  Future<void> _disconnectDevice() async {
    if (_attemptTimer.isActive) {
      _attemptTimer.cancel();
    }

    try {
      await _connection?.close();
      _connection = null;
      debugPrint("Disconnected");

      setState(() {
        connectedDeviceName = null;
        connectedDeviceMac = null;
        isConnecting = false;
        connectionAttemptSeconds = 0;
        statusMessage = "Scan a Bluetooth QR code to connect";
      });

      _cameraController.start();
    } catch (e) {
      debugPrint("Disconnect error: $e");
      setState(() {
        isConnecting = false;
        statusMessage = "Scan a Bluetooth QR code to connect";
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    if (_attemptTimer.isActive) {
      _attemptTimer.cancel();
    }
    _connection?.close();
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
          "Bluetooth QR Connect",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Refresh Scanner",
            onPressed: _refreshScanner,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Camera
          Opacity(
            opacity: 0.22,
            child: MobileScanner(
              controller: _cameraController,
              onDetect: _onDetect,
            ),
          ),

          // Frame
          Transform.translate(
            offset: Offset(0, -18),
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Status
          Positioned(
            bottom: 40,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
               height:  MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Text(
                statusMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Connected info
          if (connectedDeviceName != null)
            Positioned(
              top: 6,
              child: Container(
                height: MediaQuery.of(context).size.height*0.12,
                padding: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Connected",
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    TextButton(
                      onPressed: _disconnectDevice,
                      child: const Text(
                        "Disconnect",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading
          if (isConnecting && connectedDeviceName == null)
            const Positioned(
              bottom: 40,
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
      ),
    );
  }
}