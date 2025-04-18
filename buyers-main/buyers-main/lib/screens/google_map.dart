// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:buyers/constants/google_api_key.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/screens/cart_checkout.dart';
import 'package:buyers/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get_storage/get_storage.dart';
import 'package:buyers/constants/custome_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //  final store = GetStorage();
  //   String address = store.read('address');
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
              List<LatLng> decodedPolyline = decodePolyline(
                  polyline as String); // Helper function to decode polyline

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .65,
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
                          // backgroundColor: Colors.black38,
                          child: Icon(
                            Icons.location_on,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Flexible(
                child: Column(
                  children: [
                    Column(
                      children: [
                        _placeMark != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _placeMark!.subLocality ??
                                        _placeMark!.locality!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${_placeMark!.locality!} ',
                                      ),
                                      Text(_placeMark!.subAdministrativeArea !=
                                              null
                                          ? '${_placeMark!.subAdministrativeArea!}, '
                                          : ''),
                                    ],
                                  ),
                                  Text(
                                      '${_placeMark!.administrativeArea!}, ${_placeMark!.country!}, ${_placeMark!.postalCode!}')
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: CustomButton(
                                //  color: Colors.green,
                                title: 'setAddress'.tr,
                                onPressed: () {
                                  String subLocality =
                                      '${_placeMark!.subLocality},';
                                  String locality = '${_placeMark!.locality},';
                                  String adminArea =
                                      '${_placeMark!.administrativeArea},';
                                  String subAdminArea =
                                      '${_placeMark!.subAdministrativeArea},';
                                  String country = '${_placeMark!.country},';
                                  String pin = '${_placeMark!.postalCode},';
                                  String address =
                                      '$subLocality, $locality, $adminArea, $subAdminArea, $country,$pin,';
                                  store.write('address', address);

                                  _fetchAndDisplayRoute(
                                    LatLng(_currentPosition!.latitude!,
                                        _currentPosition!.longitude!),
                                    _latLong!,
                                  );

                                  _showBottomSheet(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'deliveryAddress'.tr,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                store.read('address') ?? '',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: CustomButton(
                        color: Colors.green,
                        width: 130,
                        title: 'conform'.tr,
                        onPressed: () {
                          Routes.instance.push(
                              widget: CartItemCheckout(), context: context);
                        },
                      ),
                    ),
                    Flexible(
                      child: CustomButton(
                        width: 130,
                        color: Colors.deepOrange.shade300,
                        title: 'change'.tr,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50)
            ],
          ),
        );
      },
    );
  }
}





// // ignore_for_file: prefer_const_constructors

// import 'dart:async';

// import 'package:buyers/constants/primary_button.dart';
// import 'package:buyers/constants/routes.dart';
// import 'package:buyers/screens/address_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;

// class MapScreen extends StatefulWidget {
//   const MapScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   Completer<GoogleMapController> _controller = Completer();
//   LocationData? _currentPosition;
//   LatLng? _latLong;
//   bool _locating = false;
//   geocoding.Placemark? _placeMark;
//   final store = GetStorage();
//   //String address=store.read('address');

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(9.422967, 42.037149),
//     zoom: 13,
//   );

//   @override
//   void initState() {
//     _getUserLocation();
//     super.initState();
//   }

//   Future<LocationData> _getLocationPermission() async {
//     Location location = Location();

//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData locationData;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return Future.error('Service not enabled');
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return Future.error('Permission Denied');
//       }
//     }

//     locationData = await location.getLocation();
//     return locationData;
//   }

//   _getUserLocation() async {
//     _currentPosition = await _getLocationPermission();
//     _goToCurrentPosition(
//         LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
//   }

