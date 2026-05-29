import 'package:gauge/app/routes/app_pages.dart';
import 'package:gauge/common.dart';

class UnknownView extends StatelessWidget {
  const UnknownView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Oops!',
                    style: TextStyle(
                      fontSize: 128.0,
                      color: Palette.rose[500],
                    ),
                  ),
                  const SizedBox(height: 0.0),
                  const Text(
                    'Sorry, the page you are looking for could not be found.',
                    style: TextStyle(
                      fontSize: 32.0,
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Palette.teal[500],
                        ),
                        children: [
                          const TextSpan(text: 'Return to home page '),
                          WidgetSpan(
                            child: Icon(
                              LucideIcons.home,
                              color: Palette.teal[500],
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.toNamed(AppPages.initial);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
