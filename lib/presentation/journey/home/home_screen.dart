import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //welcom text
                    _buildWelcome(),
                    //password health
                    _buildPasswordHealth(),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.space_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${TranslationConstants.hello.tr} ${controller.accountUsecase.user?.displayName ?? 'User'}!',
            style: ThemeText.bodyStrong.s24.blue600Color,
          ),
          Text(
            TranslationConstants.welcome.tr,
            style: ThemeText.bodySemibold.grey500Color.s12,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordHealth() {
    return Container(
      padding: EdgeInsets.all(AppDimens.space_16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.space_16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            offset: Offset(0, 0),
            blurRadius: 10,
          ),
        ],
        color: AppColors.blue300,
        // gradient: LinearGradient(
        //   colors: [
        //     //  AppColors.blue200,
        //     AppColors.blue300,
        //     //    AppColors.blue400,
        //   ],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   // stops: [0, 0.2, 0.8, 1],
        // ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TranslationConstants.passwordHealth.tr,
                style: ThemeText.bodySemibold.s16.colorWhite,
              ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                '100 ${TranslationConstants.passwords.tr}',
                style: ThemeText.bodySemibold.s12
                    .copyWith(color: AppColors.white.withOpacity(0.7)),
              ),
            ],
          ),
          Spacer(),
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: 0.6,
            backgroundColor: AppColors.transparent,
            animation: true,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text('100%', style: ThemeText.bodySemibold.s24.colorWhite),
            progressColor: AppColors.bianca,
            // linearGradient: LinearGradient(
            //     colors: [
            //       //  AppColors.blue200,
            //       //      AppColors.white.withOpacity(0.5),
            //
            //       AppColors.blue100,
            //       // AppColors.white.withOpacity(0.1),
            //     ],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     stops: [0, 0.2]),
          )
        ],
      ),
    );
  }
}
