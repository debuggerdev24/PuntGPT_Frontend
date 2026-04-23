import 'package:puntgpt_nick/core/app_imports.dart';

class AppScreenTopBar extends StatelessWidget {
  const AppScreenTopBar({
    super.key,
    required this.title,
    required this.slogan,
    this.onBack,
  });

  final String title;
  final String slogan;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 6.w, 25.w, 5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: onBack ?? () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 16.wSize),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: regular(
                        fontSize: 24.fSize,
                        fontFamily: AppFontFamily.secondary,
                        height: 1.2,
                      ),
                    ),
                    1.w.verticalSpace,
                    Text(
                      slogan,
                      style: semiBold(
                        fontSize: 14.fSize,
                        height: 1.1,

                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}
