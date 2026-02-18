import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bible_seek/src/design/app_colors.dart';
import 'package:bible_seek/src/design/radius.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';

/// Reusable verse card used throughout the app.
/// Clean devotional style with verse text as hero, subtle accent bar, unified actions.
class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.displayRef,
    required this.previewText,
    required this.voteCount,
    required this.commentCount,
    required this.isFavorited,
    required this.onUpvote,
    required this.onDownvote,
    required this.onFavorite,
    required this.onComment,
    this.myVote,
    this.onTap,
  });

  final String displayRef;
  final String previewText;
  final int voteCount;
  final int commentCount;
  final bool isFavorited;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onFavorite;
  final VoidCallback onComment;

  /// Current vote state: 1 = upvote, -1 = downvote, null = none
  final int? myVote;

  /// Optional. When set, the whole card is tappable (e.g. to open detail).
  final VoidCallback? onTap;

  static const double _accentBarWidth = 3;
  static const int _verseMaxLines = 5;

  @override
  Widget build(BuildContext context) {
    final upIcon = myVote == 1 ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined;
    final downIcon =
        myVote == -1 ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined;

    final colorScheme = Theme.of(context).colorScheme;

    Widget cardChild = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left accent bar
          Container(
            width: _accentBarWidth,
            margin: const EdgeInsets.only(
              left: AppSpacing.space12,
              top: AppSpacing.space12,
              bottom: AppSpacing.space12,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.35),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
                bottom: Radius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space12,
                AppSpacing.space10,
                AppSpacing.space14,
                AppSpacing.space10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayRef,
                    style: AppTextStyles.metaText(context).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space8),
                  Text(
                    previewText,
                    maxLines: _verseMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.kameron(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space12),
                  _ActionRow(
                    upIcon: upIcon,
                    downIcon: downIcon,
                    voteCount: voteCount,
                    commentCount: commentCount,
                    isFavorited: isFavorited,
                    onUpvote: onUpvote,
                    onDownvote: onDownvote,
                    onComments: onComment,
                    onFavorite: onFavorite,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      cardChild = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.r14,
          child: cardChild,
        ),
      );
    }

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space8,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.r14),
      child: cardChild,
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData upIcon;
  final IconData downIcon;
  final int voteCount;
  final int commentCount;
  final bool isFavorited;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onComments;
  final VoidCallback onFavorite;

  const _ActionRow({
    required this.upIcon,
    required this.downIcon,
    required this.voteCount,
    required this.commentCount,
    required this.isFavorited,
    required this.onUpvote,
    required this.onDownvote,
    required this.onComments,
    required this.onFavorite,
  });

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mutedColor = colorScheme.onSurfaceVariant;

    return Row(
      children: [
        _MiniAction(
          icon: upIcon,
          label: _formatCount(voteCount),
          onTap: onUpvote,
          iconColor: mutedColor,
          labelColor: mutedColor,
          fontSize: 11,
        ),
        const SizedBox(width: AppSpacing.space12),
        _MiniAction(
          icon: downIcon,
          label: '',
          onTap: onDownvote,
          iconColor: mutedColor,
        ),
        const SizedBox(width: AppSpacing.space12),
        _MiniAction(
          icon: Icons.chat_bubble_outline,
          label: commentCount > 0 ? _formatCount(commentCount) : '',
          onTap: onComments,
          iconColor: mutedColor,
          labelColor: mutedColor,
          fontSize: 11,
        ),
        const SizedBox(width: AppSpacing.space12),
        _MiniAction(
          icon: isFavorited ? Icons.favorite : Icons.favorite_border,
          label: '',
          onTap: onFavorite,
          iconColor: isFavorited ? AppColors.likeRed : mutedColor,
        ),
      ],
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final double? fontSize;

  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveLabelColor = labelColor ?? colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: AppRadius.r24,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor ?? colorScheme.onSurfaceVariant),
            if (label.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.space5),
              Text(
                label,
                style: AppTextStyles.metaText(context).copyWith(
                  fontSize: fontSize ?? 12,
                  color: effectiveLabelColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
