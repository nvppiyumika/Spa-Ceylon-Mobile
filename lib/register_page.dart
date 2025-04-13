import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Foreground
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Gradient Logo Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(191, 155, 67, 1),
                          Color.fromRGBO(217, 182, 106, 1),
                          Color.fromRGBO(191, 155, 67, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/spaCeylonLogo.png',
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title
                  Text(
                    "SIGN UP HERE",
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'Castoro Titling',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please Enter Your Details",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(label: 'Full Name'),
                  _buildTextField(
                      label: 'Email', keyboardType: TextInputType.emailAddress),
                  _buildTextField(
                      label: 'Address',
                      keyboardType: TextInputType.streetAddress),
                  _buildTextField(
                      label: 'Mobile Number',
                      keyboardType: TextInputType.phone),
                  _buildTextField(label: 'Password', isPassword: true),
                  _buildTextField(label: 'Confirm Password', isPassword: true),

                  const SizedBox(height: 30),
              SizedBox(
  width: double.infinity,
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color.fromRGBO(191, 155, 67, 1),
          Color.fromRGBO(217, 182, 106, 1),
          Color.fromRGBO(191, 155, 67, 1),
        ],
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
         
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: const Center(
        child: Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ),
),
                  const SizedBox(height: 10),

                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login_page');
                        },
                        child: const Text(
                          'Sign In Here',
                          style: TextStyle(
                            color: Color.fromRGBO(191, 155, 67, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
        ),
      ),
    );
  }
}
