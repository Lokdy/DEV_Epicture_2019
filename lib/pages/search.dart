import 'dart:convert';
import 'dart:io';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:imgur_like/format/gallery.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imgur_like/main.dart' as global;

String input;

class searchResult extends StatefulWidget {
  @override
  _searchResult createState() => _searchResult();
}

class _searchResult extends State<searchResult> {
  getGalleryPic images;
  String searched;
  String searchGallery = 'https://api.imgur.com/3/gallery/search/';
  int page = 0;
  String inputText = input;

  _searchResult() {

    if (inputText != null && inputText != "")
      searchPics(selectedSort.toLowerCase(),
          selectedWindow.toLowerCase(), inputText, selectedType);
    searched = inputText;
  }

  void searchPics(String sort, String window, String search, String type) {
    String searchRequest;
    if (type == null)
      searchRequest =
          searchGallery + '$sort/$window/${page.toString()}?q_all=$search';
    else
      searchRequest = searchGallery +
          '$sort/$window/${page.toString()}?q_all=$search&q_type=${type.toLowerCase()}';
    http.get(
      searchRequest,
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
    searchPics(selectedSort.toLowerCase(), selectedWindow.toLowerCase(),
        searched, selectedType);
  }

  bool onSearch = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("\"$inputText\""),
        centerTitle: true,
      ),
      body: new Center(child: new Builder(builder: (context) {
        if (images != null)
          return Column(
            children: <Widget>[
              Expanded(
                child: SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: false,
                  controller: _refreshController,
                  child: imageGallery(images: images),
                  onLoading: _onLoading,
                ),
              ),
            ],
          );
        else
          return Column();
      })),
    );
  }
  String selectedSort = 'Top';
  String selectedWindow = 'All';
  String selectedType;
}

class searchPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search',
            style: TextStyle(fontSize: 24,
                color: Colors.redAccent
            )
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Container(
              constraints: BoxConstraints.tightFor(width: 200.0, height: 200.0),
              child: Image.asset(
                "assets/images/search.png",
                fit: BoxFit.scaleDown,
              )
          ),
          ListTile(
            title: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Eg memes",
                labelText: "Type a category",
                contentPadding:
                const EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 25.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          ListTile(
            title: MaterialButton(
                onPressed: () {
                  input = searchController.text;
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => searchResult()));
                },
                child: Text(
                  "Search",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 30
                  ),
                ),
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
          )
        ],
      ),
    );
  }
}