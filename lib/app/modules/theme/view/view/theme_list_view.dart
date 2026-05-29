
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/common.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';
import 'package:gauge/app/modules/device/widgets/device_list.dart';

class ThemeListView extends StatelessWidget {
  ThemeListView({super.key});
  String? title = 'Device list';
  final DeviceController deviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    title = "Device";
    return AppLayout(
      title: title,
      content: DeviceList(),
      appbar: AppBar(
        title: Text(title!),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCcw),
            onPressed: () => deviceController.getDevices(),
          ),
        ],
      ),
    );
  }
}
