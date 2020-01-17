import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, String>> fetchLocations() async {
  final response =
      await http.get('http://service.finder.mezyapps.com/ws_location');

  var locations = <String, String>{};

  if (response.statusCode == 200) {
    final locationList =
        Locations.fromJson(json.decode(response.body)).locationList;
    for (var location in locationList) {
      var locationObject = Location.fromJson(location);
      // print(locationObject.locationName);
      locations[locationObject.id] = locationObject.locationName;
    }
    // print(locations);
    // return Locations.fromJson(json.decode(response.body));
    return locations;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load');
  }
}

Future<Map<String, String>> fetchRoutes(
    String locationName, Map<String, String> locations) async {
  // print("ids location name : ${locationName}");
  // print("locations : ${locations}");

  var id = int.parse(
      locations.keys.firstWhere((k) => locations["$k"] == locationName));
  // print(id.runtimeType);
  // print("ID of ${locationName} is ${id}");

  var response =
      await http.post(Uri.parse("http://service.finder.mezyapps.com/ws_route/$id"));

  var routes = <String, String>{};

  if (response.statusCode == 200) {
    var allRoutes = Routes.fromJson(json.decode(response.body)).routeList;
    for (var route in allRoutes) {
      // print(route);
      var routeObject = Route.fromJson(route);
      routes[routeObject.id] = routeObject.routeName;
    }
    // print("routes: ${routes}");
    return routes;
  } else {
    throw Exception('Failed to load');
  }
}

class Locations {
  final int code;
  final String msg;
  final List locationList;

  Locations({this.code, this.msg, this.locationList});

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      locationList: json['location_list'],
    );
  }
}

class Routes {
  final List routeList;

  Routes({this.routeList});

  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      routeList: json['route_list'],
    );
  }
}

class Location {
  final String id;
  final String code;
  final String locationName;

  Location({this.id, this.code, this.locationName});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      code: json['code'],
      locationName: json['location_name'],
    );
  }
}

class Route {
  final String id;
  final String code;
  final String routeName;

  Route({this.id, this.code, this.routeName});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['route_id'],
      code: json['route_code'],
      routeName: json['route_name'],
    );
  }
}
