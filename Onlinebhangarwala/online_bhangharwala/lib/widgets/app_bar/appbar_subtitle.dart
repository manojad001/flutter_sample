import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/app_export.dart'; // Correct import statement

// Define the AppbarSubtitle class
class AppbarSubtitle extends StatelessWidget {
  // Constructor
  AppbarSubtitle({
    Key? key,
    required this.text,
    this.margin,
    this.onTap,
  }) : super(key: key);

  String text;
  EdgeInsetsGeometry? margin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: CustomTextStyles.titleMediumBold18.copyWith(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(1),
          ),
        ),
      ),
    );
  }
}
