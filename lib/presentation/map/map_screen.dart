import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng rootBundle
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:http/http.dart' as http;

class AddressMapWidget extends StatefulWidget {
  final String address; // Địa chỉ đầu vào

  AddressMapWidget({required this.address});

  @override
  _AddressMapWidgetState createState() => _AddressMapWidgetState();
}

class _AddressMapWidgetState extends State<AddressMapWidget> {
  MaplibreMapController? mapController;
  LatLng? _location; // Tọa độ vị trí
  bool isMarkerAdded = false; // Flag to track if marker has been added

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromAddress(widget.address); // Lấy tọa độ từ địa chỉ
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    final String url =
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          setState(() {
            _location = LatLng(lat, lon);
          });
        } else {
          print('No results found for address: $address');
        }
      } else {
        print('Failed to fetch coordinates: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
  }

  Future<void> _loadImageAndAddMarker(String assetPath) async {
    try {
      // Đọc ảnh từ assets
      final ByteData data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      // Đăng ký ảnh vào Maplibre
      await mapController!.addImage("marker_icon", bytes);

      // Thêm marker vào bản đồ
      mapController!.addSymbol(
        SymbolOptions(
          geometry: _location!,
          iconImage: "marker_icon", // Tên hình ảnh đã đăng ký
          iconSize: 0.05, // Tùy chỉnh kích thước nếu cần
        ),
      );
      setState(() {
        isMarkerAdded = true;
      });
      print("Marker added at: $_location");
    } catch (e) {
      print("Error loading image for marker: $e");
    }
  }

  void _onMapCreated(MaplibreMapController controller) {
    mapController = controller;

    if (_location != null) {
      if (!isMarkerAdded) {
        // Gọi phương thức để tải và thêm marker từ assets
        _loadImageAndAddMarker('assets/images/marker.png');
      } else {
        print("Marker is already added.");
      }

      // Di chuyển camera đến vị trí mới
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_location!, 16.0),
      );
    } else {
      print("Marker location is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _location == null
          ? Center(child: CircularProgressIndicator()) // Đang tải tọa độ
          : MaplibreMap(
              onMapCreated: _onMapCreated,
              styleString:
                  'https://api.maptiler.com/maps/streets/style.json?key=mifAEyncYQK8WekHDLK9', // Thêm kiểu bản đồ
              initialCameraPosition: CameraPosition(
                target: _location!, // Chuyển camera tới tọa độ
                zoom: 16.0, // Mức độ zoom
              ),
            ),
    );
  }
}
