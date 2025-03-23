import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get lato {
    return copyWith(
      fontFamily: 'Lato',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style

  static get bodyMediumBlack9007f => theme.textTheme.bodyMedium!.copyWith(
        color: Colors.black,
      );

  static get bodyMediumPrimaryContainer => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        fontSize: 14.fSize,
      );

  static get bodyMediumPrimaryContainer_1 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );

  // Headline text style
  static get headlineMediumErrorContainer =>
      theme.textTheme.headlineMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );

  static TextStyle get headlineMediumOnPrimary =>
      theme.textTheme.headlineMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

  // Title text style

  // Title text style
  static get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
      );

  static get titleMediumBold => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w700,
      );

  static get titleMediumBold18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primaryContainer,
      );

  static get titleSmallBlack => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w900,
      );

  static get titleSmallBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );

  static get titleSmallBold_1 => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );

  static get titleSmallPrimaryContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(0.8),
        fontWeight: FontWeight.w700,
      );

  // Title text style
  static get titleLarge22 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 22.fSize,
      );
}
