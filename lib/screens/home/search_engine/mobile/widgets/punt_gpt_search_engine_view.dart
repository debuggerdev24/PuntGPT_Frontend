import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/race_start_timing_options.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_section.dart';

class PuntGptSearchEngineView extends StatelessWidget {
  const PuntGptSearchEngineView({
    super.key,
    required this.provider,
    this.formKey,
  });

  final SearchEngineProvider provider;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.w),
            child: Column(
              children: [
                RaceStartTimingOptions(),
                SearchFields(providerh: provider),
                20.w.verticalSpace,
                IntrinsicWidth(
                  child: AppFilledButton(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    text: "Search",
                    textStyle: semiBold(
                      fontSize: 16.sixteenSp(context),
                      color: AppColors.white,
                    ),
                    onTap: () {
                      context.pushNamed(AppRoutes.runnersScreen.name);
                      provider.getUpcomingRunner(
                        onSuccess: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
