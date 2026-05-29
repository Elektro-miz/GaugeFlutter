import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:gauge/app/modules/theme/view/model/gauge_theme.dart';
import 'package:get/get.dart';
import 'package:gauge/common.dart';

class ThemeTile extends StatelessWidget {
  // ignore: annotate_overrides, overridden_fields
  final Key key;
  final GaugeTheme theme;
  final String? color;
  final String? title;
  // final String? description;
  final Function()? longPressCallback;

  ThemeTile({
    required this.key,
    required this.theme,
    this.title,
    this.color,
    // this.description,
    this.longPressCallback,
  });

  final DeviceController deviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
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
            onPressed: () => {},
          ),
          const SizedBox(width: 8.0),
          const SizedBox(width: 32.0),
        ],
      ),
    );
  }
}
