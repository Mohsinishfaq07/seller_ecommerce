import 'package:flutter/material.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context); // Back button functionality
          },
        ),
        title: const Text(
          'Profile', // Title for Profile, centered in AppBar
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.teal),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.teal),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Space below AppBar
            Row(
              children: [
                Stack(
                  children: [
                    // Profile Icon
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    // Camera Icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.teal,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16), // Space between icon and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'John Doe', // Replace with dynamic user name if needed
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'johndoe@example.com', // Replace with dynamic email if needed
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20), // Space below profile section
            const Divider(thickness: 1),
            // Profile Information Section
            const Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.teal),
              title: const Text('Username'),
              subtitle: const Text('John Doe'), // Replace with dynamic data
              onTap: () {
                // Edit username functionality (if needed)
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.teal),
              title: const Text('Email'),
              subtitle: const Text(
                  'johndoe@example.com'), // Replace with dynamic data
              onTap: () {
                // Edit email functionality (if needed)
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.teal),
              title: const Text('Phone Number'),
              subtitle: const Text('123-456-7890'), // Replace with dynamic data
              onTap: () {
                // Edit phone number functionality (if needed)
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.teal),
              title: const Text('Address'),
              subtitle: const Text(
                  '123 Main St, City, Country'), // Replace with dynamic data
              onTap: () {
                // Edit address functionality (if needed)
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Manage account functionality
                },
                child: const Text(
                  'Manage Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Payment settings functionality
                },
                child: const Text(
                  'Payment Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Address book functionality
                },
                child: const Text(
                  'Address Book',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Country functionality
                },
                child: const Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Account security functionality
                },
                child: const Text(
                  'Account Security',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
            SizedBox(
              width: double.infinity, // Full width of the screen
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Request account deletion functionality
                },
                child: const Text(
                  'Request Account Deletion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
