import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/classic_form_guide_view.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_screen_tab.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/punt_gpt_search_engine_view.dart';
import 'package:puntgpt_nick/screens/home/search_engine/widgets/bookie_stories_section.dart';

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
        body: Consumer2<SearchEngineProvider, StoryProvider>(
          builder: (context, provider, storyProvider, child) {
            if (provider.trackList == null ||
                provider.distanceDetails == null ||
                storyProvider.stories == null) {
              return HomeSectionShimmers.homeScreenShimmer(context: context);
            }
            return Column(
              children: [
                //* ---------------> bookie stories section
                BookieStoriesSection(
                  horizontalPadding: 18.w,
                  stories: storyProvider.stories,
                ),
                //* ---------------> home screen tab
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.w, 20.w, 0),
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
                              //* Search Button and ask punt gpt button
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    8.w,
                                    0,
                                    8.w,
                                    10.w,
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: AppFilledButton(
                                            isExpand: false,
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16.w,
                                              horizontal: 15.w,
                                            ),
                                            textStyle: semiBold(
                                              fontSize: 16.sp,
                                              color: AppColors.white,
                                            ),
                                            text:
                                                (provider.runnersList?.isEmpty ?? true) ? "Search" : "Search (${provider.runnersList?.length} runners)",
                                            onTap: () {
                                              context.pushNamed(
                                                AppRoutes.runnersScreen.name,
                                              );
                                              provider.getUpcomingRunner(
                                                onSuccess: () {},
                                              );
                                            },
                                          ),
                                        ),
                                        10.w.horizontalSpace,
                                        Expanded(
                                          child: SizedBox.expand(
                                            child: askPuntGPTButton(
                                              context: context,
                                              margin: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Consumer<ClassicFormProvider>(
                            builder: (context, provider, child) =>
                                provider.classicFormGuide == null ||
                                    provider.nextRaceList == null
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
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 6.w),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.w,
          children: [
            ImageWidget(
              path: AppAssets.horse,
              height: (context.isMobileWeb) ? 42.w : 30.w,
            ),

            Text(
              "Ask @ PuntGPT",
              textAlign: TextAlign.center,
              style: semiBold(
                fontSize: (context.isMobileWeb) ? 38.sp : 19.sp,
                fontFamily: AppFontFamily.secondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
