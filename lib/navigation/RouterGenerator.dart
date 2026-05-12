import 'package:flutter/material.dart';
import 'package:spire_wiki/screens/favorites.dart';
import 'package:spire_wiki/screens/login.dart';

import '../models/Item.dart';
import 'AppRoutes.dart';
import '../screens/signup.dart';
import '../screens/details.dart';
import '../screens/home.dart';

class RouterGenerator {

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LogInScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen()); //=> Route
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => FavoritesScreen()); //=> Route
      case AppRoutes.details:
       final args = settings.arguments as Item;
       return MaterialPageRoute(builder: (_) => DetailsScreen(item: args));
       default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ));
    }
  }

}