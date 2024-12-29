import 'dart:convert';
import 'dart:math';
import 'dart:async'; // ignore: unnecessary_import
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final List<LatLng> coordinates;
  final double zoom;
  const MapScreen({
    Key? key,
    required this.coordinates,
    this.zoom = 14.0,
  }) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MaplibreMapController? mapController;

  LatLng? _currentPosition;
  LatLng? _destinationPoint;
  PolylinePoints polylinePoints = PolylinePoints();
  Symbol? _currentMarker;
  OverlayEntry? _popupOverlayEntry;
  //api cu
  // String api_key = 'ArPlUISaEBAdJFTABi9dcNGcue8WQ4cOAuGcNoBE';
  // String map_tiles_key = 'tLyW2vk0aY3yfQLu8ZPy986mAgaW8igMYufv3BLY';
  //api moi
  String api_key = 'dBjVmbNph3v3amPwQVLeudGY0Dcw7W3Eh8enfyTs';
  String map_tiles_key = 'raZBeyW5t5wQ4yBk9bgqxL1MikWPSHJ0fKY0zU92';



  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.coordinates.isNotEmpty) {
        fetchAndDrawMultiPointRoute(widget.coordinates);
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    if (widget.coordinates.isNotEmpty) {
      LatLng firstCoordinate = widget.coordinates.first;

      setState(() {
        _currentPosition = firstCoordinate;
      });

      // Thêm marker tại vị trí hiện tại
      _addMarkerAtCurrentPosition(
          firstCoordinate.latitude, firstCoordinate.longitude);

      print('Current position set to: $_currentPosition');
    } else {
      print('Error: Coordinates list is empty');
    }
  }

  Future<void> fetchAndDrawMultiPointRoute(List<LatLng> points) async {
    if (points.length < 2) {
      print("Not enough points to draw a route.");
      return;
    }

    List<List<double>> combinedCoordinates = [];

    for (int i = 0; i < points.length - 1; i++) {
      final origin = points[i];
      final destination = points[i + 1];

      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&vehicle=car&api_key=$api_key');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          String polyline = data['routes'][0]['overview_polyline']['points'];
          List<PointLatLng> decodedPolyline =
              polylinePoints.decodePolyline(polyline);

          combinedCoordinates.addAll(decodedPolyline
              .map((point) => [point.longitude, point.latitude]));
        } else {
          print("Failed to fetch route for segment $i.");
        }
      } catch (e) {
        print("Error fetching route for segment $i: $e");
      }
    }

    _drawPath(combinedCoordinates);
  }

  void _drawPath(List<List<double>> coordinates) {
    if (mapController == null) {
      print("Map controller is not initialized.");
      return;
    }

    // Check if there are coordinates to draw
    if (coordinates.isEmpty) {
      print("No coordinates provided for the path.");
      return;
    }

    // Remove existing path if any
    mapController?.removeLayer("route_layer");
    mapController?.removeSource("route_source");

    // Prepare GeoJSON data
    final geoJsonData = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": coordinates,
          },
          "properties": {}
        },
      ],
    };

    // Add the source and layer
    try {
      mapController?.addSource(
        "route_source",
        GeojsonSourceProperties(
          data: geoJsonData,
        ),
      );

      mapController?.addLineLayer(
        "route_source",
        "route_layer",
        LineLayerProperties(
          lineColor: "#0000FF", // Blue color
          lineWidth: 6, // Adjust the width of the line
          lineOpacity: 0.9, // Adjust opacity if needed
          lineCap: "round",
          lineJoin: "round",
        ),
      );

      print("Route drawn successfully with ${coordinates.length} points.");
    } catch (e) {
      print("Error drawing path: $e");
    }
  }
  //duong chim bay
  // Future<void> fetchAndDrawMultiPointRoute(List<LatLng> points) async {
//   if (points.length < 2) {
//     print("Not enough points to draw a route.");
//     return;
//   }

//   List<List<double>> combinedCoordinates = [];

//   for (int i = 0; i < points.length - 1; i++) {
//     final origin = points[i];
//     final destination = points[i + 1];

//     final url = Uri.parse(
//         'https://rsapi.goong.io/Direction?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&vehicle=car&api_key=$api_key');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String polyline = data['routes'][0]['overview_polyline']['points'];
//         List<PointLatLng> decodedPolyline =
//             polylinePoints.decodePolyline(polyline);

//         // Sample points to reduce the number of coordinates
//         List<List<double>> sampledCoordinates = _sampleCoordinates(decodedPolyline);

//         combinedCoordinates.addAll(sampledCoordinates);
//       } else {
//         print("Failed to fetch route for segment $i.");
//       }
//     } catch (e) {
//       print("Error fetching route for segment $i: $e");
//     }
//   }

