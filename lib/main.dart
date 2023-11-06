import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SwipeWebView(),
    );
  }
}

class SwipeWebView extends StatefulWidget {
  const SwipeWebView({super.key});

  @override
  State<SwipeWebView> createState() => _SwipeWebViewState();
}

class _SwipeWebViewState extends State<SwipeWebView> {
  late InAppWebViewController webViewController;
  late int swipeKey = 1;
  Future<bool> handleSwipe() async {
    final url = await webViewController.getUrl();
    final urlString = url.toString();
    print("url: $urlString");
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var webViewWidget = AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: InAppWebView(
                initialOptions: InAppWebViewGroupOptions(),
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://github.com/kofkuiper/swipe-iOS/blob/main/lib/main.dart'),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {},
                onLoadStop: (controller, url) {},
                onLoadError: (controller, url, code, message) {},
              ),
            )
          ],
        ),
      ),
    );
    var androidWidget = WillPopScope(
      key: widget.key,
      onWillPop: handleSwipe,
      child: webViewWidget,
    );
    var iOSWidget = Listener(
      key: widget.key,
      onPointerMove: (event) {
        if (event.delta.dx > 10 &&
            event.delta.dy >= 0 &&
            event.delta.dy <= 10) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            await handleSwipe();
          });
        }
      },
      child: webViewWidget,
    );
    return Platform.isAndroid ? androidWidget : iOSWidget;
  }
}
