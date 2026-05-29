import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge/app/modules/controller/device_controller.dart';
import 'package:gauge/app/modules/model/device.dart';
import 'package:get/get.dart';
import 'package:gauge/common.dart';

class DeviceTile extends StatelessWidget {
  // ignore: annotate_overrides, overridden_fields
  final Key key;
  final Device device;
  final String? color;
  final String? title;
  // final String? description;
  final Function()? longPressCallback;

  DeviceTile({
    required this.key,
    required this.device,
    this.title,
    this.color,
    // this.description,
    this.longPressCallback,
  });

  final DeviceController projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      tileColor: HexColor('$color'),
      iconColor: Palette.gray[50],
      textColor: Palette.gray[50],
      onTap: longPressCallback,
      selectedTileColor: Palette.gray[500],
      leading: const Icon(LucideIcons.clock),
      title: Text(
        title!,
        overflow: TextOverflow.ellipsis,
      ),
      // subtitle: Text(
      //   '$description',
      //   overflow: TextOverflow.ellipsis,
      // ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 24.0),
          IconButton(
            icon: const Icon(LucideIcons.eye, size: 18),
            onPressed: () => {},
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(LucideIcons.bluetoothConnected, size: 18),
            onPressed: () => { },
          ),
          const SizedBox(width: 8.0),
          const SizedBox(width: 32.0),
        ],
      ),
    );
  }
}
