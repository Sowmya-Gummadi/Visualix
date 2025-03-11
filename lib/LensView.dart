import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LensView extends StatefulWidget {
  String searchUrl;
  LensView(this.searchUrl);

  @override
  State<LensView> createState() => _LensViewState();
}

class _LensViewState extends State<LensView> {
  var desktopUserAgent =
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36";

  @override
  Widget build(BuildContext context) {
    final webOptions = InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(userAgent: desktopUserAgent));
    return Stack(
      children: [
        InAppWebView(initialUrlRequest: URLRequest(url: Uri.parse(this.widget.searchUrl)),initialOptions: webOptions,),
        Container(
          height: 120,
          child: AppBar(
            title: Text(
              "Visualix",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blueGrey.shade700,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        )
      ],
    );
  }
}