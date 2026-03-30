
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/classic_form_guide_view.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_screen_tab.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/punt_gpt_search_engine_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0.0;
    if (isVisible != _keyboardVisible) {
      setState(() => _keyboardVisible = isVisible);
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return PopScope(
      canPop: context.watch<SearchEngineProvider>().isSearched ? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (context.read<SearchEngineProvider>().isSearched) {
          context.read<SearchEngineProvider>().setIsSearched(value: false);
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        body: Consumer<SearchEngineProvider>(
          builder: (context, provider, child) {
            if (provider.trackList == null ||
                provider.distanceDetails == null) {
              return HomeSectionShimmers.homeScreenShimmer(context: context);
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 0),
                  child: HomeScreenTab(selectedIndex: provider.selectedTab),
                ),
                16.w.verticalSpace,
                Expanded(
                  child: FadeInUp(
                    from: 1,
                    key: ValueKey(provider.selectedTab),
                    child: (provider.selectedTab == 0)
                        ? Stack(
                            children: [
                              PuntGptSearchEngineView(
                                provider: provider,
                                formKey: formKey,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: askPuntGPTButton(
                                  context: context,
                                  margin: EdgeInsets.only(
                                    right: 18.w,
                                    bottom: 18.w,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Consumer<ClassicFormProvider>(
                            builder: (context, provider, child) =>
                                provider.classicFormGuide == null
                                ? HomeSectionShimmers.classicFormGuideShimmer(
                                    context: context,
                                  )
                                : Stack(
                                    children: [
                                      ClassicFormGuideView(provider: provider),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: askPuntGPTButton(
                                          context: context,
                                          margin: EdgeInsets.only(
                                            right: 18.w,
                                            bottom: 18.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}

Widget askPuntGPTButton({required BuildContext context, EdgeInsets? margin}) {
  return GestureDetector(
    onTap: () {
      // if(){
      context.pushNamed(
        // kIsWeb &&
        (kIsWeb) ? WebRoutes.askPuntGptScreen.name : AppRoutes.askPuntGpt.name,
      );
      // }
    },
    child: Container(
      margin: margin,
      padding: EdgeInsets.symmetric(
        vertical: 12.r.flexClamp(12, 15),
        horizontal: 15.r.flexClamp(15, 18),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            offset: Offset(0, 6),
            blurRadius: 8,
          ),
        ],
        color: AppColors.white,
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            path: AppAssets.horse,
            height: (context.isBrowserMobile) ? 42.w : 30.w,
          ),
          10.w.horizontalSpace,
          Text(
            "Ask @ PuntGPT",
            textAlign: TextAlign.center,
            style: semiBold(
              fontSize: (context.isBrowserMobile) ? 38.sp : 20.sp,
              fontFamily: AppFontFamily.secondary,
            ),
          ),
        ],
      ),
    ),
  );
}
