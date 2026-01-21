import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge_test/controllers/config_send_controller.dart';
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

  // FlutterBluePlus ble = FlutterBluePlus.instance;
// This Function will help users to scan near by BLE devices and get the list of Bluetooth devices.
  Future scanDevices() async{
        FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
        await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
        // FlutterBluePlus.stopScan();
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

 Future<void> handleDevice(BluetoothDevice device)async {
  if(deviceConnected.value == false)
  {
    await connectToDevice(device);
  }else{
    await disconnectTheDevice(device);
  }
  // {
  //   // await pingConnectedDevice(device);
  //   configSendController = Get.find<ConfigSendController>();
  //   configSendController.sendConfig();
  // }
 }
 void onValueReceived(List<int> value){
    if (value.length < 24) return;

    final byteData = ByteData.sublistView(
      Uint8List.fromList(value),
    );

    readValue.value = ReceiveFrameData.fromList(byteData);
 }
// This function will help user to connect to BLE devices.
 Future<void> connectToDevice(BluetoothDevice device)async {
  await device.connect(license: License.free);
  await device.requestMtu(512);
  deviceConnected.value = true;
  connectedDevice = device;
  final serviceUuid = "180a";
  final readDataUid = "1906";
  List<BluetoothService> services = await device.discoverServices();
  for (var service in services) {
    if(service.uuid.toString() == serviceUuid) {
      for (var char in service.characteristics) {
        if(char.uuid.toString() == readDataUid) {
            await char.setNotifyValue(true);
            char.lastValueStream.listen(onValueReceived);
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

}