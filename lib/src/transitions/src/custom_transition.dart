part of '../transitions.dart';

// ignore: one_member_abstracts
abstract class DevEssentialCustomTransition {
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}
