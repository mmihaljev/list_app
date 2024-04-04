import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/Screens/home.dart';
import 'package:shopping_list_app/Screens/openingAnimation.dart';

class ClosingAnimation extends StatefulWidget {
  const ClosingAnimation({Key? key}) : super(key: key);

  @override
  State<ClosingAnimation> createState() => _ClosingAnimationState();
}

class _ClosingAnimationState extends State<ClosingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isActive = true;

  Animation<double>? sizeAnimation;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    sizeAnimation = Tween(begin: 1000.0, end: 80.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1.0, curve: Curves.decelerate)));
    colorAnimation = ColorTween(begin: Colors.pink[300], end: Colors.indigo)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 1.0)));

    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: 2.2,
          child: CircleAvatar(
            radius: sizeAnimation?.value,
            backgroundColor: colorAnimation?.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('List completed!',
                    style: TextStyle(
                        fontFamily: 'leBelle', color: Colors.pink[300], fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
