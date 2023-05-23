part of '../utils.dart';

typedef DevEssentialCubit<T> = Cubit<T>;

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
  Color? backgroundColor,
);

typedef OnSplashInitCallback = Function(
  VoidCallback loadSplash,
);

typedef DevEssentialSvg = SvgPicture;

typedef DevEssentialToast = BotToast;
