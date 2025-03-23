import 'package:eco_recycler/presentation/cancel_reason/cancel_reason.dart';
import 'package:flutter/material.dart';

class PCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function()? onBackButtonPressed;
  final Function()? onCancelPressed;
  final String pickupId;

  PCustomAppBar({
    required this.title,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.onCancelPressed,
    required this.pickupId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF06193D),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackButtonPressed ??
                  () {
                    Navigator.pop(context);
                  },
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancelPressed ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancellationReasonScreen(
                      pickupId: pickupId,
                    ),
                  ),
                );
              },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
