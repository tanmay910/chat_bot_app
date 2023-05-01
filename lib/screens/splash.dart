import 'dart:async';
import 'package:chatgpt_course/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_course/screens/chat_screen.dart';

class Splash extends StatefulWidget {
  static const String id = '/splash_screen';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _brightnessAnimation;
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _outerLogoController;
  late Animation<double> _outerLogoAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _brightnessAnimation = Tween(begin: 0.0, end: 0.70)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _outerLogoController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _outerLogoAnimation = Tween(begin: 0.0, end: -2 * 3.1415926535897932)
        .animate(_outerLogoController);

    _logoController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _logoAnimation =
        Tween(begin: 0.0, end: 2 * 3.1415926535897932).animate(_logoController);

    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _logoController.dispose();
    _outerLogoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF030303),
              Color(0xFF030303),
              Color(0xFF40A9F3),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _brightnessAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _animation,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix([
                    1, 0, 0, 0, 0, // Red channel
                    0, 1, 0, 0, 0, // Green channel
                    0, 0, 1, 0, 0, // Blue channel
                    0, 0, 0, 1, 0, // Alpha channel
                  ]),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: AnimatedBuilder(
                          animation: _outerLogoAnimation,
                          child:
                          Image.asset('assets/images/splash_loading.png'),
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _outerLogoAnimation.value,
                              child: child,
                            );
                          },
                        ),
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: _logoAnimation,
                          child: Image.asset(
                            'assets/images/logofinal2.png',
                            width: 200,
                            height: 200,
                          ),
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _logoAnimation.value,
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(_logoAnimation.value)
                                  ..rotateY(_logoAnimation.value),
                                alignment: FractionalOffset.center,
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}