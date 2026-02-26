import 'package:puntgpt_nick/core/app_imports.dart';

class RaceTableWeb extends StatelessWidget {
  const RaceTableWeb({super.key, required this.tableWidth});
  final double tableWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: tableWidth,
        margin: EdgeInsets.only(top: 24.h, bottom: 55.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          columnWidths: {
            0: FlexColumnWidth(3.5.w),
            1: FlexColumnWidth(6.w),
            2: FlexColumnWidth(3.w),
            3: FlexColumnWidth(3.w),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildRow(
              col1: "Randwick",
              col2: "R1. PuntGPT Legends Stakes 3200m",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "Flemington",
              col2: "R2. Race Sponsor",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "Morphettville",
              col2: "R3. Race Sponsor",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "Doomben",
              col2: "R4. Race Sponsor",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "Gold Coast",
              col2: "R5. Race Sponsor",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "Ascot",
              col2: "R6. Race Sponsor",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "Newcastle",
              col2: "R7. Race Sponsor",
              col3: "2025-09-28",
              col4: "14:35",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
            _buildRow(
              col1: "etc...",
              col2: "etc...",
              col3: "etc...",
              col4: "etc...",
              onTap: () {
                context.pushNamed(WebRoutes.selectedRace.name);
              },
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow({
    required String col1,
    required String col2,
    required String col3,
    required String col4,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final sixteenFontSize = context.isDesktop
        ? 16.sp
        : context.isTablet
        ? 24.sp
        : (context.isBrowserMobile)
        ? 32.sp
        : 16.sp;
    return TableRow(
      children: [
        OnMouseTap(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(col1, style: semiBold(fontSize: sixteenFontSize)),
          ),
        ),
        OnMouseTap(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Text(col2, style: semiBold(fontSize: sixteenFontSize)),
          ),
        ),
        OnMouseTap(
          onTap: onTap,

          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),

            child: Text(col3, style: semiBold(fontSize: sixteenFontSize)),
          ),
        ),
        OnMouseTap(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),

            child: Text(col4, style: semiBold(fontSize: sixteenFontSize)),
          ),
        ),
      ],
    );
  }
}
