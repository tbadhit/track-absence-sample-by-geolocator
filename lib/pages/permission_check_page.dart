import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:track_absence_sample_by_geolocator/pages/home_page.dart';

class PermissionCheckPage extends StatelessWidget {
  const PermissionCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/permission.jpg',
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Permission',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Aplikasi ini membutuhkan izin lokasi untuk memberikan fitur terbaik kepada Anda',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await Geolocator.requestPermission();
                        final LocationPermission permission =
                            await Geolocator.checkPermission();
                        if (permission == LocationPermission.always ||
                            permission == LocationPermission.whileInUse) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomePage(),
                              ));
                        } else {
                          Get.snackbar('', '',
                              backgroundColor: const Color(0xffD9435E),
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.white),
                              titleText: const Text('IZIN LOKASI',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              messageText: const Text(
                                  'Izin lokasi tidak diberikan',
                                  style: TextStyle(color: Colors.white)));
                        }
                      },
                      child: const Text('Izinkan'))),
            ),
          )
        ],
      ),
    );
  }
}
