
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:gauge/app/modules/device/widgets/device_info.dart';
import 'package:gauge/common.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';

class DeviceShowView extends StatelessWidget {
  DeviceShowView({super.key});
  String? title = 'Device list';
  final DeviceController deviceController = Get.find();
  late Device currentDevice;
  @override
  Widget build(BuildContext context) {
    currentDevice = deviceController.getCurrentDevice();
    title = currentDevice.name;
    return AppLayout(
      title: title,
      content: DeviceInfo(device: currentDevice),
      appbar: AppBar(
        title: Text(title!),
        actions: [
          // IconButton(
          //   icon: const Icon(LucideIcons.refreshCcw),
          //   onPressed: () => deviceController.getDevices(),
          // ),
        ],
      ),
    );
  }
}