//   print("Combined GeoJSON Data: $combinedCoordinates");
//   _drawPath(combinedCoordinates);
// }

// // Helper function to sample coordinates
// List<List<double>> _sampleCoordinates(List<PointLatLng> decodedPolyline, {int step = 5}) {
//   List<List<double>> sampledCoordinates = [];
//   for (int i = 0; i < decodedPolyline.length; i += step) {
//     sampledCoordinates.add([decodedPolyline[i].longitude, decodedPolyline[i].latitude]);
//   }

//   // Ensure the last point is included
//   if (decodedPolyline.isNotEmpty) {
//     sampledCoordinates.add([
//       decodedPolyline.last.longitude,
//       decodedPolyline.last.latitude,
//     ]);
//   }

//   return sampledCoordinates;
// }

// void _drawPath(List<List<double>> coordinates) {
//   if (mapController == null) {
//     print("Map controller is not initialized.");
//     return;
//   }

//   if (coordinates.isEmpty) {
//     print("No coordinates provided for the path.");
//     return;
//   }

//   mapController?.removeLayer("route_layer");
//   mapController?.removeSource("route_source");

//   final geoJsonData = {
//     "type": "FeatureCollection",
//     "features": [
//       {
//         "type": "Feature",
//         "geometry": {
//           "type": "LineString",
//           "coordinates": coordinates,
//         },
//         "properties": {}
//       },
//     ],
//   };

//   try {
//     mapController?.addSource(
//       "route_source",
//       GeojsonSourceProperties(
//         data: geoJsonData,
//       ),
//     );

//     mapController?.addLineLayer(
//       "route_source",
//       "route_layer",
//       LineLayerProperties(
//         lineColor: "#0000FF", // Blue color
//         lineWidth: 6, // Adjust the width of the line
//         lineOpacity: 0.9, // Adjust opacity if needed
//         lineCap: "round",
//         lineJoin: "round",
//       ),
//     );

