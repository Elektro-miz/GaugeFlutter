import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:get/get.dart';

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class FileData
{
  late String fileName;
  late Uint8List fileData;
}

class ApiFileController extends GetxController{

  Future<Uint8List> downloadFile(String url) async {
     final ioc = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final client = IOClient(ioc);
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes; // returns the file as Uint8List
    } else {
      throw Exception('Failed to download file');
    }
  }

  Future<Map<String, Uint8List>> unzipFile(Uint8List zipBytes) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);

    Map<String, Uint8List> files = {};

    for (final file in archive) {
      if (file.isFile) {
        files[file.name] = Uint8List.fromList(file.content as List<int>);
      }
    }

    return files; // Map of filename -> Uint8List
  }

  Future<List<FileData>> ReadFiles() async {
    const url = 'https://test.wtc-system.com/api/themes/7/download';
    List<FileData> result = [];
    try {
      // Step 1: Download
      Uint8List zipBytes = await downloadFile(url);

      // Step 2: Unzip
      Map<String, Uint8List> extractedFiles = await unzipFile(zipBytes);

      // Step 3: Access a specific file
      extractedFiles.forEach((filename, fileBytes) {
        // print('File: $filename, size: ${fileBytes.length}');
        FileData fileData = FileData();
        fileData.fileName = filename;
        fileData.fileData = fileBytes;
        result.add(fileData);
        // Now you can use fileBytes (Uint8List)
      });

    } catch (e) {
      print('Error: $e');
    }
    return result;
  }
  Future<Uint8List> ReadUpdate() async {
    const url = 'https://test.wtc-system.com/api/update/';
    Uint8List result = Uint8List(0);
    try {
      // Step 1: Download
      result = await downloadFile(url);

    } catch (e) {
      print('Error: $e');
    }
    return result;
  }
}