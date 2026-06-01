import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:gauge/app/modules/theme/model/gauge_theme.dart';
import 'package:gauge/app/modules/theme/widgets/theme_dowload_dialog.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThemeTileWidget extends StatelessWidget {
  final GaugeTheme themeItem;

  const ThemeTileWidget({super.key, required this.themeItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeController controller = Get.find<ThemeController>();
    final Color accentColor = theme.colorScheme.primary;


    final bool isMyTheme = themeItem.userId == controller.currentUserId;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[900],
              child: _renderImage(themeItem.imageBase64),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Text(
              themeItem.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  themeItem.authorName,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.download, size: 12, color: Colors.grey),
                    Text(" ${themeItem.downloadsCount} ", style: const TextStyle(fontSize: 11)),
                    const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                    Text(" ${themeItem.likesCount}", style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Get.dialog(
                        ThemeDownloadDialog(gaugeTheme: themeItem),
                        barrierDismissible: false,
                      );
                    },
                    child: const Text('Pobierz'),
                  ),
                ),

                if (!isMyTheme) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      themeItem.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: themeItem.isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => controller.toggleLike(themeItem.id),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderImage(String data) {
    if (data.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }


    return _LocalSvgWebViewRenderer(dataUri: data);
  }
}

class _LocalSvgWebViewRenderer extends StatefulWidget {
  final String dataUri;

  const _LocalSvgWebViewRenderer({super.key, required this.dataUri});

  @override
  State<_LocalSvgWebViewRenderer> createState() => _LocalSvgWebViewRendererState();
}

class _LocalSvgWebViewRendererState extends State<_LocalSvgWebViewRenderer> {
  late final WebViewController _controller;
  bool _isWebViewLoaded = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isWebViewLoaded = true);
            }
          },
        ),
      );

    _loadSvgFromMemory();
  }

  @override
  void didUpdateWidget(covariant _LocalSvgWebViewRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataUri != widget.dataUri) {
      _loadSvgFromMemory();
    }
  }

  void _loadSvgFromMemory() {
    try {
      String rawSvgElement = widget.dataUri;

      // 1. Strip the "data:image/svg+xml..." header and decode the percent encoding (%3C -> <)
      if (rawSvgElement.contains(',')) {
        final String encodedComponent = rawSvgElement.split(',')[1];
        rawSvgElement = Uri.decodeComponent(encodedComponent);
      }

      // 2. Wrap the raw decoded <svg>...</svg> elements inline inside the HTML body
      final String htmlWrapper = '''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
              body, html {
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: transparent;
                overflow: hidden;
              }
              /* Ensure the inline SVG element automatically scales to its grid parent bounds */
              svg {
                max-width: 100% !important;
                max-height: 100% !important;
                width: 100% !important;
                height: auto !important;
              }
            </style>
          </head>
          <body>
            $rawSvgElement
          </body>
        </html>
      ''';

      _controller.loadHtmlString(htmlWrapper);
    } catch (e) {
      debugPrint("❌ Failed to decode inline SVG markup: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (!_isWebViewLoaded)
          const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}