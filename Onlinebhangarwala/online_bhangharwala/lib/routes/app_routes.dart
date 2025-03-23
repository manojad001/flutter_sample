import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/about_us/about_us.dart';
import 'package:online_bhangharwala/presentation/add_address/add_address.dart';
import 'package:online_bhangharwala/presentation/calculator/calculator.dart';
import 'package:online_bhangharwala/presentation/change_pickup_address/change_pickup_address.dart';
import 'package:online_bhangharwala/presentation/confirm_pickup/confirm_pickup.dart';
import 'package:online_bhangharwala/presentation/confirmation/confirmation.dart';
import 'package:online_bhangharwala/presentation/edit_address/edit_address.dart';
import 'package:online_bhangharwala/presentation/k5_screen/k5_screen.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';
import 'package:online_bhangharwala/presentation/map_screen/map_screen.dart';
import 'package:online_bhangharwala/presentation/my_account/my_account.dart';
import 'package:online_bhangharwala/presentation/offer/offer.dart';
import 'package:online_bhangharwala/presentation/payment/payment.dart';
import 'package:online_bhangharwala/presentation/pickup_datetime/pickup_datetime.dart';
import 'package:online_bhangharwala/presentation/pickup_request/completecancelled.dart';
import 'package:online_bhangharwala/presentation/pickup_request/pickup_request.dart';
import 'package:online_bhangharwala/presentation/profile/profile.dart';
import 'package:online_bhangharwala/presentation/reschedule/reschedule.dart';
import 'package:online_bhangharwala/presentation/scrap_pickup/scrap_pickup.dart';
import 'package:online_bhangharwala/presentation/share_us/share_us.dart';
import 'package:online_bhangharwala/presentation/splash_screen/splash_screen.dart';
import 'package:online_bhangharwala/track_pickup/track_pickup.dart';

import '../core/app_export.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/k0_screen/k0_screen.dart';
import '../presentation/k1_screen/k1_screen.dart';
import '../presentation/k2_screen/k2_screen.dart';
import '../presentation/k3_screen/k3_screen.dart';
import '../presentation/k4_screen/k4_screen.dart';
import '../presentation/how_its_works/how_its_works.dart';

class AppRoutes {
  static const String k0Screen = '/k0_screen';
  static const String k1Screen = '/k1_screen';
  static const String k2Screen = '/k2_screen';
  static const String k3Screen = '/k3_screen';
  static const String k4Screen = '/k4_screen';
  static const String mapScreen = '/map_screen';
  static const String k5Screen = '/k5_screen';
  static const String splashScreen = '/splash_screen';
  static const String k6Screen = '/k6_screen';
  static const String howitsworks = '/how_its_work';
  static const String aboutus = '/about_us';
  static const String shareus = '/share_us';
  static const String calculator = '/calculator';
  static const String myaccount = '/my_account';
  static const String pickupDateTime = '/pickup_datetime';
  static const String confirmDetailScreen = '/confirm_detail_screen';
  static const String payment = '/payment';
  static const String confirmation = '/confirmation';
  static const String trackPickup = '/track_pickup';
  static const String changePickupAddress = '/change_pickup_address';
  static const String profile = '/profile';
  static const String editAddress = '/edit_address';
  static const String addAddress = '/add_address';
  static const String reschedule = '/reschedule';
  static const String pickupRequest = '/pickup_request';
  static const String compeletecancelled = '/compeletecancel';
  static const String couponoffer = '/couponoffer';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    k0Screen: (context) => K0Screen(),
    k1Screen: (context) => K1Screen(),
    k3Screen: (context) => K3Screen(),
    k4Screen: (context) => K4Screen(),
    mapScreen: (context) => MapScreen(),
    k5Screen: (context) => K5Screen(),
    splashScreen: (context) => SplashScreen(),
    k6Screen: (context) => K6Screen(),
    howitsworks: (context) => HowitsWork(),
    aboutus: (context) => AboutUs(),
    shareus: (context) => ShareUsScreen(),
    calculator: (context) => Calculator(),
    myaccount: (context) => MyAccountScreen(),
    pickupDateTime: (context) => ScrapPickupScreen(),
    changePickupAddress: (context) => ChangePickupAddressScreen(),
    profile: (context) => ProfilePage(),
    editAddress: (context) => EditAddress(),
    addAddress: (context) => AddAdress(),
    pickupRequest: (context) => PickupRequestsScreen(),
    couponoffer: (context) => CouponOffersBenefit(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => K0Screen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case k2Screen:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => K2Screen(mobileNumber: args),
        );
      case confirmDetailScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final selectedDateTimeSlot = args['selectedDateTimeSlot'] as String;
        final slot = args['slot'] as String;
        return MaterialPageRoute(
          builder: (context) => ConfirmDetailsPage(
            selectedDateTimeSlot: selectedDateTimeSlot,
            slot: slot,
          ),
        );
      case payment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => PaymentMethodScreen(
            pickUp: args['pickUp'],
            timeSlot: args['timeSlot'],
            instructions: args['instructions'],
            addrType: args['addrType'],
            address: args['address'],
            landmark: args['landmark'],
            pin: args['pin'],
          ),
        );
      case addAddress:
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => AddAdress(addressId: args));
      case confirmation:
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ConfirmationScreen(pickupId: args));
      case trackPickup:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => TrackPickupRequestPage(pickupId: args),
        );
      case reschedule:
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => RescheduleScreen(pickId: args));
      case compeletecancelled:
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => CompleteCancelled(pickupId: args));
      default:
        return MaterialPageRoute(
          builder: (context) =>
              K0Screen(), // Default to K0Screen if route is not found
        );
    }
  }
}
