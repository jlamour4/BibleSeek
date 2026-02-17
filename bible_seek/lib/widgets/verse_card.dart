import 'package:flutter/material.dart';

import 'package:bible_seek/src/design/app_colors.dart';
import 'package:bible_seek/src/design/radius.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';

/// Reusable verse card used throughout the app.
/// Displays a verse reference, preview text, and action buttons.
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

  @override
  Widget build(BuildContext context) {
    final upIcon = myVote == 1 ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined;
    final downIcon =
        myVote == -1 ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined;

    final colorScheme = Theme.of(context).colorScheme;

    Widget cardChild = Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space14,
          AppSpacing.space10,
          AppSpacing.space14,
          AppSpacing.space10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayRef,
              style: AppTextStyles.verseRef(context).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.space6),
            Text(
              previewText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyText(context),
            ),
            const SizedBox(height: AppSpacing.space10),
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outline.withValues(alpha: 0.25),
            ),
            const SizedBox(height: AppSpacing.space8),
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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space8,
        vertical: AppSpacing.space6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.r24,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniAction(
            icon: upIcon,
            label: _formatCount(voteCount),
            onTap: onUpvote,
          ),
          const SizedBox(width: AppSpacing.space6),
          _MiniAction(
            icon: downIcon,
            label: '',
            onTap: onDownvote,
          ),
          const SizedBox(width: AppSpacing.space10),
          _MiniAction(
            icon: Icons.chat_bubble_outline,
            label: commentCount > 0 ? _formatCount(commentCount) : '',
            onTap: onComments,
          ),
          const SizedBox(width: AppSpacing.space10),
          _MiniAction(
            icon: isFavorited ? Icons.favorite : Icons.favorite_border,
            label: '',
            onTap: onFavorite,
            iconColor: isFavorited ? AppColors.likeRed : null,
          ),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.r24,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space8,
          vertical: AppSpacing.space6,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            if (label.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.space6),
              Text(
                label,
                style: AppTextStyles.metaText(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
