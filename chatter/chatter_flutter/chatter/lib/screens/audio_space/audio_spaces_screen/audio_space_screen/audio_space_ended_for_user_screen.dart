import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/utilities/const.dart';

class AudioSpaceEndedForUserScreen extends StatelessWidget {
  const AudioSpaceEndedForUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const ShapeDecoration(
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 30, cornerSmoothing: cornerSmoothing),
                topRight: SmoothRadius(cornerRadius: 30, cornerSmoothing: cornerSmoothing),
              ),
            ),
            color: cBlackSheetBG,
          ),
          padding: const EdgeInsets.all(25),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Spacer(),
                    XMarkButton(),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${LKeys.audioSpace.tr} ${LKeys.ended.tr}",
                  style: MyTextStyle.gilroyBold(size: 22, color: cWhite),
                ),
                const SizedBox(height: 15),
                Text(
                  "The host has ended the audio space.",
                  style: MyTextStyle.gilroyLight(color: cLightIcon),
                ),
                const SizedBox(height: 40),
                CommonSheetButton(
                  title: LKeys.close,
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
