import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myliveevent/theme/my_theme.dart';

class Loading extends StatelessWidget {
  Color? iconColor;

  Loading({this.iconColor = PrimaryColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    //  color: Colors.white70,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: iconColor!,
          size: 40,
        ),
      ),
    );
  }
}
