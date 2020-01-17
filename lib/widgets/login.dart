import 'dart:io';
import 'package:flutter/material.dart';
import '../functions.dart';
import './signup.dart';
import '../home.dart';

class UserLogin extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailEditingContrller = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'ProductSans', fontSize: 20.0);

  String _number;
  String _password;
  var snackBar;

  Map<String, dynamic> map() => {
        "number": _number,
        "password": _password,
      };

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      title: new Center(
        child: new Text(
          "Service Finder",
        ),
      ),
      automaticallyImplyLeading: false,
    );

    final numberField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          _number = "";
          return "Please enter a mobile number";
        }
        _number = value;
        return null;
      },
      autofocus: false,
      keyboardType: TextInputType.phone,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mobile Number *",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final passwordField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          _password = "";
          return "Please enter a password";
        }
        _password = value;
        return null;
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password *",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final forgotPassword = FlatButton(
      child: Text(
        "Reset password",
        textAlign: TextAlign.right,
      ),
      onPressed: () {
        print("reset password");
      },
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            performLogin(map()).then((msg) async {
              print(msg);
              if (msg == "Check User Name and Password" ||
                  msg == "User Does Not Exist") {
                snackBar = SnackBar(
                  content: Text(
                    "$msg",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: "ProductSans"),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 6.0,
                  backgroundColor: Colors.red,
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
              } else {
                snackBar = SnackBar(
                  content: Text(
                    "$msg",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: "ProductSans"),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 6.0,
                  backgroundColor: Colors.green,
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Home(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 2.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
                
              }
            });
          } else {
            snackBar = SnackBar(
              content: Text(
                "Please fill all details",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: "ProductSans"),
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              elevation: 6.0,
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final bottomText = FlatButton(
      child: Text("Dont have an account? Signup here"),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                UserSignup(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 2.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    );

    Future<bool> onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Do you really want to quit the app?",
            style: style,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "No",
                style: style,
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text(
                "Yes",
                style: style,
              ),
              onPressed: () => exit(0),
            )
          ],
        ),
      );
    }


    return WillPopScope(
      onWillPop: onBackPressed,
          child: Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: _scaffoldKey,
        appBar: appBar,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 100, 36, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 80.0,
                        child: Text(
                          'Login',
                          style:
                              TextStyle(fontSize: 60, fontFamily: 'ProductSans',color: Theme.of(context).primaryColor),
                        ),
                      ),
                      SizedBox(height: 45.0),
                      numberField,
                      SizedBox(height: 25.0),
                      passwordField,
                      forgotPassword,
                      SizedBox(height: 35.0),
                      loginButon,
                      SizedBox(height: 15.0),
                      SizedBox(height: 15.0),
                      bottomText,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
