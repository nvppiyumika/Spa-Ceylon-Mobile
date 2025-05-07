import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: AddressBook(),
    );
  }
}

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  List<Map<String, String>> addressList = [
    {
      'name': 'Pasindu Piyumika',
      'phone': '070 5511304',
      'region': 'Poruwadanda',
      'address': 'No.50, Arunagama',
    },
  ];

  void _showAddressFormDialog({Map<String, String>? currentData, int? index}) {
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
                onPressed: () {
                  setState(() {
                    addressList.removeAt(index);
                  });
                  Navigator.pop(context);
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
              onPressed: () {
                final newEntry = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'region': regionController.text,
                  'address': addressController.text,
                };

                setState(() {
                  if (index == null) {
                    addressList.add(newEntry);
                  } else {
                    addressList[index] = newEntry;
                  }
                });

                Navigator.pop(context);
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
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, color: Colors.black),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${data['address']}, ${data['region']}.\n${data['phone']}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _showAddressFormDialog(
                                  currentData: data, index: index),
                              child:
                                  const Icon(Icons.edit, color: Colors.black),
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
    );
  }
}
