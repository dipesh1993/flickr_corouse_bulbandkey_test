import 'package:flickr_corouse_bulbandkey_test/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    });
  }
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(onWillPop: onWillPop,
        child:SafeArea(
          child: new Center(
            child: new AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: new Duration(milliseconds: 500),
              child: Container(
                color: Colors.blue[50],
                child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text("F", style: TextStyle(color: Colors.blue[900],fontSize: 70)),
                              Text("licker", style: TextStyle(height:2,color: Colors.blue[200],fontSize: 40)),
                              SizedBox(
                                width: 20,
                              ),

                              Text("A", style: TextStyle(color: Colors.blue[900],fontSize: 70)),
                              Text("pp", style: TextStyle(height:2,color: Colors.blue[200],fontSize: 40)),
                            ],
                          ),

                        ],
                      )]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("Please Press again to exit", context,
          duration: Toast.LENGTH_LONG);

      return Future.value(false);
    }
    return Future.value(true);
  }

}
