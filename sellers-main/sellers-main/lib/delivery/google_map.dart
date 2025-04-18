// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/constants/google_api_keys.dart';
import 'package:sellers/delivery/qr_code_scanner.dart';
import 'package:sellers/models/order_model.dart';

class MapScreen extends StatefulWidget {
  final String orderId;
  const MapScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  LatLng? _latLong;
  geocoding.Placemark? _placeMark;
  Set<Polyline> _polylines = {};
  final store = GetStorage();

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  Future<LocationData> _getLocationPermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Service not enabled');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission Denied');
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  _getUserLocation() async {
    _currentPosition = await _getLocationPermission();
    _goToCurrentPosition(
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
  }

  getUserAddress() async {
    List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(_latLong!.latitude, _latLong!.longitude);
    setState(() {
      _placeMark = placemarks.first;
    });
  }

  void _fetchAndDisplayRoute(LatLng source, LatLng destination) async {
    List<LatLng> polylinePoints = await _getPolylineRoute(source, destination);

    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: polylinePoints,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  Future<List<LatLng>> _getPolylineRoute(
      LatLng source, LatLng destination) async {
    String apiKey = GOOGLE_MAPS_API_KEY;
    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]['legs'];
          if (legs.isNotEmpty) {
            final List<dynamic> steps = legs[0]['steps'];

            List<LatLng> polylinePoints = [];

            for (int i = 0; i < steps.length; i++) {
              final Map<String, dynamic> polyline =
                  steps[i]['polyline']['points'];
              List<LatLng> decodedPolyline = decodePolyline(polyline as String);

              polylinePoints.addAll(decodedPolyline);
            }

            return polylinePoints;
          }
        }
      }
    }

    return [];
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latDouble = lat / 1e5;
      double lngDouble = lng / 1e5;

      LatLng position = LatLng(latDouble, lngDouble);
      polylinePoints.add(position);
    }

    return polylinePoints;
  }

  //----------------------------------------------------------------
  Future<void> _getDestinationAddress() async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (orderSnapshot.exists) {
        double destinationLatitude = orderSnapshot['latitude'];
        double destinationLongitude = orderSnapshot['longitude'];

        LatLng destinationLatLng =
            LatLng(destinationLatitude, destinationLongitude);

        // Start fetching and displaying the route
        _fetchAndDisplayRoute(_latLong!, destinationLatLng);
      } else {
        print('Order document does not exist.');
      }
    } catch (e) {
      print('Error getting destination address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .84,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Stack(
                  children: [
                    GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      compassEnabled: false,
                      mapType: MapType.terrain,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(9.422967, 42.037149),
                        zoom: 13,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMove: (CameraPosition position) {
                        setState(() {
                          _latLong = position.target;
                        });
                      },
                      onCameraIdle: () {
                        getUserAddress();
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black38,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          _placeMark != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30.0, top: 10),
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    color: Colors.black38,
                                    child: Column(
                                      children: [
                                        Text(
                                          _placeMark!.street ??
                                              _placeMark!.name!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${_placeMark!.subLocality!} ',
                                            ),
                                            Text(_placeMark!.locality != null
                                                ? '${_placeMark!.subAdministrativeArea!}, '
                                                : ''),
                                          ],
                                        ),
                                        Text(
                                            '${_placeMark!.subAdministrativeArea!}, ${_placeMark!.administrativeArea!}, ${_placeMark!.country!},${_placeMark!.country!}')
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 150,
                child: CustomButton(
                  color: Colors.green,
                  title: 'Start',
                  onPressed: () {
                    // Call the function to get the destination address
                    _getDestinationAddress();
                  },
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: CustomButton(
                  color: Colors.green,
                  title: 'Complete',
                  onPressed: () {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QrCodeScanner(orderId: widget.orderId),
                        ),
                      );
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latlng.latitude, latlng.longitude),
      zoom: 13,
    )));
  }
}
