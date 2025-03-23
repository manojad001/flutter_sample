import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;

  StepProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Color(0xff3b61f4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StepIndicator(isActive: currentStep == 0, label: 'Pickup date'),
          StepIndicator(isActive: currentStep == 1, label: 'Confirm'),
        ],
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final bool isActive;
  final String label;

  StepIndicator({required this.isActive, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.white,
          child: isActive
              ? Icon(
                  Icons.check,
                  size: 16.0,
                  color: Colors.black,
                )
              : Icon(
                  Icons.circle,
                  size: 16.0,
                  color: Colors.black,
                ),
        ),
        SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}
