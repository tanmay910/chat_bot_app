import 'package:chatgpt_course/utils/global.colors.dart';
import 'package:chatgpt_course/widgets/button.global.dart';
import 'package:chatgpt_course/widgets/social.login.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signUp() {
    // Add your sign up logic here
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    print('Signing up with name: $name, email: $email and password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
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
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const ButtonGlobal(),
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
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Already have an account',
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
