import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/core/utils/validation_functions.dart';
import 'package:travelappflutter/widgets/custom_button.dart';
import 'package:travelappflutter/widgets/custom_icon_button.dart';
import 'package:travelappflutter/widgets/custom_text_form_field.dart';

import 'controller/sign_in_controller.dart';

// ignore_for_file: must_be_immutable
class SignInScreen extends GetWidget<SignInController> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Container(
                width: size.width,
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomIconButton(
                                  height: 44,
                                  width: 44,
                                  margin:
                                      getMargin(left: 20, top: 8, right: 20),
                                  alignment: Alignment.centerLeft,
                                  onTap: () {
                                    onTapBtntf();
                                  },
                                  child: CommonImageView(
                                      svgPath: ImageConstant.imgArrowleft)),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: getPadding(
                                          left: 20, top: 40, right: 20),
                                      child: Text("lbl_sign_in_now".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtSFUIDisplaySemibold26
                                              .copyWith(height: 1.00)))),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: getPadding(
                                          left: 20, top: 12, right: 20),
                                      child: Text("msg_please_sign_in".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtSFUIDisplayRegular16
                                              .copyWith(height: 1.00)))),
                              CustomTextFormField(
                                  width: 335,
                                  focusNode: FocusNode(),
                                  controller: controller.usernameController,
                                  hintText: "msg_www_uihut_gmail".tr,
                                  margin:
                                      getMargin(left: 20, top: 40, right: 20),
                                  textInputAction: TextInputAction.done,
                                  alignment: Alignment.center,
                                  validator: (value) {
                                    if (value == null ||
                                        (!isValidEmail(value,
                                            isRequired: true))) {
                                      return "Please enter valid email";
                                    }
                                    return null;
                                  }),
                              Obx(() => CustomTextFormField(
                                  width: 335,
                                  focusNode: FocusNode(),
                                  controller: controller.passwordController,
                                  hintText: "msg_enter_password".tr,
                                  margin:
                                      getMargin(left: 20, top: 24, right: 20),
                                  textInputAction: TextInputAction.done,
                                  alignment: Alignment.center,
                                  isObscureText:
                                      !controller.isPasswordVisible.value,
                                  suffix: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      controller.isPasswordVisible.value =
                                          !controller.isPasswordVisible.value;
                                    },
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  })),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutes.forgotPasswordScreen);
                                    },
                                    child: Padding(
                                        padding: getPadding(
                                            left: 20, top: 16, right: 20),
                                        child: Text("msg_forget_password".tr,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtSFUIDisplayMedium14
                                                .copyWith(height: 1.00))),
                                  )),
                              CustomButton(
                                  onTap: () async {
                                    //Get.toNamed(AppRoutes.verificationScreen); // go to verification screen
                                    // Trigger the signIn function from the controller
                                    await controller.signIn();
                                  },
                                  width: 335,
                                  text: "lbl_sign_in".tr,
                                  margin:
                                      getMargin(left: 20, top: 40, right: 20),
                                  alignment: Alignment.center),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: getPadding(
                                          left: 20, top: 40, right: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text("msg_don_t_have_an_a".tr,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtSFUIDisplayRegular14
                                                    .copyWith(height: 1.00)),
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes.signUpScreen);
                                              },
                                              child: Padding(
                                                  padding: getPadding(left: 8),
                                                  child: Text("lbl_sign_up".tr,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtSFUIDisplayMedium14
                                                          .copyWith(
                                                              height: 1.00))),
                                            )
                                          ]))),
                            ]))))));
  }

  onTapBtntf() {
    Get.back();
  }
}
