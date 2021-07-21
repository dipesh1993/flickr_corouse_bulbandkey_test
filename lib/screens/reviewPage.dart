import 'package:flickr_corouse_bulbandkey_test/helper/DatabaseHelper.dart';
import 'package:flickr_corouse_bulbandkey_test/screens/imageList.dart';
import 'package:flickr_corouse_bulbandkey_test/models/reviewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class ReviewScreen extends StatefulWidget {
  final String imgLink, title;

  const ReviewScreen({Key key, @required this.imgLink, this.title})
      : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ReviewModel reviewModel;

  GlobalKey<FormState> _key = new GlobalKey();
  bool isLoading = false; // variable to check state
  final _ratingBy = TextEditingController();
  final _reasonForRating = TextEditingController();

  bool _validate = false;

  bool _isDataUploaded = false;
  double rating;
  int starCount = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isDataUploaded,
      child: Scaffold(
        backgroundColor: Colors.black12,

        body: Center(
          child: Container(
            child: SingleChildScrollView(
              child: formUI(),
            ),
          ),
        ),
        //),
      ),
    );
  }

  Widget formUI() {
    return Form(
      key: _key,
      autovalidate: _validate,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              widget.title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: widget.imgLink == null
                      ? AssetImage('assets/images/addimage.png')
                      : NetworkImage(widget.imgLink),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildCard(false, _ratingBy, _validateRatingBy, "Rating By"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RatingBar.builder(
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              unratedColor: Colors.white,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (r) {
                rating = r;
                print(rating);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildCard(false, _reasonForRating, _validateReasonFor,
                "Reason For Rating"),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.blueAccent,
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.black)),
              child: FlatButton(

                  // color: Theme.of(context).buttonColor,
                  textColor: Colors.black,
                  child: Text("Submit"),
                  onPressed: () async {
                    saveToSharedPref();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  saveToSharedPref() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      if (rating != null) {
        _saveData();
        setState(() {
          _isDataUploaded = true;
        });
      }
      else
        {
Toast.show("Please specify Rating", context);
        }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  _saveData() async {
    if (reviewModel == null) {
      DatabaseHelper.instance.insertInspection(ReviewModel(
        title: widget.title,
        rating: rating.toString(),
        ratingBy: _ratingBy.text.toString(),
        reasonOfRating: _reasonForRating.text.toString(),
      ));
      setState(() {
        _isDataUploaded = false;
      });
    } else {
      await DatabaseHelper.instance
          .updateInspection(ReviewModel(id: reviewModel.id));
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => ImageList(
          )));    }

    setState(() {
      _isDataUploaded = false;
    });
    Navigator.pop(context);
  }

  String _validateRatingBy(String value) {
    if (value.length == 0) {
      return "Rating By is Required";
    } else {
      return null;
    }
  }

  String _validateReasonFor(String value) {
    if (value.length == 0) {
      return "Reason For Rating is Required";
    } else {
      return null;
    }
  }

  Card buildCard(bool val, TextEditingController controllerName, _validatorName,
      String lblText) {
    return Card(
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          side: BorderSide(color: Colors.black)),
      child: TextFormField(
        readOnly: val,
        controller: controllerName,
        // validator: _validatorName,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        style: new TextStyle(color: Colors.black),
        // initialValue: "${_center.latitude},${_center.longitude}",
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: lblText),
        onSaved: (String val) {
          setState(() {});
        },
      ),
    );
  }
}
