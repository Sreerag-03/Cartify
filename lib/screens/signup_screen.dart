import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signUp(BuildContext context) async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final errorMessage = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
            CustomTextField(controller: _emailController, hintText: "Email"),
           const SizedBox(height: 10),
            CustomTextField(controller: _passwordController, hintText: "Password", obscureText: true),
           const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : CustomButton(text: "Sign Up", onTap: () => _signUp(context)),
          ],
        ),
      ),
    );
  }
}
