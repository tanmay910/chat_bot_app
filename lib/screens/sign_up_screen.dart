import 'package:chatgpt_course/screens/home_screen.dart';
import 'package:chatgpt_course/utils/global.colors.dart';
import 'package:chatgpt_course/widgets/button.global.dart';
import 'package:chatgpt_course/widgets/social.login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

final _formkey = GlobalKey<FormState>();
final _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showspinner = false;
  String errorMessage = '';

  void Signup({
    required String email,
    required String password,
  }) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        showspinner = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          showspinner = false;
        });
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else {
          errorMessage = 'An error occurred while creating your account.';
        }
      } catch (e) {
        setState(() {
          showspinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red.withOpacity(0.9),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Logo',
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Column(
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter Name';
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter Email';
                            return null;
                          },
                          onSaved: (value) {
                            _emailController.text = value!;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter Name';
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                          onSaved: (value) {
                            _passwordController.text = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          Signup(
                              email: _emailController.text,
                              password: _passwordController.text);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          decoration: BoxDecoration(
                            color: GlobalColors.mainColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: showspinner
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Or Sign Up with -',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SocialLogin(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account',
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              child: TextButton(
                child: const Text('Sign In'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
