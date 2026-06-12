import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:byte_util/byte_word.dart';
import 'package:flutter/material.dart';
import 'package:gauge/app/controllers/api_file_controller.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/controllers/modbus_crc.dart';
import 'package:get/get.dart';

class BtFrameData
{

}

class BtFrameStruct
{
  Uint8 frameType = Uint8();
  BtFrameData frameData = BtFrameData();
}

enum ConfigSendCommandsEnum
{
    None,
    StartReceiveConfing,
    StartReceiveConfigFile,
    ReceiveConfigFileData,
    EndReceiveConfigFile,
    EndReceiveConfig,
    StartReceiveUpdate,
    ReceiveUpdateData,
    EndReceiveUpdate,
}

enum ConfigSendStates
{
  None,
  StartReceiveConfig,
  StartReceiveConfigFile,
  ReceiveConfigFileData,
  EndReceiveConfigFile,
  EndReceiveConfig,
  StartReceiveUpdate,
  ReceiveUpdateData,
  EndReceiveUpdate,
}

class ConfigSendController extends GetxController{
  late BleController bleController;
  late ApiFileController apiFileController;
  late List<FileData> readFiles;
  late FileData currentFile;
  late Uint8List updateFile;
  late bool wasLastFilePackageReceived = false;
  final String updateFileName = "firmware.bin";
  final List<String> fileSendingOrder = [
    "gauge_bg_0.bin",
    "gauge_bg_1.bin",
    "gauge_bg_2.bin",
    "gauge_bg_3.bin",
    "gauge_bg_4.bin",
    "gauge_bg_5.bin",
    "gauge_bg_6.bin",
    "gauge_bg_7.bin",
    "gauge_bg_8.bin",
    "gauge_bg_9.bin",
    "gauge_fill.bin",
    "gauge_scale.bin",
    "gauge_needle.bin",
    "font_scale.bin",
    "font_value.bin",
    "font_desc.bin",
    "conf.json",
  ];
  ConfigSendStates state = ConfigSendStates.None;
  int sendFileBytes = 0;
  int currentFileId = 0;
  int fileDataPackSize = 500;
  int dataToSendLen = 0;
  double totalDataSize = 0;
  double alreadySendDataSize = 0;
  Completer<void>? windowCompleter;
  late Uint8List notificationData;
  final ValueNotifier<double> sendingConfigProgress = ValueNotifier(0.0);

  ConfigSendController() {
    bleController = Get.find<BleController>();
    apiFileController = Get.find<ApiFileController>();
  }

  int _getFileOrder(FileData file) {
    if(fileSendingOrder.contains(file.fileName)){
      return fileSendingOrder.indexOf(file.fileName);
    }
    return -1;
  }

  List<FileData> _orderFilesToSend(List<FileData> startingList, List<String> orderingList) {
    List<FileData> result = [];

    for(final file in startingList) {
      if(_getFileOrder(file) != -1)
      {
        result.add(file);
      }
    }

    result.sort((FileData a, FileData b) => _getFileOrder(a) - _getFileOrder(b));
    return result;
  }

  void _calculateSendingProgress() {
    sendingConfigProgress.value = alreadySendDataSize / totalDataSize;
  }

  void sendFileDataCallback(bool wasDataReceived){
    wasLastFilePackageReceived = wasDataReceived;
  }

  void notificationCallback(Uint8List data)async {
    notificationData = data;
    if (windowCompleter != null && !windowCompleter!.isCompleted) {
      windowCompleter!.complete();
    }
  }

