part of '../../widgets.dart';

typedef TimelineListItemChildBuilder = Widget Function(
    BuildContext context, bool isFirst, bool isLast);

class TimelineListItem {
  TimelineListItem({
    required this.child,
    this.height,
    this.width,
    this.margin = 4.0,
    this.icon,
    this.imageUrl,
    this.label,
  });

  final TimelineListItemChildBuilder child;
  final double margin;
  final double? height;
  final double? width;
  final IconData? icon;
  final String? imageUrl;
  final String? label;
}
