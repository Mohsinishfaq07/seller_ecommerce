// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/constants/app_colors.dart';
// import 'package:flutter_application_1/constants/app_styles.dart';
// import 'package:flutter_application_1/enums/global_enums.dart';
//
// class ProductDetailPage extends StatelessWidget {
//   final Map<String, dynamic> product;
//
//   const ProductDetailPage({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           title: Text(
//             product['name'],
//             style: const TextStyle(color: AppColors.white),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.favorite_border, color: AppColors.white),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: const Icon(Icons.share, color: AppColors.white),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 300,
//                 width: double.infinity,
//                 color: AppColors.primaryLight.withOpacity(0.1),
//                 child: Image.network(
//                   product['image'],
//                   height: 300,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(AppColors.primary),
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.error_outline,
//                           size: 48,
//                           color: AppColors.error.withOpacity(0.5),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Image not available',
//                           style: TextStyle(
//                             color: AppColors.error.withOpacity(0.5),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 decoration: const BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             product['name'],
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           product['price'],
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       product['description'] ?? 'No description available.',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: AppColors.textSecondary,
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.primary,
//                     side: const BorderSide(color: AppColors.primary),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   icon: const Icon(Icons.chat_bubble_outline),
//                   label: const Text('Chat'),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 flex: 2,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // Add to cart functionality
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     foregroundColor: AppColors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   icon: const Icon(Icons.shopping_cart),
//                   label: const Text('Add to Cart'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
