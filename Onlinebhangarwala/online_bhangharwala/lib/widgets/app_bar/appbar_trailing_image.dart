import 'package:flutter/material.dart';
import 'package:online_bhangharwala/widgets/app_bar/custom_app_bar.dart';
import '../../core/app_export.dart'; // Update this to the correct path

// ignore_for_file: must_be_immutable
class AppbarTrailingImage extends StatelessWidget {
  AppbarTrailingImage({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
    this.styleType,
  }) : super(key: key);

  final String? imagePath;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Style? styleType; // Added this parameter

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath ?? '',
          height: 24.0,
          width: 24.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
