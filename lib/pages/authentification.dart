import 'dart:async';

import 'package:imgur_like/main.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class authentification extends StatefulWidget {
  @override
  _authentification createState() => _authentification();
}

class _authentification extends State<authentification> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  String urlChanged;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => imgurAuth(context));
  }

  void imgurAuth(BuildContext context) {
    Navigator.of(context).pushNamed('/webview');
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((urlChanged) {
      if (urlChanged
          .startsWith('https://app.getpostman.com/oauth2/callback#')) {
        flutterWebviewPlugin.hide();
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/botnav');
        setState(() {
          var uri = Uri.parse(urlChanged.replaceFirst('#', '?'));
          uri.queryParameters.forEach((key, value) {
            global.urlParams[key] = value;
          });
          print(global.urlParams);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}