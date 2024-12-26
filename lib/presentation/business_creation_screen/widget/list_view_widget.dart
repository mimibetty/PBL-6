import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_creation_screen/business_edit_screen.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';

class DestinationListWidget extends StatefulWidget {
  final List<TravelDestination> recommendDestinations;

  const DestinationListWidget({Key? key, required this.recommendDestinations})
      : super(key: key);

  @override
  _DestinationListWidgetState createState() => _DestinationListWidgetState();
}

class _DestinationListWidgetState extends State<DestinationListWidget> {
  bool isLiked = false; // Like button state
  bool isSelected = false; // Selection state
  static int selectedCount = 0; // Count of selected cards
  late List<bool> isSelectedList; // List of selection states for each card
  bool selectAll = false;

  // Initialize the selection state for each destination
  @override
  void initState() {
    super.initState();
    isSelectedList =
        List.generate(widget.recommendDestinations.length, (_) => false);
  }

  // Function to handle the menu options like "Select", "Edit", and "Delete"
  void _handleMenuOption(
      String value, TravelDestination destination, int index) {
    switch (value) {
      case 'select':
        setState(() {
          isSelectedList[index] = !isSelectedList[index];
          if (isSelectedList[index]) {
            selectedCount++;
          } else {
            selectedCount--;
          }
        });
        break;
      case 'edit':
        print("Edit destination: ${destination.name}");
        // Add your edit logic here
        break;
      case 'delete':
        print("Delete destination: ${destination.name}");
        // Add delete logic here
        break;
    }
  }

  void _selectAll() {
    setState(() {
      selectAll = !selectAll;
      for (int i = 0; i < widget.recommendDestinations.length; i++) {
        isSelectedList[i] = selectAll;
      }
      selectedCount = selectAll ? widget.recommendDestinations.length : 0;
    });
  }

  // Function to handle "Delete" selected items functionality
  void _deleteSelected() {}

  @override
  Widget build(BuildContext context) {
    // Ensure the list is not empty before building
    if (widget.recommendDestinations.isEmpty) {
      return const Center(child: Text("No destinations available"));
    }

    return Column(
      children: [
        // Buttons for "Select All" and "Delete"
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Select All"),
                  SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: selectAll,
                    onChanged: (bool value) {
                      _selectAll();
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _deleteSelected,
                child: const Text("Delete Selected"),
              ),
            ],
          ),
        ),

        Padding(
          padding:
              const EdgeInsets.only(left: 16.0), // Adjust the padding as needed
          child: Row(
            children: [
              Text(
                "$selectedCount selected",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // List of destinations
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: widget.recommendDestinations.length,
            itemBuilder: (context, index) {
              var destination = widget.recommendDestinations[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailScreen(
                          destination: destination,
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                        // Image and heart icon with selection checkbox
                        Stack(
                          children: [
                            Container(
                              height: 95,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    destination.images![0],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: HeartIconWidget(
                                isLiked: isLiked,
                                size: 18,
                                onDoubleTap: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                destination.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  Text(
                                    destination.address.district,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${destination.rating.toStringAsFixed(1)}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " (${destination.numOfReviews} reviews)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBusinessPostScreen(),
                              ),
                            );
                          },
                        ),
                        // Checkbox under the edit button
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Checkbox(
                            value: isSelectedList[index],
                            onChanged: (bool? value) {
                              setState(() {
                                isSelectedList[index] = value!;
                                if (isSelectedList[index]) {
                                  selectedCount++;
                                } else {
                                  selectedCount--;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
