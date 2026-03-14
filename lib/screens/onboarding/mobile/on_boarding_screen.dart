import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/screens/onboarding/mobile/widgets/plan.dart';
import 'package:puntgpt_nick/screens/onboarding/mobile/widgets/video_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  void initState() {
    super.initState();
    isGuest = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Video area fills remaining height
            40.w.verticalSpace,
            VideoWidget(),
            24.w.verticalSpace,
            Plans(),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.fromLTRB(25, 0, 25, context.bottomPadding + 30),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       AppFiledButton(
      //         text: _currentIndex == 0
      //             ? "Continue with Free Account"
      //             : "Subscribe",
      //         onTap: () {
      //           context.read<AuthProvider>().clearSignUpControllers();
      //
      //           context.push(
      //             AppRoutes.signup,
      //             extra: {'is_free_sign_up': _currentIndex == 0},
      //           );
      //           context.read<AuthProvider>().clearSignUpControllers();
      //         },
      //       ),
      //       // 12.h.verticalSpace,
      //       // Row(
      //       //   mainAxisAlignment: MainAxisAlignment.center,
      //       //   children: List.generate(
      //       //     planData.length,
      //       //     (index) => GestureDetector(
      //       //       onTap: () {
      //       //         setState(() {
      //       //           _currentIndex = index;
      //       //         });
      //       //       },
      //       //       child: AnimatedContainer(
      //       //         duration: Duration(milliseconds: 300),
      //       //         margin: EdgeInsets.symmetric(horizontal: 4),
      //       //         height: 15.w,
      //       //         width: 15.w,
      //       //         decoration: BoxDecoration(
      //       //           color: _currentIndex == index
      //       //               ? AppColors.primary
      //       //               : AppColors.primary.setOpacity(0.3),
      //       //         ),
      //       //       ),
      //       //     ),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}
