import 'package:flutter/cupertino.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.radius, required this.backgroundImage});

  final double radius;
  final AssetImage backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}