import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InAppWebViewPage());
  }
}

class InAppWebViewPage extends StatefulWidget {
  @override
  _InAppWebViewPageState createState() => new _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? _webViewController;
  InAppWebViewController? _webViewPopupController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('InAppWebView Example'),
        ),
        body: SafeArea(
          child: Container(
            child: InAppWebView(
              initialData: InAppWebViewInitialData(data: """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Flutter InAppWebView</title>
</head>
<body>
  <a style="display: none; margin: 50px; background: #333; color: #fff; font-weight: bold; font-size: 20px; padding: 15px; display: block;"
    href="http://192.168.4.1/download.html?inf=0&sup=300"
    target="_blank" download="file.raw">
    Click here!
  </a>
</body>
</html>
"""),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      //debuggingEnabled: true,
                      // set this to true if you are using window.open to open a new window with JavaScript
                      javaScriptCanOpenWindowsAutomatically: true),
                  android: AndroidInAppWebViewOptions(
                      // on Android you need to set supportMultipleWindows to true,
                      // otherwise the onCreateWindow event won't be called
                      supportMultipleWindows: true)),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onDownloadStartRequest:
                  (controller, url) {
                print('Download');
              },
              onCreateWindow: (controller, createWindowRequest) async {
                print("onCreateWindow");

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                        child: InAppWebView(
                          // Setting the windowId property is important here!
                          windowId: createWindowRequest.windowId,
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                                //debuggingEnabled: true,
                                ),
                          ),
                          onWebViewCreated:
                              (InAppWebViewController controller) {
                            _webViewPopupController = controller;
                          },
                          onLoadStart:
                              (InAppWebViewController controller, Uri? url) {
                            print("onLoadStart popup $url");
                          },
                          onLoadStop:
                              (InAppWebViewController controller, Uri? url) {
                            print("onLoadStop popup $url");

                          },
                          onDownloadStartRequest:
                              (controller, url) {
                            print('Download');
                          },
                        ),
                      ),
                    );
                  },
                );

                return true;
              },
            ),
          ),
        ),
      ),
    );
  }
}
