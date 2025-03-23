  import 'package:eco_recycler/presentation/account/profile.dart';
  import 'package:eco_recycler/presentation/cancel_reason/cancel_reason.dart';
  import 'package:eco_recycler/presentation/login/login.dart';
  import 'package:eco_recycler/presentation/pickup/all_pickups.dart';
  import 'package:eco_recycler/presentation/pickup/completed_pickup.dart';
  import 'package:eco_recycler/presentation/pickup/pickup_details.dart';
  import 'package:eco_recycler/presentation/pickup/upcoming_pickup.dart';
  import 'package:eco_recycler/presentation/splash_screen/splash_screen.dart';
  import 'package:flutter/material.dart';

  class AppRoutes {
    static const String splashScreen = '/splash_screen';
    static const String login = '/login';
    static const String profile = '/profile';
    static const String pickupDetails = '/pickup_details';
    static const String cancelReason = '/cancel_reason';
    static const String upcomingPickup = '/upcoming_pickup';
    static const String allPickup = '/all_pickup';
    static const String completedPickup = '/completed_pickup';

    //static const String appNavigationScreen = '/app_navigation_screen';
    static const String initialRoute = '/initialRoute';

    static Map<String, WidgetBuilder> routes = {
      splashScreen: (context) => SplashScreen(),
      login: (context) => LoginScreen(),
      upcomingPickup: (context) => UpcomingScreen(),
      allPickup: (context) => AllpickupScreen(),
      profile: (context) => ProfileScreen(),
      initialRoute: (context) => SplashScreen(),
    };

    static Route<dynamic> onGenerateRoute(RouteSettings settings) {
      switch (settings.name) {
        case pickupDetails:
          final args = settings.arguments as String;
          return MaterialPageRoute(
              builder: (context) => PickUpDetailsScreen(pickupId: args));
        case completedPickup:
          final args = settings.arguments as String;
          return MaterialPageRoute(
              builder: (context) => CompletedScreen(pickupId: args));
        case cancelReason:
          final args = settings.arguments as String;
          return MaterialPageRoute(
              builder: (context) => CancellationReasonScreen(pickupId: args));
        default:
          return MaterialPageRoute(
            builder: (context) =>
                SplashScreen(), // Default to K0Screen if route is not found
          );
      }
    }
  }
