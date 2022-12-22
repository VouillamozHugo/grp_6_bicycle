import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/Map/adminAddRoute.dart';
import 'package:grp_6_bicycle/Map/created_routes.dart';
import 'package:grp_6_bicycle/Map/favorite_routes.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'package:grp_6_bicycle/login/login_page.dart';
import 'package:grp_6_bicycle/login/register_page.dart';

class RouteNames {
  static final Map<String, Widget Function(BuildContext)> routes = {
    //cycling routes
    allRoutes: (context) => const AllRoutes(),
    drawRoutes: (context) => const AdminMap(),
    favoriteRoutes: (context) => const FavoriteRoutes(),

    //register / login
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),

    //admin
    createdRoutes: (context) => const CreatedRoutes(),
  };

  //cycling routes
  static const String favoriteRoutes = "favoriteRoutes";
  static const String allRoutes = "allRoutes";
  static const String drawRoutes = "drawRoutes";

  //login / register
  static const String login = "login";
  static const String register = "register";

  //admin
  static const String createdRoutes = "createdRoutes";
}
