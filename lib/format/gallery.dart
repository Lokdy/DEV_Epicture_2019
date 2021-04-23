import 'dart:io';

import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:imgur_like/main.dart' as global;

class imageGallery extends StatefulWidget {
  getGalleryPic images;

  imageGallery({Key key, @required this.images}) : super(key: key);

  @override
  _imageGallery createState() => _imageGallery();
}

class _imageGallery extends State<imageGallery> {

  Widget build(BuildContext context) {

    favoriteImage(String hash) {
      http.post(
        'https://api.imgur.com/3/image/$hash/favorite',
        headers: {
          HttpHeaders.authorizationHeader:
          "Bearer " + global.urlParams['access_token']
        },
      ).then((response) {
        print(response.body);
        setState(() {});
      });
    }

    IconButton favButtonState(int index) {
      Color isFav;
      Icon iscon;

      if (widget.images.data[index].favorite) {
        iscon = Icon(Icons.favorite);
        isFav = Colors.redAccent;
      } else {
        iscon = Icon(Icons.favorite_border);
        isFav = Color.fromRGBO(226, 228, 233, 100);
      }
      return IconButton(
          icon: iscon,
          color: isFav,
          onPressed: () {
            favoriteImage(widget.images.data[index].cover);
            if (widget.images.data[index].favorite)
              widget.images.data[index].favorite = false;
            else
              widget.images.data[index].favorite = true;
            setState(() {});
          });
    }

    for (int i = 0; i < widget.images.data.length; i++) {
      if (widget.images.data[i].images == null ||
          (widget.images.data[i].images.first.type != 'image/jpeg' &&
              widget.images.data[i].images.first.type != 'image/png')) {
        widget.images.data.removeAt(i);
        i--;
      }
    }
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: widget.images.data.length,
      itemBuilder: (context, index) {
        return new Column(
          children: <Widget>[
            new ClipRRect(
                borderRadius: new BorderRadius.circular(10.0),
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.images.data[index].images.first.link
                              .replaceFirst('.png', 'l.png')
                              .replaceFirst('.jpeg', 'l.jpeg')
                              .replaceFirst('.jpg', 'l.jpg'),
                          fadeInDuration: new Duration(milliseconds: 200),
                          fadeInCurve: Curves.linear,
                          fit: BoxFit.contain,
                        ),
                      ),
                      new Container(
                        width: double.infinity,
                        child: new Text(widget.images.data[index].title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.redAccent,
                            )),
                        padding: EdgeInsets.all(10.0),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: favButtonState(index),
                              )
                            ],
                          ),
                          new Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.visibility,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                  child: new Text(NumberFormat.compact()
                                      .format(widget.images.data[index].views),
                                      style: TextStyle(
                                          color: Colors.redAccent
                                      )),
                                ),
                              ]),
                        ],
                      ),
                    ],
                  ),
                  color: Color.fromRGBO(51, 53, 58, 100),
                )),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Container(height: 10),
    );
  }
}

class getGalleryPic {
  List<Data> data;
  bool success;
  int status;

  getGalleryPic({this.data, this.success, this.status});

  getGalleryPic.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String id;
  String title;
  String cover;
  int views;
  String link;
  String vote;
  bool favorite;
  int ups;
  int downs;
  List<Images> images;

  Data(
      {this.id,
        this.title,
        this.cover,
        this.views,
        this.link,
        this.vote,
        this.favorite,
        this.ups,
        this.downs,
        this.images});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    views = json['views'];
    link = json['link'];
    vote = json['vote'];
    favorite = json['favorite'];
    ups = json['ups'];
    downs = json['downs'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['views'] = this.views;
    data['link'] = this.link;
    data['vote'] = this.vote;
    data['favorite'] = this.favorite;
    data['ups'] = this.ups;
    data['downs'] = this.downs;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String type;
  String link;

  Images({this.type, this.link});

  Images.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['link'] = this.link;
    return data;
  }
}