import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/app_export.dart';

class ViewhierarchyItemWidget extends StatefulWidget {
  const ViewhierarchyItemWidget({Key? key}) : super(key: key);

  @override
  _ViewhierarchyItemWidgetState createState() =>
      _ViewhierarchyItemWidgetState();
}

class _ViewhierarchyItemWidgetState extends State<ViewhierarchyItemWidget> {
  String _selectedValue = 'Home'; // Default selected value

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceEvenly, // Distribute the radio buttons evenly
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath:
                    ImageConstant.imgHomeFill0Wght, // Ensure this is correct
                height: 20.adaptSize,
                width: 20.adaptSize,
                margin: EdgeInsets.only(left: 10.h),
              ),
              Radio<String>(
                value: 'Home',
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
              Text('Home'),
            ],
          ),
          Row(
            children: [
              CustomImageView(
                imagePath:
                    ImageConstant.imgHomeFill0Wght, // Ensure this is correct
                height: 20.adaptSize,
                width: 20.adaptSize,
                margin: EdgeInsets.only(left: 10.h),
              ),
              Radio<String>(
                value: 'Business',
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
              Text('Business'),
            ],
          ),
        ],
      ),
    );
  }
}
