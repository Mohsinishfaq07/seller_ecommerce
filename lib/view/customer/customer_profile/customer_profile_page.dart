import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/UserprofileProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerProfilePage extends ConsumerStatefulWidget {
  const CustomerProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerProfilePage> createState() =>
      _CustomerProfilePageState();
}

class _CustomerProfilePageState extends ConsumerState<CustomerProfilePage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  bool _isEditing = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Load data in initState
  }

  //method to load initial data
  void _loadInitialData() async {
    final customerData = await ref.read(currentCustomerProvider.future);
    if (mounted) {
      //check if the widget is mounted before setting state
      setState(() {
        _nameController.text = customerData?.name ?? '';
        _numberController.text = customerData?.number ?? '';
        _email = ref.read(firebaseAuthProvider).currentUser?.email ?? 'N/A';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      //  Data for editing is already in the text controllers.
      //  No need to read again.
    });
  }

  Future<void> _saveChanges() async {
    final currentUser = ref.read(firebaseAuthProvider).currentUser;
    if (currentUser != null) {
      try {
        await ref
            .read(customerRepositoryProvider)
            .updateCurrentUserCustomerData({
          'name': _nameController.text.trim(),
          'number': _numberController.text.trim(),
        });
        ref.invalidate(currentCustomerProvider);
        _toggleEdit();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save changes: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCustomer = ref.watch(currentCustomerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _isEditing ? 'Edit Profile' : 'Profile',
          style:
              const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.teal),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: _toggleEdit,
            )
          else
            IconButton(
              icon: const Icon(Icons.save, color: Colors.teal),
              onPressed: _saveChanges,
            ),
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
        child: currentCustomer.when(
          data: (customer) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.teal.shade200,
                          child: Text(
                            customer?.name.isNotEmpty == true
                                ? customer!.name.substring(0, 1).toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.teal,
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.teal),
                      prefixIcon:
                          const Icon(Icons.account_circle, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade300),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: TextEditingController(text: _email ?? 'N/A'),
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numberController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.teal),
                      prefixIcon: const Icon(Icons.phone, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade300),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.teal)),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading profile: $error')),
        ),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: _saveChanges,
              child: const Icon(Icons.check, color: Colors.white),
            )
          : null,
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade50,
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal.shade100,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal.shade100,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal.shade100,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal.shade100,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal.shade100,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal.shade100,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
          ],
        ),
      ),
    );
  }
}
