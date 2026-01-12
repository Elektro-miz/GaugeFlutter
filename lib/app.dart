// Project Imports
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge_test/controllers/bluetooth_controller.dart';
import 'package:gauge_test/controllers/config_send_controller.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late BleController bleController;
  late ConfigSendController configSendController;
  @override
  void initState(){
    super.initState();

    bleController = Get.find<BleController>();
    configSendController = Get.find<ConfigSendController>();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: Text("BLE SCANNER"),),
        body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<List<ScanResult>>(
                      stream: bleController.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data![index];
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(data.device.platformName),
                                      subtitle: Text(data.device.remoteId.str),
                                      trailing: Text(data.rssi.toString()),
                                      onTap: ()=> {
                                          if(bleController.deviceConnected)
                                          {
                                            configSendController.sendConfig()
                                          }else
                                          {
                                            bleController.handleDevice(data.device)
                                          }
                                        },
                                    ),
                                  );
                                }),
                          );
                        }else{
                          return Center(child: Text("No Device Found"),);
                        }
                      }),
                  SizedBox(height: 10,),
                  ValueListenableBuilder<double>(
                    valueListenable: bleController.readValue,
                    builder: (_, value, __) {
                      return Text('Read value: $value');
                    },
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: configSendController.sendingConfigProgress,
                    builder: (_, value, __) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                      );
                    },
                  ),
                  ElevatedButton(onPressed: ()  async {
                    bleController.scanDevices();
                    // await controller.disconnectDevice();
                  }, child: Text("SCAN")),
                ],
              ),
        )
    );
  }
}
