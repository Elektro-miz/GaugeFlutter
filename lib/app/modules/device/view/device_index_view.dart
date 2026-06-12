import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/global_widgets/layouts/app/responsive_layout.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/common.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';
import 'package:gauge/app/modules/device/widgets/device_list.dart';

class DeviceIndexView extends StatelessWidget {
  DeviceIndexView({super.key});
  String? title = 'Device list';
  final DeviceController deviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    title = "Select device";
    return AppLayout(
      title: title,
      content: ResponsiveLayout(
        mobile: context.isDeviceLandscape ? _buildTablet() : _buildMobile(),
        tablet: _buildTablet(),
        desktop: _buildDesktop(),
      ),
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

  Widget _buildMobile() {
    return DeviceList();
  }

  Widget _buildTablet() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DeviceList(),
    );
  }

  Widget _buildDesktop() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: DeviceList(),
        ),
      ),
    );
  }
}