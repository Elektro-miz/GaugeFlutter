import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge/app/controllers/config_send_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:get/get.dart';

class ReceiveFrameData
{
  @Uint32()
  late int softVer;
  @Uint32()
  late int hardwareVer;
  @Float()
  late double usedValue;
  @Float()
  late double adc1Value;
  @Float()
  late double batteryVoltage;
  @Float()
  late double illuminationVoltage;
  ReceiveFrameData()
  {
    softVer = 0;
    hardwareVer = 0;
    usedValue = 0;
    adc1Value = 0;
    batteryVoltage = 0;
    illuminationVoltage = 0;
  }
  ReceiveFrameData.fromList(ByteData byteData)
  {
    softVer = byteData.getInt32(0, Endian.little);
    hardwareVer = byteData.getInt32(4, Endian.little);
    usedValue = byteData.getFloat32(8, Endian.little).toDouble();
    adc1Value = byteData.getFloat32(12, Endian.little).toDouble();
    batteryVoltage = byteData.getFloat32(16, Endian.little).toDouble();
    illuminationVoltage = byteData.getFloat32(20, Endian.little).toDouble();
  }
}
class BleController extends GetxController{

  ValueNotifier<bool> deviceConnected = ValueNotifier(false);
  late ConfigSendController configSendController;
  late BluetoothDevice connectedDevice;
  final ValueNotifier<ReceiveFrameData> readValue = ValueNotifier(ReceiveFrameData());
  final StreamController<bool> _eventController = StreamController<bool>.broadcast();
  bool scanComplete = false;


  Future scanDevices() async{
        FlutterBluePlus.setLogLevel(LogLevel.none);
        await requestBluetoothEnable();
        if(deviceConnected.value) disconnectTheDevice(connectedDevice);
        await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
        await Future.delayed(const Duration(seconds: 6));

  }

 Future<void> pingConnectedDevice(BluetoothDevice device)async {
  final serviceUuid = "180a";
  final sendDataUid = "1905";
  List<BluetoothService> services = await device.discoverServices();
  for (var service in services) {
    if(service.uuid.toString() == serviceUuid) {
      for (var char in service.characteristics) {
        if(char.uuid.toString() == sendDataUid) {
          await char.write(utf8.encode("HELLO ESP32"), withoutResponse: false,);
          break;
        }
      }
    }
  }
 }

 Future<void> registerNotificationCallback(Function (Uint8List data) notificationCallback)async {
  final serviceUuid = "180a";
  final sendDataUid = "1905";
  List<BluetoothService> services = await connectedDevice.discoverServices();
  for (var service in services) {
    if(service.uuid.toString() == serviceUuid) {
      for (var char in service.characteristics) {
        if(char.uuid.toString() == sendDataUid) {
            char.lastValueStream.listen((value) {
            notificationCallback(Uint8List.fromList(value));
          });
          await char.setNotifyValue(true);
        }
      }
    }
   }
 }

 Future<void> sendDataToConnectedDevice(Uint8List buff, Function (bool received) callback, bool withoutResponse)async {
  final serviceUuid = "180a";
  final sendDataUid = "1905";
  List<BluetoothService> services = await connectedDevice.discoverServices();
  for (var service in services) {
    if(service.uuid.toString() == serviceUuid) {
      for (var char in service.characteristics) {
        if(char.uuid.toString() == sendDataUid) {
          try{
            await char.write(buff, withoutResponse: withoutResponse,);
            callback(true);
          }catch(e) {
            callback(false);
          }
          break;
        }
      }
    }
  }
 }


 void onValueReceived(List<int> value){
    if (value.length < 24) return;

    final byteData = ByteData.sublistView(
      Uint8List.fromList(value),
    );

    readValue.value = ReceiveFrameData.fromList(byteData);
 }

 Future<void> connectToDevice(Device device)async {
  _connectToDevice(device.btDevice);
 }

 Future<void> _connectToDevice(BluetoothDevice device)async {
  await device.connect(license: License.free);
  await device.requestMtu(512);
  deviceConnected.value = true;
  connectedDevice = device;
  final serviceUuid = "180a";
  final readDataUid = "1906";
  List<BluetoothService> services = await device.discoverServices();

  var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        disconnectTheDevice(connectedDevice);
      }
  });

  device.cancelWhenDisconnected(subscription, delayed: true, next: true);

  for (var service in services) {
    if(service.uuid.toString() == serviceUuid) {
      for (var char in service.characteristics) {
        if(char.uuid.toString() == readDataUid) {
            await char.setNotifyValue(true);
            char.lastValueStream.listen(onValueReceived);
            print("Device connected!");
          break;
        }
      }
    }
  }
 }



 Future<void> disconnectTheDevice(BluetoothDevice device)async {
  await device.disconnect();
  deviceConnected.value = false;
 }


  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  Future<void> requestBluetoothEnable() async {
    BluetoothAdapterState state = await FlutterBluePlus.adapterState.first;

    if (state == BluetoothAdapterState.on) {
      debugPrint("Bluetooth is already on.");
      return;
    }

    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      debugPrint("Error turning on Bluetooth: $e");
    }
  }

}