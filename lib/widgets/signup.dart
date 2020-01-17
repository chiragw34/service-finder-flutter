import 'package:flutter/material.dart';
import './login.dart';
import 'dart:async';
import '../ids.dart';
import '../functions.dart';

class UserSignup extends StatefulWidget {
  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _selectedLocation;
  String _selectedRoute;
  List<String> lnames = [];
  List<String> rnames = [];
  Future<Map<String, String>> locations;
  Future<Map<String, String>> routes;
  String _name;
  String _number;
  String _email;
  String _address;
  String _location;
  String _route;
  String _password;
  String _cpassword;
  var routeText;
  var locationObject;
  var routeObject;
  var snackBar;

  TextEditingController emailEditingContrller = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'ProductSans', fontSize: 20.0);

  Map<String, dynamic> map() => {
        "name": _name,
        "number": _number,
        "email": _email,
        "address": _address,
        "location": _location,
        "route": _route,
        "password": _password,
        "confirmPassword": _cpassword
      };

  var locationButton = DropdownButton(
    hint: Text('Please choose a location'),
    value: "none",
    items: [],
    onChanged: (newValue) {},
  );

  var routeButton = DropdownButton(
    hint: Text('Please choose a route'),
    value: "none",
    items: [],
    onChanged: (newValue) {},
  );

  @override
  initState() {
    super.initState();
    locations = fetchLocations();
    locations.then((l) {
      setState(() {
        lnames = l.values.toList();
        locationButton = DropdownButton(
          hint: Text('Please choose a location'),
          value: null,
          items: <String>[...lnames].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            changeRoute();
            setState(() {
              this._selectedLocation = newValue;
              setState(() {
                _route = null;
                routeText = Text(
                  "Selected route: ",
                  textScaleFactor: 1.45,
                );
              });
              fetchRoutes(_selectedLocation, l).then((r) {
                setState(() {
                  locationObject = l;
                  routeObject = r;
                  rnames = r.values.toList();
                  routeButton = DropdownButton(
                    hint: Text("Please select a route"),
                    value: null,
                    items: <String>[...rnames].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        this._selectedRoute = newValue;
                      });
                    },
                  );
                });
              });
            });
          },
        );
        // print(_selectedLocation);
      });
    });
  }

  void changeRoute() {
    print("changing route");
    setState(() {
      this._route = "";
      this._selectedRoute = "";
    });
    _route = "";
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColor,
      title: Center(
        child: Text(
          "Service Finder",
        ),
      ),
    );

    final nameField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Name should not be empty';
        }
        _name = value;
        return null;
      },
      keyboardType: TextInputType.text,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name *",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final numberField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Mobile number should not be empty';
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

    final emailField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          _email = "";
          return null;
        }
        _email = value;
        return null;
      },
      style: style,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final addressField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          _address = "";
          return null;
        }
        _address = value;
        return null;
      },
      keyboardType: TextInputType.text,
      minLines: 2,
      maxLines: 5,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Address",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    // print(lnames.length);
    // print(_selectedLocation);
    // print("button value ${button.value}");
    final locationField = locationButton;
    _location = _selectedLocation == null ? "" : _selectedLocation;

    final locationText = Text(
      "Selected location: ${_location}",
      textScaleFactor: 1.45,
    );
    print(lnames);
    print(rnames);

    var routeField = routeButton;
    _route = _selectedRoute == null ? "" : _selectedRoute;

    routeText = Text(
      "Selected route: ${_route}",
      textScaleFactor: 1.45,
    );

    final passwordField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          _password = "";
          return 'Password should not be empty';
        }
        _password = value;
        return null;
      },
      onSaved: (val) => _password = val,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password *",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final confirmPasswordField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          _cpassword = "";
          return 'Password should not be empty';
        } else if (value != _password) {
          _cpassword = "";
          return 'Passwords must match';
        }
        _cpassword = value;
        return null;
      },
      onSaved: (val) => _cpassword = val,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password *",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final signupButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a Snackbar.
            performSignup(map(), locationObject, routeObject).then((msg) async {
              if (msg == "User Already Exist") {
                snackBar = SnackBar(
                  content: Text(
                    "${msg}. Please use a different mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: "ProductSans"),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 6.0,
                  backgroundColor: Theme.of(context).errorColor,
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
              } else {
                snackBar = SnackBar(
                  content: Text(
                    "${msg}",
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
              backgroundColor: Theme.of(context).errorColor,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        },
        child: Text("Signup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold)),
      ),
    );

    final bottomText = FlatButton(
        child: Text("Already a user? Login here"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return new UserLogin();
            }),
          );
        });

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 36, 36, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80.0,
                      child: Text(
                        'Signup',
                        style:
                            TextStyle(fontSize: 60, fontFamily: 'ProductSans',color: Theme.of(context).primaryColor),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    nameField,
                    SizedBox(height: 25.0),
                    numberField,
                    SizedBox(height: 25.0),
                    emailField,
                    SizedBox(height: 25.0),
                    addressField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(height: 25.0),
                    confirmPasswordField,
                    SizedBox(height: 35.0),
                    locationField,
                    locationText,
                    SizedBox(height: 25.0),
                    routeField,
                    routeText,
                    SizedBox(height: 35.0),
                    signupButon,
                    SizedBox(height: 15.0),
                    bottomText,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