  Future<void> sendFileData(Uint8List fileData)async {
    int sendData = 0;
    int i = 0;
    int dataWithoutResponseLen = 0;
    while(sendData < fileData.length){

        int dataToSendLen = fileDataPackSize;
        if(sendData + dataToSendLen > fileData.length)
        {
          dataToSendLen = fileData.length - sendData;
        }

        bool withoutResponse = (i == 0 || ((i % 80) != 0)) && dataToSendLen == fileDataPackSize;
        // bool withoutResponse = true;

        final dataSize = ByteData(4);
        dataSize.setUint32(0, dataToSendLen, Endian.little);
        final dataOffset = ByteData(4);
        dataOffset.setUint32(0, sendData, Endian.little);
        final notify = ByteData(1);
        notify.setUint8(0, 1);
        Uint8List list = Uint8List.fromList([
          ...[ConfigSendCommandsEnum.ReceiveConfigFileData.index],
          ...dataSize.buffer.asInt8List(),
          ...dataOffset.buffer.asInt8List(),
          ...notify.buffer.asInt8List(),
          ...fileData.sublist(sendData, sendData + dataToSendLen)
        ]);

        sendData += dataToSendLen;
        _calculateSendingProgress();
        dataWithoutResponseLen += dataToSendLen;
        if(withoutResponse == false){
          wasLastFilePackageReceived = false;
          notificationData = Uint8List(0);
          windowCompleter = Completer<void>();
        }else
        {
          wasLastFilePackageReceived = true;
        }
        await bleController.sendDataToConnectedDevice(list, sendFileDataCallback, withoutResponse);
        if(withoutResponse == false){
          // await windowCompleter!.future.timeout(Duration(seconds: 5), onTimeout: () {
          //         print("Timeout! ESP32 didn't respond.");
          //       });
          // if(notificationData.length != 4){
          if(wasLastFilePackageReceived == false){
            sendData -= dataWithoutResponseLen;
            dataWithoutResponseLen = 0;
          }else
          {
            alreadySendDataSize += dataWithoutResponseLen;
            dataWithoutResponseLen = 0;
          }
        }
        i++;
    }
    _calculateSendingProgress();
    return;
  }
  Future<void> sendUpdateFileData(Uint8List fileData)async {
    int sendData = 0;
    int i = 0;
    int dataWithoutResponseLen = 0;
    while(sendData < fileData.length){

        int dataToSendLen = fileDataPackSize;
        if(sendData + dataToSendLen > fileData.length)
        {
          dataToSendLen = fileData.length - sendData;
        }

        bool withoutResponse = (i == 0 || ((i % 80) != 0)) && dataToSendLen == fileDataPackSize;

        final dataSize = ByteData(4);
        dataSize.setUint32(0, dataToSendLen, Endian.little);
        final dataOffset = ByteData(4);
        dataOffset.setUint32(0, sendData, Endian.little);
        final notify = ByteData(1);
        notify.setUint8(0, 1);
        Uint8List list = Uint8List.fromList([
          ...[ConfigSendCommandsEnum.ReceiveUpdateData.index],
          ...dataSize.buffer.asInt8List(),
          ...dataOffset.buffer.asInt8List(),
          ...notify.buffer.asInt8List(),
          ...fileData.sublist(sendData, sendData + dataToSendLen)
        ]);

        sendData += dataToSendLen;
        _calculateSendingProgress();
        dataWithoutResponseLen += dataToSendLen;
        if(withoutResponse == false){
          wasLastFilePackageReceived = false;
          notificationData = Uint8List(0);
          windowCompleter = Completer<void>();
        }else
        {
          wasLastFilePackageReceived = true;
        }
        await bleController.sendDataToConnectedDevice(list, sendFileDataCallback, withoutResponse);
        if(withoutResponse == false){
          if(wasLastFilePackageReceived == false){
            sendData -= dataWithoutResponseLen;
            dataWithoutResponseLen = 0;
          }else
          {
            alreadySendDataSize += dataWithoutResponseLen;
            dataWithoutResponseLen = 0;
          }
        }
        i++;
    }
    _calculateSendingProgress();
    return;
  }
  int byteWordToInt(ByteWord w){
    // A list of bytes [High, Low]
    Uint8List bytes = Uint8List.fromList(w.bytes);

    // Create a view into the byte array
    ByteData data = ByteData.sublistView(bytes);

    return data.getUint16(0, Endian.big);
  }
void onFrameSendSuccessSendConfig(bool wasLastPackageReceived) async {
    switch(state) {
      case ConfigSendStates.StartReceiveConfig: {
        state = ConfigSendStates.StartReceiveConfigFile;
        bleController.registerNotificationCallback(notificationCallback);
        Uint8List list = Uint8List.fromList([ConfigSendCommandsEnum.StartReceiveConfing.index]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      case ConfigSendStates.StartReceiveConfigFile: {
        state = ConfigSendStates.ReceiveConfigFileData;
        sendFileBytes = 0;
        dataToSendLen = 0;

        String fileName = currentFile.fileName;
        List<int> encoded = utf8.encode(fileName);

        Uint8List nameList = Uint8List(20);
        nameList.setRange(0, encoded.length, encoded);

        final dataSize = ByteData(4);
        dataSize.setUint32(0, currentFile.fileData.length, Endian.little);

        final dataCrc = ByteData(4);
        final modbus = ModbusCrc();
        int crc = modbus.getCrc(currentFile.fileData, currentFile.fileData.length);
        dataCrc.setUint32(0, crc, Endian.little);

        Uint8List list = Uint8List.fromList([
          ...[ConfigSendCommandsEnum.StartReceiveConfigFile.index],
          ...nameList,
          ...dataSize.buffer.asUint8List(),
          ...dataCrc.buffer.asUint8List()
        ]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      case ConfigSendStates.ReceiveConfigFileData: {
        await sendFileData(currentFile.fileData);
        // if(sendFileBytes >= currentFile.fileData.length)
        // {
          state = ConfigSendStates.EndReceiveConfigFile;
          onFrameSendSuccess(true);
          // return;
        // }
      }break;
      case ConfigSendStates.EndReceiveConfigFile: {
        if(currentFileId >= readFiles.length - 1)
        {
          state = ConfigSendStates.EndReceiveConfig;
        }else
        {
          state = ConfigSendStates.StartReceiveConfigFile;
          currentFileId += 1;
          currentFile = readFiles[currentFileId];
        }
        Uint8List list = Uint8List.fromList([ConfigSendCommandsEnum.EndReceiveConfigFile.index]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      case ConfigSendStates.EndReceiveConfig: {
        state = ConfigSendStates.None;
        Uint8List list = Uint8List.fromList([ConfigSendCommandsEnum.EndReceiveConfig.index]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      default:
      break;
    }
  }
void onFrameSendSuccessSendUpdate(bool wasLastPackageReceived) async {
    switch(state) {
      case ConfigSendStates.StartReceiveUpdate: {
        state = ConfigSendStates.ReceiveUpdateData;
        onFrameSendSuccess(true);
      }break;
      case ConfigSendStates.ReceiveUpdateData: {
        await sendUpdateFileData(updateFile);
          state = ConfigSendStates.EndReceiveUpdate;
          onFrameSendSuccess(true);
      }break;
      case ConfigSendStates.EndReceiveUpdate: {
        state = ConfigSendStates.None;
        Uint8List list = Uint8List.fromList([ConfigSendCommandsEnum.EndReceiveUpdate.index]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      default:
      break;
    }
  }
  void onFrameSendSuccess(bool wasLastPackageReceived) async {
    onFrameSendSuccessSendConfig(wasLastPackageReceived);
    onFrameSendSuccessSendUpdate(wasLastPackageReceived);
  }

  void _setDataParams()
  {
    totalDataSize = 0;
    for(final file in readFiles)
    {
      totalDataSize += file.fileData.length;
    }
    alreadySendDataSize = 0;
  }
  Future sendConfig(String themeId) async {
    switch(state) {
      case ConfigSendStates.None: {
        final fileList = await apiFileController.ReadFiles(themeId);
        readFiles = _orderFilesToSend(fileList, fileSendingOrder);
        currentFileId = 0;
        currentFile = readFiles[0];
        _setDataParams();
        state = ConfigSendStates.StartReceiveConfig;
        Uint8List list = Uint8List.fromList([ConfigSendCommandsEnum.StartReceiveConfing.index]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      default:
      break;
    }
  }
  Future sendUpdate() async {
    switch(state) {
      case ConfigSendStates.None: {
        Uint8List fileData = await apiFileController.ReadUpdate();
        updateFile = fileData;
        totalDataSize = updateFile.length.toDouble();
        alreadySendDataSize = 0;
        state = ConfigSendStates.StartReceiveUpdate;
        Uint8List list = Uint8List.fromList([ConfigSendCommandsEnum.StartReceiveUpdate.index]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      default:
      break;
    }
  }
}