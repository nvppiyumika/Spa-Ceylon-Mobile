import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/models/userModel.dart';
import 'package:spa_ceylon_mobile/services/authService.dart';
import 'package:spa_ceylon_mobile/widgets/bottomnavbar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  String? _selectedGender;
  String? _selectedNationality;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _nationalities = [
    'Sri Lankan',
    'Indian',
    'British',
    'American',
    'Other'
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userModel = await _authService.getCurrentUserModel();
      if (userModel != null) {
        setState(() {
          _currentUser = userModel;
          nameController.text = userModel.username;
          nicController.text = userModel.nic;
          birthdayController.text = userModel.birthday != null
              ? userModel.birthday!.toIso8601String().split('T')[0]
              : ''; // Load birthday, default to empty if null
          emailController.text = userModel.email;
          mobileController.text = userModel.mobile;
          _selectedGender = _genders.contains(userModel.gender)
              ? userModel.gender
              : _genders[0];
          _selectedNationality = _nationalities.contains(userModel.nationality)
              ? userModel.nationality
              : _nationalities[0];
        });
      } else {
        setState(() {
          _errorMessage = "No user is currently logged in";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading user data: $e";
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentUser?.birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color.fromRGBO(217, 182, 106, 1),
            colorScheme:
                ColorScheme.light(primary: Color.fromRGBO(217, 182, 106, 1)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        birthdayController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_currentUser == null) {
      setState(() {
        _errorMessage = "No user data loaded";
      });
      return;
    }

    // Validation
    if (nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Please enter a username";
      });
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      setState(() {
        _errorMessage = "Invalid email format";
      });
      return;
    }
    if (!RegExp(r'^07\d{8}$').hasMatch(mobileController.text.trim())) {
      setState(() {
        _errorMessage = "Invalid mobile number (e.g., 0712345678)";
      });
      return;
    }
    if (!RegExp(r'^\d{9}[vVxX]|\d{12}$').hasMatch(nicController.text.trim())) {
      setState(() {
        _errorMessage = "Invalid NIC format (e.g., 123456789V or 123456789012)";
      });
      return;
    }
    if (_selectedGender == null || _selectedNationality == null) {
      setState(() {
        _errorMessage = "Please select gender and nationality";
      });
      return;
    }

    DateTime? birthday;
    if (birthdayController.text.isNotEmpty) {
      birthday = DateTime.parse(birthdayController.text);
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.updateUserProfile(
        uid: _currentUser!.uid,
        username: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        nationality: _selectedNationality,
        gender: _selectedGender,
        nic: nicController.text.trim(),
        birthday: birthday, // Pass updated birthday
      );

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e is FirebaseAuthException
            ? _authService.getErrorMessage(e)
            : "Error updating profile: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
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
                        // Profile Image UI (Non-functional)
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: const AssetImage(
                                  'assets/images/defaultpropic.png'),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(217, 182, 106, 1),
                              ),
                              child: const Icon(Icons.edit,
                                  size: 18, color: Colors.white),
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
                              buildFieldWithDatePicker(
                                  "Birthday", birthdayController),
                              buildDropdown("Gender", _genders, _selectedGender,
                                  (val) {
                                setState(() => _selectedGender = val);
                              }),
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
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Navigation handled by the BottomNavBar
        },
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildFieldWithDatePicker(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        enabled: true, // Allow editing with date picker
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          border: const UnderlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () => _selectDate(context),
          ),
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
        onTap: _isLoading ? null : onPressed,
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
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    text,
                    style: const TextStyle(
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
