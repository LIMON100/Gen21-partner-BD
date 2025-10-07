/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../common/constant.dart';
import '../../../common/ui.dart';
import '../../services/auth_service.dart';
import '../auth/controllers/auth_controller.dart';

class PhoneNumberFieldWithCountryCodeWidget extends StatelessWidget {
  const PhoneNumberFieldWithCountryCodeWidget({
    Key key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.isLast,
    this.style,
    this.textAlign,
    this.suffix,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String initialValue;
  final String hintText;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final IconData iconData;
  final bool obscureText;
  final bool isFirst;
  final bool isLast;
  final Widget suffixIcon;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
        margin: EdgeInsets.only(left: 20, right: 20, top: topMargin, bottom: bottomMargin),
        decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: buildBorderRadius,
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
            ],
            border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          TextFormField(
              maxLines: keyboardType == TextInputType.multiline ? null : 1,
              key: key,
              keyboardType: keyboardType ?? TextInputType.number,
              onSaved: onSaved,
              onChanged: onChanged,
              validator: validator,
              initialValue: initialValue ?? '',
              style: style ?? Get.textTheme.bodyText2,
              obscureText: obscureText ?? false,
              textAlign: textAlign ?? TextAlign.start,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Get.textTheme.caption,
                prefixIcon: iconData != null
                    ? Wrap(
                        runAlignment: WrapAlignment.center,
                        children: [
                          Icon(iconData, color: Get.theme.focusColor).marginOnly(right: 10),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(CountryCodeChangeDialogWidget());
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: Obx(() {
                                // return Text('${Get.find<AuthController>().selectedCountryCode}', style: const TextStyle(color: Colors.white));
                                return Text('${Get.find<AuthService>().user.value.countryCode}', style: const TextStyle(color: Colors.white));
                              }),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: EdgeInsets.all(0),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                errorText: errorText,
              )),
        ]));
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}

class CountryCodeChangeDialogWidget extends GetView<AuthController> {
  const CountryCodeChangeDialogWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("sjdnfjksa in CountryCodeChangeDialogWidget countryCode ${Get.find<AuthService>().user.value.countryCode}");
    // TODO: implement build
    return SimpleDialog(
      title: Text('Select Your Country Code!'.tr),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            // controller.selectedCountryCode.value = countryCodeAu;
            // Get.find<AuthService>().user.value.countryCode = countryCodeAu;
            Get.find<AuthService>().user.update((val) {
              val.countryCode = countryCodeAu;
            });

            Get.back();
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/img/au_flag.png",
                      height: 42,
                      width: 42,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("+61".tr)
                  ],
                ),
                if (Get.find<AuthService>().user.value.countryCode == "+61")
                  Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 24,
                  )
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            // controller.selectedCountryCode.value = countryCodeBd;
            // Get.find<AuthService>().user.value.countryCode = countryCodeBd;
            Get.find<AuthService>().user.update((val) {
              val.countryCode = countryCodeBd;
            });
            // Get.find<AuthService>().user.value.phoneNumber = Get.find<AuthService>().user.value.phoneNumber;
            Get.back();
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/img/bd_flag.png",
                      height: 42,
                      width: 42,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("+88".tr)
                  ],
                ),
                if (Get.find<AuthService>().user.value.countryCode == "+88")
                  Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 24,
                  )
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            // controller.selectedCountryCode.value = countryCodeAu;
            // Get.find<AuthService>().user.value.countryCode = countryCodeAu;
            Get.find<AuthService>().user.update((val) {
              val.countryCode = countryCodeSa;
            });

            Get.back();
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/img/saudi_arab.png",
                      height: 42,
                      width: 42,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("+966".tr)
                  ],
                ),
                if (Get.find<AuthService>().user.value.countryCode == "+966")
                  Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 24,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
