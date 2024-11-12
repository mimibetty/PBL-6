import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/cities_model.dart';

class RecomendateCity extends StatelessWidget {
  final CityModel myCities;

  const RecomendateCity({super.key, required this.myCities});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  myCities.images[0].url,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment
              children: [
                Text(
                  myCities.name,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 16,
                    ),
                    Expanded( // Changed from Flexible to Expanded
                      child: Text(
                        myCities.region,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36), // Reduced spacing for better layout
                Text(
                  myCities.description,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: blueTextColor,
                  ),
                  textAlign: TextAlign.right, // Explicitly set text alignment
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
