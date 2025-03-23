import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/map_screen/map_screen.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';

class K4Screen extends StatelessWidget {
  const K4Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildLocationQuestion(context),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 24.h,
                vertical: 20.v,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.imgGroup1),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We need your location to show our availability",
                    style: CustomTextStyles.bodyMediumPrimaryContainer_1,
                  ),
                  SizedBox(height: 368.v),
                  SizedBox(height: 64.v),
                  _buildLocationButtons(context),
                  SizedBox(height: 4.v),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 44.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgVector,
        margin: EdgeInsets.only(
          left: 28.h,
          top: 22.v,
          bottom: 22.v,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLocationQuestion(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your location?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLocationButtons(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      child: Column(
        children: [
          _buildAllowLocationButton(context),
          SizedBox(height: 14.v),
          _buildEnterLocationButton(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAllowLocationButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Allow location access",
      buttonStyle: CustomButtonStyles.fillOnErrorContainerTL10,
      buttonTextStyle: theme.textTheme.titleMedium!,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
        //onTapAllowLocationButton(context);
      },
    );
  }

  /// Section Widget
  Widget _buildEnterLocationButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "Enter location manually",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
      },
    );
  }

  /// Displays a dialog with the [K3Dialog] content.
  // void onTapAllowLocationButton(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       content: K3Dialog(),
  //       backgroundColor: Colors.transparent,
  //       contentPadding: EdgeInsets.zero,
  //       insetPadding: EdgeInsets.zero,
  //     ),
  //   );
  // }
}
