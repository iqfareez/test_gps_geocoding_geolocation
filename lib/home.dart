import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String message = 'Tap button';
  String message1 = 'Tap button';
  String address = 'Tap address';
  Position position;

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

  void _printCurrentPosition() async {
    // position = await _determinePosition().then((f) {
    //   var text = 'lat: ${f.latitude}\nlong: ${f.longitude}';
    //   setState(() {
    //     message = text;
    //   });
    //   print('Finish printing');
    //   return f;
    // });
    position = await _determinePosition();
    var text = 'lat: ${position.latitude}\nlong: ${position.longitude}';
    setState(() {
      message = text;
    });

    print(text);
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
                child: Text(
                  'GET COORDINATE',
                ),
                onPressed: _printCurrentPosition),
          ),
          Text(
            message1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CupertinoButton.filled(
                child: Text(
                  'CALC HOME DISTANCE',
                ),
                onPressed: () {
                  double distanceInKm = Geolocator.distanceBetween(3.066,
                          101.636, position.latitude, position.longitude) /
                      1000;
                  setState(() {
                    message1 = '${distanceInKm.toStringAsFixed(1)} km';
                  });
                }),
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
                child: Text(
                  'GET ADDRESS',
                ),
                onPressed: () async {
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        position.latitude, position.longitude);
                    var first = placemarks.first;
                    setState(() {
                      print('success get location');
                      address = first.toString();
                    });
                  } catch (e) {
                    print('Error occured');
                    setState(() {
                      address = e.toString();
                    });
                  } finally {
                    print('finished');
                  }

                  // print(first.name);
                }),
          ),
        ],
      ),
    );
  }
}
