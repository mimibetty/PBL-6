import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';
import '../models/travel_model.dart';

class PopularPlace extends StatefulWidget {
  final TravelDestination destination;
  const PopularPlace({super.key, required this.destination});

  @override
  _PopularPlaceState createState() => _PopularPlaceState();
}

class _PopularPlaceState extends State<PopularPlace> {
  bool isLiked = false; // Trạng thái của nút tim

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 20,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  spreadRadius: 15,
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  widget.destination.images[0],
                ),
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HeartIconWidget(
                      userId: Get.find<AuthController>().userId.value, // Add the userId argument
                      destinationId: widget.destination.id, // Add the destinationId argument
                      isLiked: isLiked, // Truyền trạng thái isLiked vào
                      size: 30,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.destination.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      widget.destination.address.district,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 22,
                              color: Colors.amber[800],
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.destination.rating.toStringAsFixed(1).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
