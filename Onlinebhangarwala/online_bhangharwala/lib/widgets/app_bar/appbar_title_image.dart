import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/app_export.dart';

// ignore_for_file: must_be_immutable
class AppbarTitleImage extends StatelessWidget {
  AppbarTitleImage({Key? key, this.imagePath, this.margin, this.onTap})
      : super(key: key);

  final String? imagePath;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath!,
          height: 24.0,
          width: 24.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
