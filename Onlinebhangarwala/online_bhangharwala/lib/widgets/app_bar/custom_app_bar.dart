import 'package:flutter/material.dart';
import '../../core/app_export.dart';

enum Style { bgShadow }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {Key? key,
      this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions})
      : super(
          key: key,
        );

  final double? height;
  final Style? styleType;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final double? leadingWidth;
  final List<Widget>? actions;

  // @override
  // Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 56.v,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 56.v,
      );

  Widget? _getStyle() {
    switch (styleType) {
      case Style.bgShadow:
        return Container(
          height: 86.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withOpacity(0.42),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(0, 4),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }
}
