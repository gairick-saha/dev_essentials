part of '../../widgets.dart';

class DevEssentialPageView extends StatelessWidget {
  const DevEssentialPageView({Key? key, required this.children})
      : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: 0,
      children: children,
    );
  }
}
