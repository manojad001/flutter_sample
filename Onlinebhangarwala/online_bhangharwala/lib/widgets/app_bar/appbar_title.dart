import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  AppbarTitle({Key? key, required this.text, this.margin, this.onTap})
      : super(key: key);

  final String text;
  final EdgeInsetsGeometry? margin;
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
