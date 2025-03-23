import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/k4_screen/k4_screen.dart';
import 'package:online_bhangharwala/presentation/k5_screen/k5_screen.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/widgets/app_bar/custom_app_bar.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/custom_text_form_field.dart';

class K3Screen extends StatefulWidget {
  @override
  _K3ScreenState createState() => _K3ScreenState();
}

class _K3ScreenState extends State<K3Screen> {
  final TextEditingController nameController = TextEditingController();
  final ApiService apiService =
      ApiService(); // Create an instance of ApiService
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    nameController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    _isButtonEnabled.value = nameController.text.trim().isNotEmpty;
  }

  void _onContinuePressed(BuildContext context) async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      try {
        final success = await apiService.updateAppProfile(name);
        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => K5Screen()),
          );
        } else {
          _showErrorDialog(context, 'Profile update failed');
        }
      } catch (e) {
        print(e);
        _showErrorDialog(context, 'An error occurred');
      }
    } else {
      _showErrorDialog(context, 'Name cannot be empty');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgObLogoColor,
              height: 74.v,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 90.h),
            ),
            Spacer(flex: 30),
            _buildNameInputSection(context),
            Spacer(flex: 55),
            ValueListenableBuilder<bool>(
              valueListenable: _isButtonEnabled,
              builder: (context, isButtonEnabled, child) {
                return ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () => _onContinuePressed(context)
                      : null,
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),

                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    backgroundColor:
                        Color(0xff3b61f4), // Adjust the button color if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the border radius if needed
                    ),
                  ),
                );
              },
            ),
            Spacer(flex: 21),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 48.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDownPrimarycontainer,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 16.v,
          bottom: 16.v,
        ),
      ),
    );
  }

  Widget _buildNameInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your name?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 14.v),
          CustomTextFormField(
            controller: nameController,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