//     print("Route drawn successfully with ${coordinates.length} points.");
//   } catch (e) {
//     print("Error drawing path: $e");
//   }
// }

  void _onMapCreated(MaplibreMapController controller) async {
    mapController = controller;
    _loadMarkerImage();
    _loadMarkerEndImage();
    _addMarkerAtDestinationPoint();
  }

  Future<void> _loadMarkerImage() async {
    final ByteData bytes = await rootBundle.load('assets/images/location.png');
    mapController?.addImage('location', bytes.buffer.asUint8List());
  }

  Future<void> _loadMarkerEndImage() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/locationEnd.png');
    mapController?.addImage('locationEnd', bytes.buffer.asUint8List());
  }

  void _onStyleLoadedCallback() {
    if (widget.coordinates.isNotEmpty) {
      // Add markers for all coordinates
      for (final coordinate in widget.coordinates) {
        _addMarkerAtCurrentPosition(coordinate.latitude, coordinate.longitude);
      }

      // Draw the path connecting all coordinates
      fetchAndDrawMultiPointRoute(widget.coordinates);
    } else {
      print('Error: Coordinates list is empty, no markers or path added.');
    }
  }

  void _addMarkerAtCurrentPosition(double latitude, double longitude) async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }

    try {
      // Add the marker
      final symbol = await mapController?.addSymbol(SymbolOptions(
        geometry: LatLng(latitude, longitude),
        iconImage: 'location',
        iconSize: 0.1,
        zIndex: 1, // Ensure marker is above circle
      ));

      if (symbol != null) {
        // Handle double-click event
        mapController?.onSymbolTapped.add((Symbol tappedSymbol) async {
          if (tappedSymbol.id == symbol.id) {
            final googleMapsUrl =
                "https://www.google.com/maps?q=$latitude,$longitude";
            if (await canLaunch(googleMapsUrl)) {
              await launch(googleMapsUrl);
            } else {
              print("Could not launch $googleMapsUrl");
            }
          }
        });
      }

      print("Marker added at ($latitude, $longitude)");
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  void _addMarkerAtDestinationPoint() async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }

    if (_destinationPoint == null) {
      print("Destination point is not set");
      return;
    }

    try {
      // Xóa marker hiện tại nếu có
      if (_currentMarker != null) {
        await mapController!.removeSymbol(_currentMarker!);
      }

      // Add a marker with a title
      _currentMarker = await mapController!.addSymbol(SymbolOptions(
        geometry: _destinationPoint!,
        iconImage: 'locationEnd', // Ensure this matches the loaded image name
        iconSize: 0.1,
        draggable: true,
      ));

      mapController!.onSymbolTapped.add((symbol) {
        _onMarkerTapped(symbol);
      });

      print("Marker added at ($_destinationPoint)");

      mapController!.onFeatureDrag.add((
        value, {
        required LatLng current,
        required LatLng delta,
        required DragEventType eventType,
        required LatLng origin,
        required Point<double> point,
      }) {
        print("5656565656($origin)"); // Đây để log ra location khi draggable
      });

      // Di chuyển camera đến vị trí mới
      mapController!.animateCamera(CameraUpdate.newLatLng(_destinationPoint!));
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  void _onMarkerDragEnd(LatLng newPosition) {
    print(
        "Marker dragged to: ${newPosition.latitude}, ${newPosition.longitude}");
    setState(() {
      _destinationPoint = newPosition; // Cập nhật vị trí mới
    });
  }

  void _onMarkerTapped(Symbol symbol) async {
    if (mapController == null) return;

    // Remove previous overlay if any
    _popupOverlayEntry?.remove();

    // Convert LatLng to screen coordinates
    LatLng markerLatLng = symbol.options.geometry!;
    Point<num> screenPosition =
        await mapController!.toScreenLocation(markerLatLng);

    // Create a new overlay entry
    _popupOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: screenPosition.x.toDouble() -
            50, // Adjust based on the width of the popup
        top: screenPosition.y.toDouble() -
            80, // Adjust based on the height of the popup
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Text(
              symbol.options.textField ?? 'No Title',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay into the overlay stack
    Overlay.of(context)!.insert(_popupOverlayEntry!);

    // Add a handler to close the popup when tapping on another symbol
    mapController!.onSymbolTapped.add((tappedSymbol) {
      if (tappedSymbol != symbol) {
        _popupOverlayEntry?.remove();
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  String mainText = "";
  String secondText = "";
  List<dynamic> places = [];
  var details = {};
  bool isShow = false;
  bool isHidden = true;

  Future<void> fetchData(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=$api_key');
      // print('url $url');
      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        print('url $url, size: ${places.length}');
        // _circleAnnotationManager?.deleteAll();
        isShow = true;
        isHidden = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Future<void> fetchDataDirection() async {
    if (_currentPosition != null && _destinationPoint != null) {
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destinationPoint!.latitude},${_destinationPoint!.longitude}&vehicle=bike&api_key=$api_key');

      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];

      List<PointLatLng> result = polylinePoints.decodePolyline(route);
      List<List<double>> coordinates =
          result.map((point) => [point.longitude, point.latitude]).toList();
      _drawLine(coordinates);
    }
  }

  void _drawLine(List<List<double>> coordinates) {
    mapController?.removeLayer("line_layer");
    mapController?.removeSource("line_source");
    final geoJsonData = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": coordinates,
          },
        },
      ],
    };

    mapController?.addSource(
      "line_source",
      GeojsonSourceProperties(
        data: geoJsonData,
      ),
    );

    mapController?.addLineLayer(
      "line_source",
      "line_layer",
      LineLayerProperties(
        lineColor: "#0000FF", // Màu xanh dưới dạng chuỗi
        lineWidth: 10,
        lineCap: "round",
        lineJoin: "round",
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Map Container
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapLibreMap(
                  onMapCreated: _onMapCreated,
                  onStyleLoadedCallback: _onStyleLoadedCallback,
                  initialCameraPosition: _calculateInitialCameraPosition(),
                  styleString:
                      'https://tiles.goong.io/assets/goong_map_web.json?api_key=$map_tiles_key',
                  attributionButtonPosition: null,
                  scrollGesturesEnabled: true,
                  gestureRecognizers: Set()
                    ..add(Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer()))
                    ..add(Factory<ScaleGestureRecognizer>(
                        () => ScaleGestureRecognizer()))
                    ..add(Factory<TapGestureRecognizer>(
                        () => TapGestureRecognizer()))
                    ..add(Factory<LongPressGestureRecognizer>(
                        () => LongPressGestureRecognizer())),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CameraPosition _calculateInitialCameraPosition() {
    if (widget.coordinates.isNotEmpty) {
      // Tính trung bình latitude và longitude từ danh sách coordinates
      final avgLatitude = widget.coordinates
              .map((coord) => coord.latitude)
              .reduce((a, b) => a + b) /
          widget.coordinates.length;
      final avgLongitude = widget.coordinates
              .map((coord) => coord.longitude)
              .reduce((a, b) => a + b) /
          widget.coordinates.length;

      return CameraPosition(
        target: LatLng(avgLatitude, avgLongitude),
        zoom: widget.zoom, // Sử dụng zoom từ tham số
      );
    }

    // Trả về giá trị mặc định nếu danh sách tọa độ rỗng
    return CameraPosition(
      target: LatLng(0, 0),
      zoom: widget.zoom, // Sử dụng zoom từ tham số
    );
  }
}
