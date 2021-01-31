import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_gps_geocoder/models/location_coordinate.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String message = 'Tap button';
  String address = 'Tap address';
  String nearJakimCode = 'Tap';
  String administrativeArea;
  Position position;
  LocationCoordinate locationCoordinate;

  @override
  void initState() {
    super.initState();
    locationCoordinate = LocationCoordinate();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _getUserPosition() async {
    position = await _determinePosition();
    var text = 'lat: ${position.latitude}\nlong: ${position.longitude}';
    setState(() {
      message = text;
    });
    print(position);
  }

  void _getAddressFromCoordinate() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      var first = placemarks.first;
      setState(() {
        print(first);

        address = '${first.locality}, ${first.administrativeArea}';
        administrativeArea = first.administrativeArea;
      });
    } catch (e) {
      print('Error occured');
      setState(() {
        address = e.toString();
      });
      _getUserPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CupertinoButton.filled(
                child: Text('GET COORDINATE'), onPressed: _getUserPosition),
          ),
          Text(
            address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CupertinoButton.filled(
              child: Text('GET ADDRESS'),
              onPressed: _getAddressFromCoordinate,
            ),
          ),
          Text(
            nearJakimCode,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CupertinoButton.filled(
                child: Text(
                  'FIND NEAREST LOCATION',
                ),
                onPressed: () {
                  setState(() {
                    try {
                      nearJakimCode = locationCoordinate.getJakimCodeNearby(
                          position, administrativeArea);
                    } catch (e) {
                      nearJakimCode = '[$e] Seems like you\'re not in Malaysia';
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