//   getUserAddress() async {
//     List<geocoding.Placemark> placemarks = await geocoding
//         .placemarkFromCoordinates(_latLong!.latitude, _latLong!.longitude);
//     setState(() {
//       _placeMark = placemarks.first;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Set<Marker> getMarker() {
//     //   return <Marker>[
//     //     Marker(
//     //         markerId: MarkerId(
//     //           'Belkis store',
//     //         ),
//     //         position: LatLng(9.422967, 42.037149),
//     //         icon: BitmapDescriptor.defaultMarker,
//     //         infoWindow: InfoWindow(title: 'Hello'))
//     //   ].toSet();
//     // }

//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.arrow_back)),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * .75,
//                   decoration: const BoxDecoration(
//                       border: Border(bottom: BorderSide(color: Colors.grey))),
//                   child: Stack(
//                     children: [
//                       GoogleMap(
//                      //   markers: getMarker(),
//                         myLocationEnabled: true,
//                         myLocationButtonEnabled: true,
//                         compassEnabled: false,
//                         mapType: MapType.terrain,
//                         initialCameraPosition: _kGooglePlex,
//                         onMapCreated: (GoogleMapController controller) {
//                           _controller.complete(controller);
//                         },
//                         onCameraMove: (CameraPosition position) {
//                           setState(() {
//                             _locating = true;
//                             _latLong = position.target;
//                           });
//                         },
//                         onCameraIdle: () {
//                           setState(() {
//                             _locating = false;
//                           });
//                           getUserAddress();
//                         },
//                       ),
//                       Align(
//                           alignment: Alignment.center,
//                           child: CircleAvatar(
//                               radius: 60,
//                               backgroundColor: Colors.black38,
//                               child: Icon(
//                                 Icons.location_on,
//                                 size: 40,
//                               ))),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       _placeMark != null
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _locating
//                                       ? 'Locating...'
//                                       : _placeMark!.subLocality == null
//                                           ? _placeMark!.locality!
//                                           : _placeMark!.subLocality!,
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       '${_placeMark!.locality!} ',
//                                     ),
//                                     Text(_placeMark!.subAdministrativeArea !=
//                                             null
//                                         ? '${_placeMark!.subAdministrativeArea!}, '
//                                         : ''),
//                                   ],
//                                 ),
//                                 Text(
//                                     '${_placeMark!.administrativeArea!}, ${_placeMark!.country!}, ${_placeMark!.postalCode!}')
//                               ],
//                             )
//                           : Container(),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           Flexible(
//                             child: CustomButton(
//                               color: Colors.green,
//                               title: 'Set address',
//                               onPressed: () {
//                                 String subLocality =
//                                     '${_placeMark!.subLocality},';
//                                 String locality = '${_placeMark!.locality},';
//                                 String adminArea =
//                                     '${_placeMark!.administrativeArea},';
//                                 String subAdminArea =
//                                     '${_placeMark!.subAdministrativeArea},';
//                                 String country = '${_placeMark!.country},';
//                                 String pin = '${_placeMark!.postalCode},';
//                                 String address =
//                                     '$subLocality, $locality, $adminArea, $subAdminArea, $country,$pin,';
//                                 store.write('address', address);
//                                 _showBottomSheet(context);
//                                 // Routes.instance.push(
//                                 //     widget: AddressScreen(), context: context);
//                               },
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _goToCurrentPosition(LatLng latlng) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         bearing: 192.8334901395799,
//         target: LatLng(latlng.latitude, latlng.longitude),
//         //tilt: 59.440717697143555,
//         zoom: 13)));
//   }

