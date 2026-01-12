import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge_test/controllers/config_send_controller.dart';
import 'package:get/get.dart';

class BleController extends GetxController{

  bool deviceConnected = false;
  late ConfigSendController configSendController;
  late BluetoothDevice connectedDevice;
  final ValueNotifier<double> readValue = ValueNotifier(0.0);
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

 Future<void> sendDataToConnectedDevice(Uint8List buff, Function (bool received) callback, bool withoutResponse)async {
  final serviceUuid = "180a";
  final sendDataUid = "1905";
  List<BluetoothService> services = await connectedDevice.discoverServices();
  for (var service in services) {
    if(service.uuid.toString() == serviceUuid) {
      for (var char in service.characteristics) {
        if(char.uuid.toString() == sendDataUid) {
          // print('Sending $buff to device');
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
  if(deviceConnected == false)
  {
    await connectToDevice(device);
  }
  // }else
  // {
  //   // await pingConnectedDevice(device);
  //   configSendController = Get.find<ConfigSendController>();
  //   configSendController.sendConfig();
  // }
 }
 void onValueReceived(List<int> value){
    if (value.length < 4) return;

    final byteData = ByteData.sublistView(
      Uint8List.fromList(value),
    );

    readValue.value = byteData.getFloat32(0, Endian.little).toDouble();
 }
// This function will help user to connect to BLE devices.
 Future<void> connectToDevice(BluetoothDevice device)async {
  await device.connect(license: License.free);
  await device.requestMtu(512);
  deviceConnected = true;
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

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

}