import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:imgur_like/format/buttons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'pages/authentification.dart';
import 'pages/account.dart';
import 'pages/search.dart';
import 'pages/home.dart';
import 'widgets/bottomNavBar.dart';

var urlParams = <String, String>{};

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  final url = Uri.https('api.imgur.com', '/oauth2/authorize', {
    'client_id': "8748de794205a87",
    'response_type': 'token',
  });

  @override
  Widget build(BuildContext context) {
    var title = 'Imgur Like';
    return new MaterialApp(
      title: title,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        accentColor: Colors.redAccent,
        canvasColor: Colors.black,
      ),
      routes: {
        '/webview': (_) => new WebviewScaffold(
              url: url.toString(),
              appBar: new AppBar(
                title: const Text('Imgur Authentication'),
                automaticallyImplyLeading: false,
              ),
              withZoom: false,
              withLocalStorage: true,
            ),
        '/home': (_) => new home(),
        '/search': (_) => new searchPage(),
        '/account': (_) => new accountPage(),
        '/botnav': (_) => new BottomNavBarPage(),
      },
      home: myHomePage(),
    );
  }
}

class myHomePage extends StatefulWidget {
  @override
  _myHomePage createState() => _myHomePage();
}

class _myHomePage extends State<myHomePage> {

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              constraints: BoxConstraints.tightFor(width: 300.0, height: 300.0),
              child: Image.asset("assets/images/target.png"),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                roundButtonGen(
                    colorText: Colors.redAccent,
                    colorCase: Colors.blueAccent,
                    buttonText: "Authentification",
                    link: authentification()),
              ],
            )
          ],
        ),
      ),
    );
  }
}