import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imgur_like/main.dart' as global;

class accountPage extends StatefulWidget {
  @override
  _accountPage createState() => _accountPage();
}

class _accountPage extends State<accountPage> {
  var profilImage;
  var userPic;
  var userFav;
  File _image;

  final inputDesc = TextEditingController();

  @override
  void dispose() {
    inputDesc.dispose();
    super.dispose();
  }

  Future getPic() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null)
      setState(() {
        _image = image;
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Upload to Imgur'),
                  titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  backgroundColor: Theme.of(context).canvasColor,
                  content: Image.file(_image),
                  actions: <Widget>[
                    Container(
                        child: new TextField(
                          style: new TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                          controller: inputDesc,
                          decoration: new InputDecoration(
                              hintText: "Description...",
                              hintStyle: new TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18
                              )
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        width: 235),
                    FlatButton(
                      onPressed: () {
                        uploadPic(_image, inputDesc.text);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ));
      });
  }

  _accountPage() {
    http.get(
      'https://api.imgur.com/3/account/${global.urlParams['account_username']}/avatar',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + global.urlParams['access_token']
      },
    ).then((response) {
      setState(() {
        profilImage = json.decode(response.body)["data"]["avatar"];
      });
    });
    getProfilImages();
    getFavs();
  }

  getProfilImages() {
    http.get(
      'https://api.imgur.com/3/account/me/images',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + global.urlParams['access_token']
      },
    ).then((response) {
      setState(() {
        userPic = json.decode(response.body)['data'];
      });
    });
  }

  getFavs() {
    http.get(
      'https://api.imgur.com/3/account/${global.urlParams['account_username']}/favorites/0/',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + global.urlParams['access_token']
      },
    ).then((response) {
      setState(() {
        userFav = json.decode(response.body)['data'];
      });
    });
  }

  unfavPic(String hash) {
    http.post(
      'https://api.imgur.com/3/image/$hash/favorite',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer " + global.urlParams['access_token']
      },
    ).then((response) {
      setState(() {
        getFavs();
      });
    });
  }

  uploadPic(File image, String description) {
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    http.post('https://api.imgur.com/3/upload', headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + global.urlParams['access_token']
    }, body: {
      'image': base64Image,
      'type': 'base64',
      'description': description
    }).then((response) {
      setState(() {
        getProfilImages();
      });
    });
  }

  Container favGallery(int index) {
    return Container(
        padding: EdgeInsets.all(2),
        child: GestureDetector(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: userFav[index]['link']
                .toString()
                .replaceFirst('.png', 'm.png')
                .replaceFirst('.jpeg', 'm.jpeg')
                .replaceFirst('.jpg', 'm.jpg'),
            fadeInDuration: new Duration(milliseconds: 200),
            fadeInCurve: Curves.linear,
            fit: BoxFit.cover,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(userFav[index]['title'].toString()),
                      titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      backgroundColor: Theme.of(context).canvasColor,
                      content: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: userFav[index]['link']
                            .toString()
                            .replaceFirst('.png', 'l.png')
                            .replaceFirst('.jpeg', 'l.jpeg')
                            .replaceFirst('.jpg', 'l.jpg'),
                      ),
                      actions: <Widget>[
                        FlatButton.icon(
                          onPressed: () {
                            unfavPic(userFav[index]['cover']);
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.delete,
                              size: 22,
                              color: Colors.redAccent
                          ),
                          label: Text(
                            'Remove Favorites',
                            style: TextStyle(
                                color: Colors.redAccent
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ));
          },
        ));
  }

  Container uploadedPicGallery(int index) {
    return Container(
        padding: EdgeInsets.all(2),
        child: GestureDetector(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: userPic[index]['link']
                .toString()
                .replaceFirst('.png', 'm.png')
                .replaceFirst('.jpeg', 'm.jpeg')
                .replaceFirst('.jpg', 'm.jpg'),
            fadeInDuration: new Duration(milliseconds: 200),
            fadeInCurve: Curves.linear,
            fit: BoxFit.cover,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(userPic[index]['description'].toString()),
                      titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      backgroundColor: Color.fromRGBO(51, 53, 58, 1),
                      content: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: userPic[index]['link']
                            .toString()
                            .replaceFirst('.png', 'l.png')
                            .replaceFirst('.jpeg', 'l.jpeg')
                            .replaceFirst('.jpg', 'l.jpg'),
                      ),
                    ));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Your Account',
            style: TextStyle(fontSize: 24,
            color: Colors.redAccent
            )
        ),
        centerTitle: true,
      ),
      body: new Center(child: new Builder(builder: (context) {
        if (profilImage == null || userPic == null || userFav == null) {
          return CircularProgressIndicator();
        } else {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 5,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(profilImage)))),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Center(
                      child: Text(global.urlParams['account_username'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          )),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: TabBar(
                        tabs: [
                          Tab(
                              icon: Icon(Icons.photo_library,
                                  size: 30,
                                  color: Colors.redAccent),
                              text: 'My Images'),
                          Tab(
                              icon: Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              text: 'My Favorites'),
                        ],
                      ),
                      body: TabBarView(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: GridView.builder(
                                  itemCount: userPic.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    return uploadedPicGallery(index);
                                  }),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: GridView.builder(
                                  itemCount: userFav.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    return favGallery(index);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
      })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getPic();
        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
            'Upload Photo',
            style: TextStyle(
                color: Colors.redAccent
            )
        ),
        icon: Icon(
            Icons.add_a_photo,
            size: 25,
            color: Colors.redAccent
        ),
      ),
    );
  }
}