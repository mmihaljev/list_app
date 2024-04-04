import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/Screens/home.dart';

class OpenAnimation extends StatefulWidget {
  const OpenAnimation({Key? key}) : super(key: key);

  @override
  State<OpenAnimation> createState() => _OpenAnimationState();
}

class _OpenAnimationState extends State<OpenAnimation>
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

    sizeAnimation = Tween(begin: 50.0, end: 1400.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1.0, curve: Curves.decelerate)));
    colorAnimation = ColorTween(begin: Colors.indigo, end: Colors.pink[300])
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 1.0)));

    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
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
            child: Center( // Center added here
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Welcome", style: TextStyle(fontFamily: 'LeBelle', fontSize: 28),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
