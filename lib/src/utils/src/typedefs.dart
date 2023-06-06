part of '../utils.dart';

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
  Color? backgroundColor,
);

typedef OnSplashInitCallback = Function(
  VoidCallback loadSplash,
);

typedef DevEssentialSvg = SvgPicture;

typedef DevEssentialToast = BotToast;
