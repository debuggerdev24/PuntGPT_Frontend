import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/constants/text_style.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';

import 'image_widget.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.hintStyle,
    this.textStyle,
    this.errorStyle,
    this.borderRadius,
    this.trailingIcon,
    this.onTrailingIconTap,
    this.validator,
    this.autovalidateMode,
    this.onTap,
    this.enabled = true,
    this.suffix,
    this.inputFormatter,
    this.keyboardType,
    this.trailingIconWidth,
    this.readOnly,
    this.onSubmit,
    this.margin,
  });

  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintStyle, textStyle, errorStyle;
  final Widget? suffix;
  final double? borderRadius, trailingIconWidth;
  final bool obscureText;
  final dynamic trailingIcon;
  final VoidCallback? onTrailingIconTap, onTap, onSubmit;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool? enabled, readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? margin;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??EdgeInsets.zero,
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly ?? false,
        controller: controller,
        cursorColor: AppColors.primary,
      
        // textStyle: medium(fontSize: (kIsWeb) ? 28.sp : 16.sp),
        obscureText: obscureText,
        autovalidateMode: autovalidateMode,
        enabled: enabled,
        inputFormatters: inputFormatter,
        keyboardType: keyboardType,
        validator: (value) {
          final error = validator?.call(value);
          // if (mounted && _currentError != error) {
          //   Future.microtask(() {
          //     if (mounted && _currentError != error) {
          //       setState(() => _currentError = error);
          //     }
          //   });
          // }
          return error;
        },
        onFieldSubmitted: (value) {
          onSubmit!.call();
        },
        style:
            textStyle ??
            medium(
              fontSize: context.isDesktop
                  ? 15.5.sp
                  : context.isTablet
                  ? 21.sp
                  : (context.isBrowserMobile)
                  ? 28.sp
                  : 16.sp,
            ),
        decoration: InputDecoration(
          suffixIconConstraints: BoxConstraints(
            maxHeight: 26.h.flexClamp(24, 28),
            minHeight: 26.h.flexClamp(24, 28),
            maxWidth: 26.w.flexClamp(24, 28) + 20,
            minWidth: 26.w.flexClamp(24, 28) + 20,
          ),
          suffixIcon: trailingIcon == null
              ? const SizedBox()
              : GestureDetector(
                  onTap: onTrailingIconTap,
                  child: ImageWidget(
                    type: ImageType.svg,
                    height: 10,
                    width: 10, //widget.trailingIconWidth,
                    path: trailingIcon!,
                  ),
                ),
          hintText: hintText,
      
          hintStyle:
              hintStyle ??
              medium(
                fontSize: context.isDesktop
                    ? 14.6.sp
                    : context.isTablet
                    ? 21.5.sp
                    : (context.isBrowserMobile)
                    ? 30.sp
                    : 14.sp,
                color: AppColors.primary.withValues(alpha: 0.65),
              ),
          errorStyle:
              errorStyle ??
              medium(
                fontSize: context.isDesktop
                    ? 15.5.sp
                    : context.isTablet
                    ? 21.sp
                    : (context.isBrowserMobile)
                    ? 26.sp
                    : 12.sp,
                color: AppColors.red,
              ),
          errorMaxLines: 5,
          // error: _currentError == null
          //     ? null
          //     : Transform.translate(
          //         offset: const Offset(-20, 0),
          //         child: Text(
          //           _currentError!,
          //           style:
          //               widget.errorStyle ??
          //               medium(fontSize: 12, color: AppColors.red),
          //         ),
          //       ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          isDense: true,
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.05)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            borderSide: BorderSide(color: AppColors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            borderSide: BorderSide(color: AppColors.red),
          ),
        ),
      ),
    );
  }
}
