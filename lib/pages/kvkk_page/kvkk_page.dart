import 'dart:async';

import 'package:afet_destek/gen/assets.gen.dart';
import 'package:afet_destek/shared/util/internal/internal.dart'
    if (dart.library.html) 'package:afet_destek/shared/util/internal/html/web_internal.dart';
import 'package:afet_destek/shared/widgets/responsive_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsPage extends StatefulWidget {
  const TermsPage._({required this.title, required this.body});
  final String title;
  final String body;
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      setUiIframeParameter(
        key: 'browser_page',
        id: 'browser_url',
      );
    }
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => TermsPage._(body: body, title: title),
      ),
    );
  }

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      controller = WebViewController()
        ..loadRequest(Uri.parse('https://afetdestekkvvk.web.app/'));
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      controller.clearLocalStorage();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveAppBar(
        mobileTile: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SvgPicture.asset(Assets.logoSvg),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 700,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (size.width >= 1000)
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                if (kIsWeb)
                  Expanded(
                    child: htmlElementView(
                      viewType: 'browser_page',
                      onPlatformViewCreated: (data) {
                        _onFWWebViewCreated();
                      },
                    ),
                  )
                else
                  Expanded(
                    child: WebViewWidget(
                      controller: controller,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFWWebViewCreated() {
    // ignore: avoid_dynamic_calls
    final ifrelElement = document.getElementById('browser_url');

    if (ifrelElement != null) {
      // ignore: avoid_dynamic_calls
      ifrelElement.src = 'https://afetdestekkvvk.web.app/';
    }
    setState(() {});
  }
}
