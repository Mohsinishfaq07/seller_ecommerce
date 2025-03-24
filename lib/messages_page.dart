import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Add some padding around the content
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the left
          children: [
            // "Messages" text at the top left corner
            const Text(
              'Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
                height: 20), // Space between "Messages" text and icons

            // Row for icons and labels
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Evenly space items
              children: [
                // Chat Icon with label
                Column(
                  children: const [
                    Icon(
                      Icons.chat,
                      color: Colors.teal,
                      size: 40,
                    ),
                    SizedBox(height: 8), // Space between icon and label
                    Text(
                      'Chats',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                // Orders Icon with label
                Column(
                  children: const [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                      size: 40,
                    ),
                    SizedBox(height: 8), // Space between icon and label
                    Text(
                      'Orders',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                // Activities Icon with label
                Column(
                  children: const [
                    Icon(
                      Icons.directions_run,
                      color: Colors.orange,
                      size: 40,
                    ),
                    SizedBox(height: 8), // Space between icon and label
                    Text(
                      'Activities',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
