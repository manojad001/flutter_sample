import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style for error container
  static ButtonStyle get fillOnErrorContainerTL10 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onErrorContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  // Filled button style for primary button
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        // Add any other styling properties here
      );

  // Text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
        side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: Colors.transparent)),
      );
}
