import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/view/admin/categories/upload_category.dart';
import 'package:flutter_application_1/view/admin/customers/customers.dart';
import 'package:flutter_application_1/view/admin/sellers/approved_sellers.dart';
import 'package:flutter_application_1/view/admin/sellers/non_approved_sellers.dart';
import 'package:flutter_application_1/welcome_screen.dart';

// List<Map<String, dynamic>> data = [
//   {
//     "name": 'Approved/nSellers',
//     "function": globalFunctions.nextScreen(context, ApprovedSellersPage()),
//   }
// ];

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // List<Function> functions = [
    //   // globalFunctions.nextScreen(context, screenName),
    //   // globalFunctions.nextScreen(context, screenName),
    //   // globalFunctions.nextScreen(context, screenName),
    // ];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Admin Home Page"),
          actions: [
            IconButton(
              onPressed: () {
                authServices.signOut(context: context).then((val) {
                  globalFunctions.nextScreen(
                      context, const WelcomeHomeScreen());
                });
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  globalFunctions.nextScreen(context, ApprovedSellersPage());
                },
                child: const Text("Approved Sellers")),
            ElevatedButton(
                onPressed: () {
                  globalFunctions.nextScreen(context, NonApprovedSellersPage());
                },
                child: const Text("Non Approved Sellers")),
            ElevatedButton(
                onPressed: () {
                  globalFunctions.nextScreen(context, CustomersShowPage());
                },
                child: const Text("Customers")),
            ElevatedButton(
              onPressed: () {
                globalFunctions.nextScreen(context, const UploadCategory());
              },
              child: const Text("Upload Category"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("All Categories"),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("All Products")),
          ],
        ));
  }
}
