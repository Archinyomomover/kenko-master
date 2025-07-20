import 'package:flutter/material.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String password = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get isLengthValid => password.length >= 8;
  bool get hasUpperAndLower =>
      RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password);
  bool get hasSpecialChar => RegExp(r'[!@#\$%\^&\*]').hasMatch(password);

  Widget _buildRule(String text, bool passed) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: passed ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: passed ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _signup() {
    final passwordText = _passwordController.text.trim();
    final confirmPasswordText = _confirmPasswordController.text.trim();

    if (passwordText != confirmPasswordText) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    if (isLengthValid && hasUpperAndLower && hasSpecialChar) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix the password requirements.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // prevent content from overlapping system areas
        child: SingleChildScrollView( // allows vertical scroll to prevent overflow
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                width: double.infinity,
                color: Colors.blueGrey,
                child: const Center(
                  child: Text(
                    "KENKO",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),

                    // Confirm Password
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 30),

                    // Password rules
                    const Text(
                      "Password must contain:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildRule("8 or more characters", isLengthValid),
                    _buildRule(
                      "At least 1 uppercase & 1 lowercase",
                      hasUpperAndLower,
                    ),
                    _buildRule("1 special character (!@#\$%^&*)", hasSpecialChar),
                    const SizedBox(height: 30),

                    // Signup button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _signup,
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Go to Login
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                      ),
                      child: const Center(
                        child: Text(
                          "Already have an account? Log in",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
