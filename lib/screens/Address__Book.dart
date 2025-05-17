import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/services/authService.dart';
import 'package:spa_ceylon_mobile/models/userModel.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  List<Map<String, dynamic>> addressList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserAndAddresses();
  }

  Future<void> _loadUserAndAddresses() async {
    try {
      final userModel = await _authService.getCurrentUserModel();
      if (userModel != null) {
        setState(() {
          _currentUser = userModel;
        });

        // Load addresses from Firestore
        await _fetchAddresses();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "No user is currently logged in";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error loading addresses: $e";
      });
    }
  }

  Future<void> _fetchAddresses() async {
    if (_currentUser == null) return;

    final addressSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('addresses')
        .get();

    setState(() {
      addressList = addressSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id, // Store the document ID for updates/deletes
          'name': data['name'] ?? '',
          'phone': data['phone'] ?? '',
          'region': data['region'] ?? '',
          'address': data['address'] ?? '',
          'isMain': data['isMain'] ?? false, // Check if it's the main address
        };
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> _saveAddressToFirestore(Map<String, dynamic> addressData) async {
    if (_currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('addresses')
          .add(addressData);
    } catch (e) {
      throw Exception("Failed to add address: $e");
    }
  }

  Future<void> _updateAddressInFirestore(
      String addressId, Map<String, dynamic> addressData) async {
    if (_currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('addresses')
          .doc(addressId)
          .update(addressData);
    } catch (e) {
      throw Exception("Failed to update address: $e");
    }
  }

  Future<void> _deleteAddressFromFirestore(String addressId) async {
    if (_currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('addresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete address: $e");
    }
  }

  void _showAddressFormDialog({Map<String, dynamic>? currentData, int? index}) {
    final nameController =
        TextEditingController(text: currentData?['name'] ?? '');
    final phoneController =
        TextEditingController(text: currentData?['phone'] ?? '');
    final regionController =
        TextEditingController(text: currentData?['region'] ?? '');
    final addressController =
        TextEditingController(text: currentData?['address'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            index == null ? 'Add New Address' : 'Edit Address',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Recipient's Name"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: regionController,
                  decoration:
                      const InputDecoration(labelText: "Region/City/District"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                      labelText: "House No/Building/Street"),
                ),
              ],
            ),
          ),
          actions: [
            // Delete Button (only in edit mode)
            if (index != null)
              TextButton(
                onPressed: () async {
                  try {
                    await _deleteAddressFromFirestore(currentData!['id']);
                    await _fetchAddresses(); // Reload addresses after deleting
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Address deleted successfully")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error deleting address: $e")),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Basic validation
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Name and address are required")),
                  );
                  return;
                }

                final newEntry = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'region': regionController.text,
                  'address': addressController.text,
                  'isMain':
                      currentData?['isMain'] ?? false, // Preserve isMain flag
                };

                try {
                  if (index == null) {
                    // Add new address
                    await _saveAddressToFirestore(newEntry);
                    await _fetchAddresses(); // Reload addresses after adding
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Address added successfully")),
                    );
                  } else {
                    // Update existing address
                    await _updateAddressInFirestore(
                        currentData!['id'], newEntry);
                    await _fetchAddresses(); // Reload addresses after updating
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Address updated successfully")),
                    );
                  }
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error saving address: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD1A73E),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main UI
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Add Address Button
                Center(
                  child: InkWell(
                    onTap: () => _showAddressFormDialog(),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 112, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(205, 167, 72, 1),
                            Color.fromRGBO(217, 182, 106, 1),
                            Color.fromRGBO(205, 167, 72, 1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'ADD ADDRESS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Address Cards
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Center(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : addressList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No addresses found. Add a new address!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  itemCount: addressList.length,
                                  itemBuilder: (context, index) {
                                    final data = addressList[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(205, 167, 72, 1),
                                            Color.fromRGBO(217, 182, 106, 1),
                                            Color.fromRGBO(205, 167, 72, 1),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.black),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      data['name'] ?? '',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    if (data['isMain'] == true)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 8),
                                                        child: Text(
                                                          "(Main Address)",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${data['address'] ?? ''}, ${data['region'] ?? ''}.\n${data['phone'] ?? ''}',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () => _showAddressFormDialog(
                                                currentData: data,
                                                index: index),
                                            child: const Icon(Icons.edit,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Index 4 for profile
        onTap: (index) {
          // Navigation handled by the BottomNavBar
        },
      ),
    );
  }
}
