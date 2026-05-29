import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Device {
  int? id;
  String? name;
  late BluetoothDevice btDevice;
  String? version;

  Device(ScanResult result)
  {
    id = result.device.hashCode;
    name = result.device.platformName;
    btDevice = result.device;
    version = "1.0";
  }
}