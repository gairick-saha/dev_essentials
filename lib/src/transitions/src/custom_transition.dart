part of '../transitions.dart';

// ignore: one_member_abstracts
abstract class DevEssentialCustomTransition {
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}
