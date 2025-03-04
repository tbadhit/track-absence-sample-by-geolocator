import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:track_absence_sample_by_geolocator/pages/home_page.dart';
import 'package:track_absence_sample_by_geolocator/pages/permission_check_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isPermissionLocationAllow = false;
  final LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    isPermissionLocationAllow = true;
  } else {
    isPermissionLocationAllow = false;
  }
  runApp(MainApp(
    isPermissionLocationAllow: isPermissionLocationAllow,
  ));
}

class MainApp extends StatelessWidget {
  final bool isPermissionLocationAllow;
  const MainApp({super.key, required this.isPermissionLocationAllow});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: isPermissionLocationAllow
          ? const HomePage()
          : const PermissionCheckPage(),
    );
  }
}
