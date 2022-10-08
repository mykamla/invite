import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rotate extends StatefulWidget {
  const Rotate({required this.child, Key? key}) : super(key: key);
  final Widget? child;

  @override
  _RotateState createState() => _RotateState();
}

class _RotateState extends State<Rotate>  with SingleTickerProviderStateMixin{
  late final AnimationController _imageController = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _imageController,
      builder: (_, child) {
        return Transform.rotate(
          angle: _imageController.value * 2 * pi,
          child: child,
        );
      },
      child: widget.child
    );
  }

}