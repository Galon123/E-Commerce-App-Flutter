import 'package:dio/dio.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formkey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  final _phoneNoController = TextEditingController();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void>_handleRegister() async{

    //Validation
    if(!_formkey.currentState!.validate()) return;



    try{

        final regRequest = await ApiClient.dio.post('/register',
        data: {
          "username" : _usernameController.text.trim(),
          "email" : _emailController.text,
          "phone_no" : _phoneNoController.text,
          "password" : _passwordController.text,
          "confirm_password" : _confirmPasswordController.text,
          }
        ); 

        if(regRequest.statusCode == 201 || regRequest.statusCode == 200){
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register Failed"))
      );
    }
    finally{
      setState(() => _isLoading = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 35),
            padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_circle, size: 70, color: Colors.indigo),
              Padding(padding: EdgeInsetsGeometry.only(top:20),child: Text("Create Account",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              prefixIcon: Icon(Icons.account_circle),
                              border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 245, 245)
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty) return "Required";
                              if(value.length < 3) return "Too short";
                              if(!value.startsWith(RegExp(r'[A-Z]'))) return "Username must start with A-Z";
                              else return null;
                            }
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "E-mail",
                              prefixIcon: Icon(Icons.mail),
                              border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 245, 245)
                            ),
                            validator: (value) {
                              if(value == null ||value.isEmpty) return "Required";
                              if(!value.toLowerCase().endsWith("@gectcr.ac.in")) return "Must be a college ID";
                              else return null;
                            },
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: _phoneNoController,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: Icon(Icons.phone),
                              border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 245, 245)
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) { 
                              if(value == null || value.isEmpty) return "Required";
                              if(value.length !=10) return "Invalid Phone Number";
                              else return null;
                            },
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 245, 245)
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty) return "Required";
                              if(!value.contains(RegExp(r'[A-Z]'))) return "One UpperCase Character required";
                              if(!value.contains(RegExp(r'[a-z]'))) return "One LowerCase Character required";
                              if(!value.contains(RegExp(r'[0-9]'))) return "One Number required";
                              else return null;
                            }
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: "Confirm Password",
                              prefixIcon: Icon(Icons.lock),
                              border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 245, 245)
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty) return "Required";
                              if(value != _passwordController.text) return "Must be same as Password";
                              else return null;
                            },
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,),
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading ? CircularProgressIndicator() : const Text("Register",style: TextStyle(color: Colors.white, fontSize: 18),)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Text("Already have an Account? ",style: TextStyle(fontStyle: FontStyle.italic),),
                  TextButton(
                    onPressed: () {Navigator.pushReplacementNamed(context, '/login');}, 
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.padded
                    ),
                    child: Text("Log in", 
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
    );
  }
}