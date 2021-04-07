import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String siteName;
  final String url;
  WebViewScreen({Key key,  this.siteName, @required this.url})
      : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

       @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.siteName);
    print(widget.url);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: red,
          centerTitle: true,
          title: Text(
            widget.siteName ?? widget.url,
            style: TextStyle(color: Colors.white, fontSize: widget.siteName != null ? 18 : 14.5),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
        ),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          }
      ),
    );
  }
}
