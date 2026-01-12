import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge_test/controllers/api_file_controller.dart';
import 'package:gauge_test/controllers/bluetooth_controller.dart';
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
  late bool wasLastFilePackageReceived = false;
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
  int fileDataPackSize = 235;
  int dataToSendLen = 0;
  double totalDataSize = 0;
  double alreadySendDataSize = 0;
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
  void sendFileData(Uint8List fileData)async {
    int sendData = 0;
    int i = 0;
    while(sendData < fileData.length){

        dataToSendLen = fileDataPackSize;
        if(sendData + dataToSendLen > fileData.length)
        {
          dataToSendLen = fileData.length - sendData;
        }

        final dataSize = ByteData(4);
        dataSize.setUint32(0, dataToSendLen, Endian.little);
        final dataOffset = ByteData(4);
        dataOffset.setUint32(0, sendData, Endian.little);
        Uint8List list = Uint8List.fromList([
          ...[ConfigSendCommandsEnum.ReceiveConfigFileData.index],
          ...dataSize.buffer.asInt8List(),
          ...dataOffset.buffer.asInt8List(),
          ...currentFile.fileData.sublist(sendData, sendData + dataToSendLen)
        ]);

        sendData += dataToSendLen;
        alreadySendDataSize += dataToSendLen;
        _calculateSendingProgress();
        bool withoutResponse = (i % 10) != 0;
        if(withoutResponse == false){
          wasLastFilePackageReceived = false;
        }else
        {
          wasLastFilePackageReceived = true;
        }
        await bleController.sendDataToConnectedDevice(list, sendFileDataCallback, withoutResponse);
        if(wasLastFilePackageReceived == false){

        }
        i++;
    }
  }

  void onFrameSendSuccess(bool wasLastPackageReceived) {
    switch(state) {
      case ConfigSendStates.None: {
      }break;
      case ConfigSendStates.StartReceiveConfig: {
        state = ConfigSendStates.StartReceiveConfigFile;
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
        Uint8List list = Uint8List.fromList([
          ...[ConfigSendCommandsEnum.StartReceiveConfigFile.index],
          ...nameList,
          ...dataSize.buffer.asUint8List()
        ]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess, false);
      }break;
      case ConfigSendStates.ReceiveConfigFileData: {
        if(sendFileBytes >= currentFile.fileData.length)
        {
          state = ConfigSendStates.EndReceiveConfigFile;
          onFrameSendSuccess(true);
          return;
        }

        if(wasLastPackageReceived == false)
        {
          sendFileBytes -= dataToSendLen;
          if(sendFileBytes < 0)
          {
            sendFileBytes = 0;
          }
        }

        dataToSendLen = fileDataPackSize;
        if(sendFileBytes + dataToSendLen > currentFile.fileData.length)
        {
          dataToSendLen = currentFile.fileData.length - sendFileBytes;
        }
        final dataSize = ByteData(4);
        dataSize.setUint32(0, dataToSendLen, Endian.little);
        final dataOffset = ByteData(4);
        dataOffset.setUint32(0, sendFileBytes, Endian.little);
        Uint8List list = Uint8List.fromList([
          ...[ConfigSendCommandsEnum.ReceiveConfigFileData.index],
          ...dataSize.buffer.asInt8List(),
          ...dataOffset.buffer.asInt8List(),
          ...currentFile.fileData.sublist(sendFileBytes, sendFileBytes + dataToSendLen)
        ]);
        sendFileBytes += dataToSendLen;
        alreadySendDataSize += dataToSendLen;
        _calculateSendingProgress();
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess);
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

  void _setDataParams()
  {
    for(final file in readFiles)
    {
      totalDataSize += file.fileData.length;
    }
    alreadySendDataSize = 0;
  }
  Future sendConfig() async {
    switch(state) {
      case ConfigSendStates.None: {
        final fileList = await apiFileController.ReadFiles();
        readFiles = _orderFilesToSend(fileList, fileSendingOrder);
        currentFileId = 0;
        currentFile = readFiles[0];
        _setDataParams();
        state = ConfigSendStates.StartReceiveConfig;
        Uint8List list = Uint8List.fromList([1]);
        bleController.sendDataToConnectedDevice(list, onFrameSendSuccess);
      }break;
      default:
      break;
    }
  }
}