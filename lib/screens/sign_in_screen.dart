import 'package:chatgpt_course/screens/home_screen.dart';
import 'package:chatgpt_course/screens/sign_up_screen.dart';
import 'package:chatgpt_course/screens/top_tabs_screen.dart';
import 'package:chatgpt_course/utils/global.colors.dart';
import 'package:chatgpt_course/widgets/button.global.dart';
import 'package:chatgpt_course/widgets/social.login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'sign_up_screen.dart';

final _formkey = GlobalKey<FormState>();
final _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  String? errorMessage = '';
  bool isLogin = true;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showspinner = false;
  String errorMessage = '';

  void Signin({
    required String email,
    required String password,
  }) async {
    if (_formkey.currentState!.validate()) {
      try {
        setState(() {
          showspinner = true;
        });
        _formkey.currentState!.save();

        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((Uid) => {
                  showspinner = false,
                  _formkey.currentState!.reset(),
                  _emailController.clear(),
                  _passwordController.clear(),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => TopTabsScreen())),
                });
      } on FirebaseAuthException catch (error) {
        _formkey.currentState!.reset();
        _emailController.clear();
        _passwordController.clear();
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
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

        // print(error.code);
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
                    height: 100,
                  ),
                  CircleAvatar(
                    radius: 60,
                      child: Image(image: AssetImage('assets/images/sharingan.png'),fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 20,),
                  Text('CyberSphere',style: TextStyle(
                    color: Color(0xffcdf0fb),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),),
                  const SizedBox(
                    height: 80,
                  ),
                  Column(
                    children: [
                      Text(
                        'Sign in to your account',
                        style: TextStyle(
                          color: Color(0xffcdf0fb),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter Email';
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            labelStyle: TextStyle(
                              color: Colors.white, // Change color here
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white10, // Change color here
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffcdf0fb), // change border color
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffcdf0fb), // change focused border color
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white, // Change input text color here
                          ),
                          cursorColor: Colors.white,

                          ),
                        ),
                      
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please Enter password';
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            labelStyle: TextStyle(
                              color: Colors.white, // Change color here
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white10, // Change color here
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffcdf0fb),                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffcdf0fb),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white, // Change input text color here
                          ),
                          cursorColor: Colors.white,
                          ),
                        ),


                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          Signin(
                              email: _emailController.text,
                              password: _passwordController.text);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Color(0xffcdf0fb),
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
                                  'Sign in',
                                  style: TextStyle(
                                    color: Color(0xff161261),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '- Or Sign In with -',
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
            Text(
              'Don\'t have an account',
              style: TextStyle(color: Color(0xffcdf0fb),),
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              child: TextButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
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


// TextButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => NewPage()),
//     );
//   },
//   child: Text("Go to New Page"),
// ),