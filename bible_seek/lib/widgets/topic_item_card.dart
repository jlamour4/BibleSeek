import 'package:flutter/material.dart';

import 'package:bible_seek/src/verse.dart';

class TopicItemUiModel {
  final int id;
  final int startVerseCode;
  final int? endVerseCode;
  final String displayRef;
  final String previewText;
  final int voteCount;

  // MVP placeholders
  final int commentCount;
  final bool isFavorited;
  final int? myVote; // 1, -1, or null

  const TopicItemUiModel({
    required this.id,
    required this.startVerseCode,
    required this.endVerseCode,
    required this.displayRef,
    required this.previewText,
    required this.voteCount,
    this.commentCount = 0,
    this.isFavorited = false,
    this.myVote,
  });
}

class TopicItemCard extends StatelessWidget {
  final TopicItemUiModel item;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onComments;
  final VoidCallback onToggleFavorite;
  final VoidCallback onMore;

  const TopicItemCard({
    super.key,
    required this.item,
    required this.onUpvote,
    required this.onDownvote,
    required this.onComments,
    required this.onToggleFavorite,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData upIcon = Icons.thumb_up_alt_outlined;
    IconData downIcon = Icons.thumb_down_alt_outlined;
    if (item.myVote == 1) upIcon = Icons.thumb_up_alt;
    if (item.myVote == -1) downIcon = Icons.thumb_down_alt;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.displayRef,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onMore,
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Verse text
            Text(
              item.previewText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 12),

            // Bottom actions row
            Row(
              children: [
                _ActionPill(
                  upIcon: upIcon,
                  downIcon: downIcon,
                  voteCount: item.voteCount,
                  commentCount: item.commentCount,
                  onUpvote: onUpvote,
                  onDownvote: onDownvote,
                  onComments: onComments,
                ),
                const Spacer(),
                IconButton(
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    item.isFavorited ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final IconData upIcon;
  final IconData downIcon;
  final int voteCount;
  final int commentCount;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onComments;

  const _ActionPill({
    required this.upIcon,
    required this.downIcon,
    required this.voteCount,
    required this.commentCount,
    required this.onUpvote,
    required this.onDownvote,
    required this.onComments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniAction(
            icon: upIcon,
            label: _formatCount(voteCount),
            onTap: onUpvote,
          ),
          const SizedBox(width: 6),
          _MiniAction(
            icon: downIcon,
            label: "",
            onTap: onDownvote,
          ),
          const SizedBox(width: 10),
          _MiniAction(
            icon: Icons.chat_bubble_outline,
            label: commentCount > 0 ? _formatCount(commentCount) : "",
            onTap: onComments,
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000000) return "${(n / 1000000).toStringAsFixed(1)}M";
    if (n >= 1000) return "${(n / 1000).toStringAsFixed(1)}K";
    return "$n";
  }
}

/// Wraps [TopicItemCard] with a Verse, local favorite state, and stub handlers.
class TopicVerseCard extends StatefulWidget {
  const TopicVerseCard({super.key, required this.verse});

  final Verse verse;

  @override
  State<TopicVerseCard> createState() => _TopicVerseCardState();
}

class _TopicVerseCardState extends State<TopicVerseCard> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final v = widget.verse;
    final item = TopicItemUiModel(
      id: v.id,
      startVerseCode: v.startVerseCode,
      endVerseCode: v.endVerseCode,
      displayRef: v.displayRef,
      previewText: v.previewText,
      voteCount: v.voteCount,
      commentCount: 0,
      isFavorited: _isFavorited,
      myVote: null,
    );

    return TopicItemCard(
      item: item,
      onUpvote: () => debugPrint('[TopicVerseCard] upvote id=${v.id}'),
      onDownvote: () => debugPrint('[TopicVerseCard] downvote id=${v.id}'),
      onComments: () => debugPrint('[TopicVerseCard] comments id=${v.id}'),
      onToggleFavorite: () => setState(() => _isFavorited = !_isFavorited),
      onMore: () => debugPrint('[TopicVerseCard] more id=${v.id}'),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
