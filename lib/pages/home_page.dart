import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_absence_sample_by_geolocator/location_attendance.dart';
import 'package:track_absence_sample_by_geolocator/user_data_dummy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    Widget buildGoogleMaps() {
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target:
              LatLng(LocationAttendance.latitude, LocationAttendance.longitude),
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) async {
          mapController = controller;
        },
        markers: <Marker>{
          const Marker(
            markerId: MarkerId('IPM'),
            position: LatLng(
              LocationAttendance.latitude,
              LocationAttendance.longitude,
            ),
            infoWindow: InfoWindow(title: LocationAttendance.infoWindow),
          )
        },
        myLocationEnabled: true,
        zoomControlsEnabled: false,
      );
    }

    Widget buildCardProfile() {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: const IntrinsicWidth(
          child: ListTile(
            contentPadding: EdgeInsets.only(right: 20),
            leading: Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 58,
            ),
            title: Text(UserDataDummy.name),
            subtitle: Text(UserDataDummy.role),
          ),
        ),
      );
    }

    Widget buildContainerClockIn() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: IntrinsicHeight(
            child: StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder:
                    (BuildContext context, AsyncSnapshot<Position> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final double latitudeCurrentLocation =
                      snapshot.data!.latitude;
                  final double longitudeCurrentLocation =
                      snapshot.data!.longitude;
                  final double distance = Geolocator.distanceBetween(
                    latitudeCurrentLocation,
                    longitudeCurrentLocation,
                    LocationAttendance.latitude,
                    LocationAttendance.longitude,
                  );
                  LatLngBounds bound = boundsFromLatLngList(<LatLng>[
                    LatLng(latitudeCurrentLocation, longitudeCurrentLocation),
                    const LatLng(LocationAttendance.latitude,
                        LocationAttendance.longitude),
                  ]);
                  Future.delayed(const Duration(milliseconds: 500))
                      .then((v) async {
                    CameraUpdate cameraUpdate2 =
                        CameraUpdate.newLatLngBounds(bound, 50);
                    mapController.animateCamera(cameraUpdate2).then((_) {
                      check(cameraUpdate2, mapController);
                    });
                  });

                  return Column(
                    children: <Widget>[
                      Text('Jarak antara Anda dengan kantor : $distance meter'),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              checkAttendance(distance);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('ABSEN MASUK'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.lock_clock)
                              ],
                            )),
                      ),
                    ],
                  );
                }),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildGoogleMaps(),
            buildCardProfile(),
            buildContainerClockIn(),
          ],
        ),
      ),
    );
  }

  void checkAttendance(double distance) {
    if (distance > 50) {
      Get.snackbar('', '',
          backgroundColor: const Color(0xffD9435E),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          titleText: const Text('Absen Ditolak',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          messageText: const Text('Jarak kamu terlalu jauh.',
              style: TextStyle(color: Colors.white)));
    } else {
      Get.snackbar('', '',
          backgroundColor: const Color(0xff19bc9c),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          titleText: const Text(
            'Absen Diterima',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          messageText: const Text('Kamu berhasil absen.',
              style: TextStyle(color: Colors.white)));
    }
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void check(CameraUpdate cameraUpdate, GoogleMapController controller) async {
    controller.animateCamera(cameraUpdate);
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await controller.getVisibleRegion();
    LatLngBounds l2 = await controller.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      check(cameraUpdate, controller);
    }
  }
}
