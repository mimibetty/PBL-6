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
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final double latitude;

  final double longitude;
  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
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
  String api_key = 'ArPlUISaEBAdJFTABi9dcNGcue8WQ4cOAuGcNoBE';
  String map_tiles_key = 'tLyW2vk0aY3yfQLu8ZPy986mAgaW8igMYufv3BLY';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentPosition = LatLng(widget.latitude, widget.longitude);
    });
  }

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
    if (_currentPosition != null) {
      _addMarkerAtCurrentPosition();
    }
  }

  void _addMarkerAtCurrentPosition() async {
    if (mapController == null) {
      print("Map controller is not initialized");
      return;
    }
    print('in trong addMarkerCurrentPost: ${widget.latitude}');

    try {
      // Add the marker with a click listener
      final symbol = await mapController?.addSymbol(SymbolOptions(
        geometry: LatLng(widget.latitude, widget.longitude),
        iconImage: 'location',
        iconSize: 0.1,
        zIndex: 1, // Ensure marker is above circle
      ));

      if (symbol != null) {
        // Handle double-click event
        mapController?.onSymbolTapped.add((Symbol tappedSymbol) async {
          if (tappedSymbol.id == symbol.id) {
            final googleMapsUrl =
                "https://www.google.com/maps?q=${widget.latitude},${widget.longitude}";
            if (await canLaunch(googleMapsUrl)) {
              await launch(googleMapsUrl);
            } else {
              print("Could not launch $googleMapsUrl");
            }
          }
        });
      }

      print(
          "Initial marker added at (${widget.latitude}, ${widget.longitude})");
    } catch (e) {
      print("Error adding initial marker: $e");
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
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 14.0,
                  ),
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
}

