import 'package:eco_recycler/presentation/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:eco_recycler/routes/app_routes.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<InternetConnectionStatus> _connectionListener;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkPermissions();
    await _checkInternetConnection();
    _listenForInternetConnection();
  }

  Future<void> _checkPermissions() async {
    var locationPermission = await Permission.locationWhenInUse.status;

    if (locationPermission.isDenied || locationPermission.isPermanentlyDenied) {
      bool isGranted = await Permission.locationWhenInUse.request().isGranted;
      if (!isGranted) {
        _showPermissionDialog(
          title: locationPermission.isPermanentlyDenied
              ? 'Permission Permanently Denied'
              : 'Permission Denied',
          message:
              'Location permission is required for the app to function. Please enable it in the settings.',
        );
      }
    }
  }

  Future<void> _checkInternetConnection() async {
    _hasInternet = await InternetConnectionChecker().hasConnection;
    if (!_hasInternet) {
      _showInternetDialog(); // Show internet prompt when no connection
    }
    setState(() {}); // Update the UI
  }

  void _listenForInternetConnection() {
    _connectionListener = InternetConnectionChecker().onStatusChange.listen(
      (status) {
        setState(() {
          _hasInternet = status == InternetConnectionStatus.connected;
          if (!_hasInternet) {
            _showInternetDialog(); // Prompt the user to turn on the internet
          } else {
            Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog when the internet is back
          }
        });
      },
    );
  }

  void _showInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Please enable your internet connection to continue using the app.',
            style: TextStyle(fontSize: 12.sp),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 12.sp, color: Colors.blue),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Open Settings',
                style: TextStyle(fontSize: 12.sp, color: Colors.blue),
              ),
              onPressed: () {
                openAppSettings(); // Open the device's internet settings
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  void _showPermissionDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 12.sp),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 12.sp, color: Colors.blue),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _connectionListener.cancel(); // Dispose of the internet connection listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF0E1C3F),
          ),
          title: 'eco_recycler',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
          home: Stack(
            children: [
              SplashScreen(),
              if (!_hasInternet)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      'Internet is off',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
