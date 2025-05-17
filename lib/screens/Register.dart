import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/screens/Login.dart';
import 'package:spa_ceylon_mobile/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Form Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdayController =
      TextEditingController(); // New birthday controller

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Dropdown values
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

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _nicController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose(); // Dispose new controller
    super.dispose();
  }

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        _birthdayController.text =
            "${picked.toLocal().toIso8601String().split('T')[0]}";
      });
    }
  }

  // Method to handle form submission
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check if required dropdowns are selected
      if (_selectedNationality == null || _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select nationality and gender'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Parse birthday
      DateTime? birthday;
      if (_birthdayController.text.isNotEmpty) {
        birthday = DateTime.parse(_birthdayController.text);
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Check if email is already registered
        bool isEmailRegistered =
            await _authService.isEmailRegistered(_emailController.text);
        if (isEmailRegistered) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Email is already registered. Please login instead.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Register user
        final user = await _authService.registerWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          mobile: _mobileController.text.trim(),
          nationality: _selectedNationality!,
          gender: _selectedGender!,
          nic: _nicController.text.trim(),
          birthday: birthday, // Pass birthday
        );

        // Navigate to login page on success
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authService.getErrorMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        // Generic error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    child: Form(
                      key: _formKey,
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
                          buildTextField(
                            controller: _usernameController,
                            hint: "Enter Username",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),

                          buildTextField(
                            controller: _emailController,
                            hint: "Enter Email",
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          buildTextField(
                            controller: _mobileController,
                            hint: "Enter Mobile",
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a mobile number';
                              }
                              return null;
                            },
                          ),

                          buildTextField(
                            controller: _birthdayController,
                            hint: "Select Birthday",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today,
                                  color: Colors.grey[700]),
                              onPressed: () => _selectDate(context),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a birthday';
                              }
                              return null;
                            },
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: buildDropdownField(
                                  hint: "Nationality",
                                  value: _selectedNationality,
                                  items: _nationalities,
                                  onChanged: (value) {
                                    setState(
                                        () => _selectedNationality = value);
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

                          buildTextField(
                            controller: _nicController,
                            hint: "Enter NIC",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter NIC';
                              }
                              return null;
                            },
                          ),

                          buildPasswordField(
                            controller: _passwordController,
                            hint: "Enter Password",
                            obscure: _obscurePassword,
                            toggle: _togglePasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          buildPasswordField(
                            controller: _confirmPasswordController,
                            hint: "Confirm Password",
                            obscure: _obscureConfirm,
                            toggle: _toggleConfirmVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
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
                              onPressed: _isLoading ? null : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black)
                                  : const Text(
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
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.black),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: Colors.red[400]),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.black),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
          errorStyle: TextStyle(color: Colors.red[400]),
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
