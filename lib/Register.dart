
import 'package:flutter/material.dart';
import 'Login.dart';


class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _selectedNationality;
  String? _selectedGender;

  final List<String> _nationalities = [
    'Sri Lankan',
    'Indian',
    'British',
    'American',
    'Other',
  ];

  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
  ];

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmVisibility() {
    setState(() {
      _obscureConfirm = !_obscureConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                // Sticky Header
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(183, 143, 43, 1),
                        Color.fromRGBO(217, 182, 106, 1),
                        Color.fromRGBO(183, 143, 43, 1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/spaCeylonLogo.png',
                      height: 175,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Remaining scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Back + Title Row
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 40),
                            const Text(
                              "SIGN UP HERE",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 90),
                          child: Text(
                            "Please Enter Your Details",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Fields
                        buildTextField("Enter Username"),
                        buildTextField("Enter Email"),
                        buildTextField("Enter Address"),
                        buildTextField("Enter Mobile"),

                        Row(
                          children: [
                            Expanded(
                              child: buildDropdownField(
                                hint: "Nationality",
                                value: _selectedNationality,
                                items: _nationalities,
                                onChanged: (value) {
                                  setState(() => _selectedNationality = value);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildDropdownField(
                                hint: "Gender",
                                value: _selectedGender,
                                items: _genders,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value);
                                },
                              ),
                            ),
                          ],
                        ),

                        buildTextField("Enter NIC"),
                        buildPasswordField(
                          hint: "Enter Password",
                          obscure: _obscurePassword,
                          toggle: _togglePasswordVisibility,
                        ),
                        buildPasswordField(
                          hint: "Confirm Password",
                          obscure: _obscureConfirm,
                          toggle: _toggleConfirmVisibility,
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(183, 143, 43, 1),
                                Color.fromRGBO(217, 182, 106, 1),
                                Color.fromRGBO(183, 143, 43, 1)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle sign up logic here
                              Navigator.of(context).push(MaterialPageRoute(builder:(context)=> LoginPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Login Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account ",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder:(context)=> LoginPage()));
                              },
                              child: const Text(
                                'Login Here',
                                style: TextStyle(
                                  color: Color.fromRGBO(191, 155, 67, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        obscureText: obscure,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[700],
            ),
            onPressed: toggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.grey[700],
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
