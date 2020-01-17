import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> performSignup(map, locationObject, routeObject) async {
  var locationId = int.parse(locationObject.keys
      .firstWhere((k) => locationObject["$k"] == map["location"]));

  var routeId = int.parse(
      routeObject.keys.firstWhere((k) => routeObject["$k"] == map["route"]));

  Map<String, String> data = {
    "name": map["name"].toString(),
    "mobile_no": map["number"].toString(),
    "password": map["password"].toString(),
    "email": map["email"].toString(),
    "address": map["address"].toString(),
    "location_id": locationId.toString(),
    "route_id": routeId.toString()
  };

  var response = await http.post(
      Uri.parse("http://service.finder.mezyapps.com/ws_sign_in"),
      body: data);

  if (response.statusCode == 200) {
    if (jsonDecode(response.body)["msg"] == "User Already Exist") {
      return jsonDecode(response.body)["msg"].toString();
    }

    if (jsonDecode(response.body)["msg"] == "success") {
      return "Sign up Successful! Now please log in by going back";
    }
  } else {
    return 'Failed to load';
  }
  return "error";
}

Future<String> performLogin(map) async {
  Map<String, String> data = {
    "mobile_no": map["number"].toString(),
    "password": map["password"].toString(),
  };

  var response = await http.post(
      Uri.parse("http://service.finder.mezyapps.com/ws_login"),
      body: data);
  print(jsonDecode(response.body));

  if (response.statusCode == 200) {
    // print("successfull");
    // print(jsonDecode(response.body)["msg"]);

    if (jsonDecode(response.body)["msg"] == "Check User Name and Password") {
      // print("error");
      return jsonDecode(response.body)["msg"].toString();
    }

    if (jsonDecode(response.body)["msg"] == "success") {
      addToSF(json.decode(response.body)["login"][0]).then((_) {
        print("Success");
      });
      return "Login Successful";
    }

    if (jsonDecode(response.body)["msg"] == "User Does Not Exist") {
      return jsonDecode(response.body)["msg"];
    }

    print(jsonDecode(response.body));
  } else {
    print(jsonDecode(response.body)["msg"].toString());
    return jsonDecode(response.body)["msg"].toString();
  }
  return "error";
}

Future<void> addToSF(Map<String, dynamic> details) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("login", true);
  prefs.setString("id", details["id"]);
  prefs.setString("name", details["name"]);
  prefs.setString("address", details["address"]);
  prefs.setString("mobile_no", details["mobile_no"]);
  prefs.setString("location_id", details["location_id"]);
  prefs.setString("route_id", details["route_id"]);

  print("login status : ${prefs.getBool("login")}");
}

Future<String> checkUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("checking shared preferences... : ${prefs.getBool("login")}");

  if (prefs.getBool("login") == true) {
    return "true";
  } else {
    return "false";
  }
}

Future<dynamic> fetchBussinessCategory() async {
  var response = await http
      .get('http://service.finder.mezyapps.com/ws_bussiness_category');
  var categories = json.decode(response.body)["list_bussiness_catagory"];

  List cnames = [];

  for (var category in categories) {
    cnames.add(category["name"]);
  }

  // print("inside functions : ${cnames}");
  return cnames;
}

Future<Map> fetchServices(String selectedCategory, List cnames) async {
  var response = await http
      .get('http://service.finder.mezyapps.com/ws_bussiness_category');
  var categories = json.decode(response.body)["list_bussiness_catagory"];
  var categoryId;

  for (var category in categories) {
    if (category["name"] == selectedCategory) {
      categoryId = category["id"];
      break;
    }
  }
  print("selected category:{ $categoryId : $selectedCategory }");

  var request = await http.post(
      Uri.parse("http://service.finder.mezyapps.com/ws_services_list"),
      body: {"id": categoryId.toString()});

  var servicesList = json.decode(request.body)["services_list"];

  var servicesObject = {};

  for (var service in servicesList) {
    servicesObject["${service["id"]}"] = service["name"];
  }

  print("returning services : ${servicesObject}");
  return servicesObject;
}


Future<void> performLogout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("login", false);
  prefs.setString("id", "");
  prefs.setString("name","");
  prefs.setString("address", "");
  prefs.setString("mobile_no", "");
  prefs.setString("location_id", "");
  prefs.setString("route_id", "");
}