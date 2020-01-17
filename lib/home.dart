import 'dart:io';
import './widgets/login.dart';
import 'package:flutter/material.dart';
import './functions.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextStyle style = TextStyle(fontFamily: 'ProductSans', fontSize: 20.0);

  var _selectedCategory;
  var services;
  var servicesField;
  List<String> categoryNames = [""];
  Map _value = {};
  var allServiceObject;

  @override
  Widget build(BuildContext context) {
    fetchBussinessCategory().then((cnames) async {
      categoryNames = [];
      for (var cname in cnames) {
        setState(() {
          categoryNames.add(cname);
        });
      }

      // print(categoryNames);
    }).catchError((onError) {
      print("$onError");
    });

    final headerText = SizedBox(
      height: 80.0,
      child: Text(
        'Service Finder',
        style: TextStyle(
            fontSize: 60,
            fontFamily: 'ProductSans',
            color: Theme.of(context).primaryColor),
      ),
    );

    final businessText = Text(
      "Select a business category",
      style: style,
    );

    final bussinessField = FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              labelStyle: style,
              errorStyle: TextStyle(color: Theme.of(context).errorColor, fontSize: 16.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: _selectedCategory == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isDense: true,
              onChanged: (String newValue) {
                _value = {};
                setState(() {
                  _selectedCategory = newValue;
                  state.didChange(newValue);
                });
                fetchServices(_selectedCategory, categoryNames)
                    .then((serviceObject) {
                  setState(() {
                    services = serviceObject;
                  });
                });
              },
              items: categoryNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: style,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final servicesText = Text(
      "Select services",
      style: style,
    );

    setState(() {
      servicesField = services == null
          ? [
              ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey[100],
                label: Text("Please select a business category"),
                selected: false,
                onSelected: (bool selected) {},
              )
            ]
          : [
              ...services.values.map((f) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(2, 3, 2, 10),
                  child: ChoiceChip(
                    elevation: 5,
                    pressElevation: 0.0,
                    selectedColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey[50],
                    label: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                      child: Text(
                        "$f",
                        style: TextStyle(
                          fontFamily: 'ProductSans',
                          fontSize: 20.0,
                          color: _value["$f"] == true
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Colors.black,
                        ),
                      ),
                    ),
                    onSelected: (bool selected) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _value["$f"] = selected ? true : false;
                      });
                    },
                    selected: _value["$f"] == null ? false : _value["$f"],
                  ),
                );
              }),
            ];
    });

    final submitButon = Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            print("_value $_value");
          },
          child: Text(
            "Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
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

    Future<bool> onLogoutPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Do you really want to logout?",
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
              onPressed: () => {
                performLogout().then((_) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          UserLogin(),
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
                })
              },
            )
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: onBackPressed,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Text("Home"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
              child: IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: onLogoutPressed,
                iconSize: 27,
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 50, 36, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    headerText,
                    SizedBox(height: 50.0),
                    businessText,
                    SizedBox(height: 10.0),
                    bussinessField,
                    SizedBox(height: 30.0),
                    servicesText,
                    SizedBox(height: 10.0),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: <Widget>[...servicesField],
                    ),
                    SizedBox(height: 100.0),
                    submitButon
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
