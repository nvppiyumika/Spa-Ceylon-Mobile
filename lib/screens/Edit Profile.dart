import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();

  String? _selectedGender = "Male";
  String? _selectedNationality = "Sri Lankan";

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _nationalities = [
    'Sri Lankan',
    'Indian',
    'British',
    'American',
    'Other'
  ];

  final TextEditingController nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController nicController =
      TextEditingController(text: "123456789V");
  final TextEditingController birthdayController =
      TextEditingController(text: "1990-01-01");
  final TextEditingController emailController =
      TextEditingController(text: "john@example.com");
  final TextEditingController mobileController =
      TextEditingController(text: "0771234567");
  final TextEditingController addressController =
      TextEditingController(text: "123, Temple Rd, Colombo");

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Back Button
          SafeArea(
            child: Padding(
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
                    child:
                        const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage(
                                          'assets/images/defaultpropic.png')
                                      as ImageProvider,
                            ),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(217, 182, 106, 1),
                                ),
                                child: const Icon(Icons.edit,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
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
                          child: Column(
                            children: [
                              buildField("Name", nameController),
                              buildField("NIC", nicController),
                              buildField("Birthday", birthdayController),
                              buildDropdown("Gender", _genders, _selectedGender,
                                  (val) {
                                setState(() => _selectedGender = val);
                              }),
                              buildField("Address", addressController),
                              buildField("Email", emailController),
                              buildField("Mobile", mobileController),
                              buildDropdown("Nationality", _nationalities,
                                  _selectedNationality, (val) {
                                setState(() => _selectedNationality = val);
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildButton("SAVE", _saveProfile, [
                          const Color.fromRGBO(191, 155, 67, 1),
                          const Color.fromRGBO(217, 182, 106, 1),
                          const Color.fromRGBO(191, 155, 67, 1)
                        ]),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          border: const UnderlineInputBorder(),
        ),
        iconEnabledColor: Colors.black,
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildButton(
      String text, VoidCallback onPressed, List<Color> gradientColors) {
    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "SAVE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
