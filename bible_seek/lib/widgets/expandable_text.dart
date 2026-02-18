import 'package:flutter/material.dart';

/// A text widget that truncates to [maxLines] when collapsed and expands on tap.
/// Uses TextPainter + LayoutBuilder to detect overflow; "More" appears only when needed.
/// [isExpanded] and [onExpandChanged] allow parent control (e.g. from a floating Collapse chip).
class ExpandableText extends StatelessWidget {
  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 6,
    required this.isExpanded,
    required this.onExpandChanged,
    this.moreStyle,
  });

  final String text;
  final TextStyle style;
  final int maxLines;
  final bool isExpanded;
  final ValueChanged<bool> onExpandChanged;
  final TextStyle? moreStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0) return const SizedBox.shrink();

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        final didOverflow = textPainter.didExceedMaxLines;

        final showMore = didOverflow && !isExpanded;
        final showLess = isExpanded && didOverflow;

        final moreLessStyle = moreStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              maxLines: isExpanded ? null : maxLines,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
              style: style,
            ),
            if (showMore)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () => onExpandChanged(true),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('More', style: moreLessStyle),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            if (showLess)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () => onExpandChanged(false),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Less', style: moreLessStyle),
                      Icon(
                        Icons.keyboard_arrow_up,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
