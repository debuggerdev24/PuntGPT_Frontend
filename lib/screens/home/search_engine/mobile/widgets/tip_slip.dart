import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/tip_slip_model.dart';

class TipSlipItem extends StatelessWidget {
  const TipSlipItem({
    super.key,
    required this.tipSlip,
    required this.isExpanded,
    required this.onTap,
    this.onRemove,
  });

  final TipSlipModel tipSlip;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final selection = tipSlip.selection;
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: isExpanded
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.3),
          width: isExpanded ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
        color: isExpanded
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 12.w, 12.w, 11.w),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.linear,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  12.w.horizontalSpace,
                  _buildSilksOrPlaceholder(
                    silksImage: selection.silksImage,
                    number: selection.number,
                    context: context,
                  ),
                  12.w.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children:[
                            Text(
                              '${selection.number}. ',
                              style: semiBold(
                                fontSize: context.isBrowserMobile
                                    ? 32.sp
                                    : 16.sp,
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${selection.horseName} (${selection.barrier})",
                                style: semiBold(
                                  fontSize: context.isBrowserMobile
                                      ? 32.sp
                                      : 16.sp,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        4.w.verticalSpace,
                        Text(
                          '${selection.trackName} • R${selection.raceNumber} • ${selection.distance}m',
                          style: regular(
                            fontSize: context.isBrowserMobile ? 26.sp : 13.sp,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  12.w.horizontalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 6.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '\$${selection.unibetFixedOddsWin}',
                      style: bold(
                        fontSize: context.isBrowserMobile ? 32.sp : 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (onRemove != null) ...[
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: () => _showRemoveTipConfirmation(
                        context,
                        onRemove!,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        height: 1,
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                selection.raceName,
                                style: medium(
                                  fontSize: context.isBrowserMobile
                                      ? 24.sp
                                      : 12.sp,
                                  color: AppColors.primary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            12.w.verticalSpace,
                            _buildDetailRow(
                              context: context,
                              icon: Icons.access_time,
                              label: 'Race Time',
                              value: DateFormatter.formatRaceDateTime(
                                selection.startTimeUtc.toIso8601String(),
                              ),
                            ),
                            8.w.verticalSpace,
                            _buildDetailRow(
                              context: context,
                              icon: Icons.person_outline,
                              label: 'Jockey',
                              value: selection.jockeyName,
                            ),
                            8.w.verticalSpace,
                            _buildDetailRow(
                              context: context,
                              icon: Icons.school_outlined,
                              label: 'Trainer',
                              value: selection.trainerName,
                            ),
                            8.w.verticalSpace,
                            // _buildDetailRow(
                            //   context: context,
                            //   icon: Icons.location_on_outlined,
                            //   label: 'Track',
                            //   value: selection.trackName,
                            // ),
                            12.w.verticalSpace,
                            Row(
                              children: [
                                Icon(
                                  Icons.bookmark_added_outlined,
                                  size: 13.sp,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                6.w.horizontalSpace,
                                Text(
                                  'Added ${_formatAddedTime(tipSlip.addedAt)}',
                                  style: regular(
                                    fontSize: context.isBrowserMobile
                                        ? 22.sp
                                        : 11.sp,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  static void _showRemoveTipConfirmation(
    BuildContext context,
    VoidCallback onConfirmRemove,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        content: Text(
          'Are you sure you want to remove this tip?',
          style: medium(fontSize: 16.sp, color: AppColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: medium(fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirmRemove();
            },
            child: Text('Yes', style: semiBold(fontSize: 16.sp,color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
        8.w.horizontalSpace,
        Text(
          '$label: ',
          style: semiBold(
            fontSize: context.isBrowserMobile ? 24.sp : 12.sp,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: regular(
              fontSize: context.isBrowserMobile ? 24.sp : 12.sp,
              color: AppColors.primary.withValues(alpha: 0.9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  static String _formatAddedTime(DateTime addedAt) {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormatter.formatToIso(
        DateTime.parse(addedAt.toIso8601String()),
      );
    }
  }

  static Widget _buildSilksOrPlaceholder({
    required String silksImage,
    required int number,
    required BuildContext context,
  }) {
    final hasValidSilks = silksImage.trim().isNotEmpty;
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: hasValidSilks
            ? ImageWidget(
                path: silksImage,
                type: ImageType.svg,
                errorWidget: _silksPlaceholder(number: number),
              )
            : _silksPlaceholder(number: number),
      ),
    );
  }

  static Widget _silksPlaceholder({required int number}) => Container(
    color: AppColors.primary.withValues(alpha: 0.08),
    alignment: Alignment.center,
    child: Text(
      '$number',
      style: semiBold(fontSize: 16.sp, color: AppColors.primary),
    ),
  );
}
