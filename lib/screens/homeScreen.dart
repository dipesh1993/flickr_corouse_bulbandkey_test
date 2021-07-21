
import 'dart:convert';

import 'package:flickr_corouse_bulbandkey_test/screens/imageList.dart';
import 'package:flickr_corouse_bulbandkey_test/models/imageModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items;
  List<ImageModel> images = new List();
  bool isLoading = true;

  void fetchJson() async {
    print("fetchJson called");
    final response = await get(Uri.parse(
        "https://api.flickr.com/services/feeds/photos_public.gne?tags=food&format=json&nojsoncallback=1"));
    var data = jsonDecode(response.body);
    var output = data['items'] as List;

    setState(() {
      images =
          output.map<ImageModel>((json) => ImageModel.fromJson(json)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlickrImages"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? CircularProgressIndicator()
            : ImageList(images: images),
      ),
    );
  }
}
