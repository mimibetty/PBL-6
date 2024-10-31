// import 'package:flutter/material.dart';
// import 'models/cities_model.dart';

// class AllCitiesScreen extends StatelessWidget {
//   final List<City> cities;

//   const AllCitiesScreen({super.key, required this.cities});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("All Cities"),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         itemCount: cities.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 15),
//             child: GestureDetector(
//               onTap: () {
//                 // Chuyển đến trang chi tiết hoặc hành động khác khi nhấn vào thành phố
//               },
//               child: RecomendateCity(
//                 myCities: cities[index],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
