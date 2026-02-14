import 'package:dio/dio.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

bool _isLoading = false;

Future<void> _login() async {
    // 1. Validate the form locally first
    if (!_formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 2. Send request to FastAPI
      // Syntax: data is the body of your POST request
      final response = await ApiClient.dio.post('/login', 
      data: FormData.fromMap({
        "username": _usernameController.text,
        "password": _passwordController.text,
      }));

     if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Login Failed")),
       );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
  }  

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // Prevents "Bottom Overflow" when keyboard appears
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text("College Marketplace", 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 40),

                // Username/Email Field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Color.fromARGB(255, 245, 245, 245)
                  ),
                  validator: (value) => value!.isEmpty ? "Enter your username" : null,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hides the characters
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Color.fromARGB(255, 245, 245, 245)
                  ),
                  validator: (value) => value!.length < 6 ? "Password too short" : null,
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account? ",style: TextStyle(fontStyle: FontStyle.italic),),
                  TextButton(
                    onPressed: () {Navigator.pushReplacementNamed(context, '/register');}, 
                    
                    child: Text("Register", 
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                      ),
                    )
                  )
                ],
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}