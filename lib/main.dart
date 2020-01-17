import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './widgets/login.dart';
import './functions.dart';
import './home.dart';

// x-x-x-x-x-x-x-x-x-x--x-x-x-x-x-x-x-x-x-x-x-x-x-x--x-x-x-x-x-x-x-x-x-x-x-x-

var body;
void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
        errorColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        fontFamily: 'ProductSans',
      ),
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));

  checkUser().then((msg) {
    if (msg == "true") {
      body = new Home();
    } else {
      body = new UserLogin();
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new AfterSplash(),
      image: new Image.asset("assets/images/logo2.png"),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 120.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: body);
  }
}