//   void _showBottomSheet(BuildContext context) {
//     String address = store.read('address');
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(
//                 'Your Delivery Address:',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Text(
//                 '123 Main Street, Cityville',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               SizedBox(height: 16.0),
//               Text(address),
//               SizedBox(height: 16.0),
//               Flexible(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         width: 130,
//                         child: CustomButton(
//                           color: Colors.green,
//                           title: 'Conform',
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       child: Container(
//                         width: 130,
//                         child: CustomButton(
//                           color: Colors.deepOrange.shade300,
//                           title: 'Change',
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;

// class MapSample extends StatefulWidget {
//   final String userId;

//   MapSample(this.userId);

//   @override
//   _MapSampleState createState() => _MapSampleState();
// }

// class _MapSampleState extends State<MapSample> {
//   final loc.Location location = loc.Location();
//   late GoogleMapController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance.collection('location').get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return GoogleMap(
//               mapType: MapType.normal,
//               markers: {
//                 Marker(
//                   position: LatLng(
//                     snapshot.data!.docs
//                         .singleWhere((element) => element.id == widget.userId)['latitude'],
//                     snapshot.data!.docs
//                         .singleWhere((element) => element.id == widget.userId)['longitude'],
//                   ),
//                   markerId: MarkerId('id'),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
//                 ),
//               },
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                   snapshot.data!.docs
//                       .singleWhere((element) => element.id == widget.userId)['latitude'],
//                   snapshot.data!.docs
//                       .singleWhere((element) => element.id == widget.userId)['longitude'],
//                 ),
//                 zoom: 14.47,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _controller = controller;
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }


// // ignore_for_file: prefer_const_constructors

// import 'dart:async';

// import 'package:buyers/constants/google_api_key.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   Location _locationContoller = new Location();
//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();

//   static const LatLng _pGooglePlex = LatLng(9.422967, 42.037149);
//   static const LatLng _pApplePark = LatLng(9.422967, 42.037149);
//   LatLng? _currentPosition = null;

//   Map<PolylineId, Polyline> polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     getLocationUpdate().then(
//       (_) => getPolyLinePoints().then((Coordinates) => {
//             generatePolyLineFromPoints(Coordinates),
//           }),
//     );
//   }

//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: pos,
//       zoom: 13,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }

//   Future<void> getLocationUpdate() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissinGranted;

//     _serviceEnabled = await _locationContoller.serviceEnabled();

//     if (_serviceEnabled) {
//       _serviceEnabled = await _locationContoller.requestService();
//     } else {
//       return;
//     }

//     _permissinGranted = await _locationContoller.hasPermission();
//     if (_permissinGranted == PermissionStatus.denied) {
//       _permissinGranted = await _locationContoller.requestPermission();
//       if (_permissinGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _locationContoller.onLocationChanged.listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           _currentPosition =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentPosition!);
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentPosition == null
//           ? Center(
//               child: Text('Loading'),
//             )
//           : GoogleMap(
//               onMapCreated: ((GoogleMapController controller) =>
//                   _mapController.complete(controller)),
//               initialCameraPosition: _currentPosition == null
//                   ? CameraPosition(
//                       target: _pGooglePlex,
//                       zoom: 14.0,
//                     )
//                   : CameraPosition(
//                       target: _currentPosition!,
//                       zoom: 14.0,
//                     ),
//               markers: {
//                 Marker(
//                   markerId: MarkerId('_currentLocation'),
//                   icon: BitmapDescriptor.defaultMarker,
//                   position: _currentPosition!,
//                 ),
//                 Marker(
//                   markerId: MarkerId('_sourceLocation'),
//                   icon: BitmapDescriptor.defaultMarker,
//                   position: _pGooglePlex,
//                 ),
//                 Marker(
//                   markerId: MarkerId('_destinationLocation'),
//                   icon: BitmapDescriptor.defaultMarker,
//                   position: _pApplePark,
//                 ),
//               },
//               polylines: Set<Polyline>.of(polylines.values),
//             ),
//     );
//   }

//   Future<List<LatLng>> getPolyLinePoints() async {
//     List<LatLng> polyLineCordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
//       GOOGLE_MAPS_API_KEY,
//       PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
//       PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
//       travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polyLineCordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     return polyLineCordinates;
//   }

//   void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
//     PolylineId id = PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.black,
//       points: polylineCoordinates,
//       width: 8,
//     );
//     setState(() {
//       polylines[id] = polyline;
//     });
//   }
// }
