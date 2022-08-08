import 'dart:async';
import 'dart:io';

import 'package:dataminners/constants.dart';
import 'package:dataminners/functions/click_function.dart';
import 'package:dataminners/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  MenuModel menuModel;
  WebPage({Key? key, required this.menuModel}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  int progress = 0;
  bool isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(widget.menuModel.title.toString())),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.grey[200],
                    value: progress / 100,
                    color: primaryColor),
                Container(
                  padding: EdgeInsets.only(bottom: 2),
                  height: size.height * 0.83,
                  child: WebView(
                    initialUrl: widget.menuModel.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progressInt) {
                      progress = progressInt;
                      if (progress > 90) {
                        isLoading = false;
                      } else {
                        isLoading = true;
                      }
                      print("WebView is loading (progress : $progress%)");
                      setState(() {});
                    },
                    navigationDelegate: (NavigationRequest request) {
                      adCounter();
                      if (request.url.contains("exit_from_web_page")) {
                        Navigator.pop(context);
                      }
                      // if (request.url.startsWith('https://www.youtube.com/')) {
                      //   print('blocking navigation to $request}');
                      //   return NavigationDecision.prevent;
                      // }
                      // print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    gestureNavigationEnabled: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
