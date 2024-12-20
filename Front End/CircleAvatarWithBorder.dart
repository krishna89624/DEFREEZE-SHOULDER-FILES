import 'package:flutter/material.dart';

class CircleAvatarWithBorder extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;
  final double avatarRadius;
  final Color borderColor;

  const CircleAvatarWithBorder({
    Key? key,
    required this.imageUrl,
    this.borderRadius = 27.0,
    this.avatarRadius = 25.0,
    this.borderColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: borderRadius,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (error, stackTrace) {
          // Handle image load error if needed
        },
      ),
    );
  }
}
