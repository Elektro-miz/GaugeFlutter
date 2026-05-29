
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';
import 'package:gauge/app/modules/device/widgets/device_list.dart';

class DeviceView extends StatelessWidget {
  DeviceView({super.key});
  String? title = 'Device list';

  @override
  Widget build(BuildContext context) {
    title = "Device";
    return AppLayout(
      title: title,
      content: DeviceList(),
    );
  }
}
