import 'dart:convert';
import 'dart:io';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:imgur_like/format/gallery.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imgur_like/main.dart' as global;

class home extends StatefulWidget {
  @override
  _home createState() => new _home();
}

class _home extends State<home> {
  getGalleryPic images;
  int page = 0;

  _home() {
    galleryPic();
  }

  galleryPic() {
    http.get(
      'https://api.imgur.com/3/gallery/hot/${page.toString()}',
      headers: {
        HttpHeaders.authorizationHeader:
        "Bearer " + global.urlParams['access_token']
      },
    ).then((response) {
      setState(() {
        images = getGalleryPic.fromJson(json.decode(response.body));
        _refreshController.loadComplete();
      });
    });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onLoading() async {
    page++;
    galleryPic();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Home',
            style: TextStyle(fontSize: 24,
                color: Colors.redAccent
            )
        ),
        centerTitle: true,
      ),
      body: new Center(child: new Builder(builder: (context) {
        if (images == null)
          return CircularProgressIndicator();
        else {
          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: false,
            controller: _refreshController,
            child: imageGallery(
                images: images
            ),
            onLoading: _onLoading,
          );
        }
      })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/account');
        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
            'Add a Photo',
            style: TextStyle(
                color: Colors.redAccent
            )
        ),
        icon: Icon(
            Icons.add_a_photo,
            size: 25,
            color:
            Colors.redAccent),
      ),
    );
  }
}