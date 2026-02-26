import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Divider horizontalDivider({
  double? height,
  double? endIndent,
  double? opacity,
}) => Divider(
  color: AppColors.greyColor.withValues(alpha: opacity ?? 0.2),
  height: height ?? 1,
  endIndent: endIndent,
);

Widget verticalDivider({
  double? height,
  double? width,
  double? indent,
  double? endIndent,
}) {
  return height == null
      ? VerticalDivider(
          color: AppColors.greyColor.withValues(alpha: 0.2),
          width: width ?? 1,
          indent: indent,
          endIndent: endIndent,
        )
      : SizedBox(
          height: height,
          child: VerticalDivider(
            color: AppColors.greyColor.withValues(alpha: 0.2),
            width: width ?? 1,
          ),
        );
}
