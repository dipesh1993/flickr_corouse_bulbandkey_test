import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flickr_corouse_bulbandkey_test/screens/reviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../helper/DatabaseHelper.dart';
import '../models/imageModel.dart';

class ImageList extends StatefulWidget {
  final List<ImageModel> images;

  const ImageList({Key key, this.images}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  var titleWithReviews, ratings;

  StreamController<List> _streamController = StreamController<List>();

  Future getData() async {
    List data = await DatabaseHelper.instance.retrieveInspection();
    print(data);
    //Add your data to stream
    _streamController.add(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasData) {
                for (int i = 0; i < snapshot.data.length; i++) {
                  titleWithReviews = snapshot?.data[i].title;
                  ratings = snapshot?.data[i].rating;
                  print(titleWithReviews);
                }
                return CarouselSlider.builder(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                  ),
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      InkWell(
                    onTap: () =>
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                                  imgLink: widget.images[itemIndex].media.m,
                                  title: widget.images[itemIndex].title,
                                ))),
                    child: Column(
                      children: <Widget>[
                        // Container(
                        //   child: Text(
                        //     widget.images[itemIndex].title,
                        //     style: TextStyle(color: Colors.red),
                        //   ),
                        // ),
                        Expanded(
                          child: Image.network(
                            widget.images[itemIndex].media.m,
                            width: 1000,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          child: titleWithReviews
                                  .contains(widget.images[itemIndex].title)
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RatingBar.builder(
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    initialRating: double.tryParse(ratings),
                                    unratedColor: Colors.white,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("")),
                          // style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Text("Oops!");
          }
        });
  }
}
