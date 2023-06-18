part of '../hooks.dart';

DevEssentialHookState useDevEssentialHook({
  required ThemeData theme,
  required ThemeData darkTheme,
  required ThemeMode themeMode,
  required DevEssentialTransition? defaultTransition,
  required DevEssentialCustomTransition? customTransition,
  required List<DevEssentialPage>? pages,
  required Duration? defaultTransitionDuration,
  required Curve? defaultTransitionCurve,
  required Curve? defaultDialogTransitionCurve,
  required Duration? defaultDialogTransitionDuration,
}) =>
    use(
      DevEssentialHook(
        theme: theme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        defaultTransition: defaultTransition,
        customTransition: customTransition,
        defaultTransitionDuration: defaultTransitionDuration,
        defaultTransitionCurve: defaultTransitionCurve,
        defaultDialogTransitionCurve: defaultDialogTransitionCurve,
        defaultDialogTransitionDuration: defaultDialogTransitionDuration,
        pages: pages,
      ),
    );

class DevEssentialHook extends Hook<DevEssentialHookState> {
  const DevEssentialHook({
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
    required this.defaultTransition,
    required this.customTransition,
    required this.pages,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
    this.defaultDialogTransitionCurve,
    this.defaultDialogTransitionDuration,
  });

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final DevEssentialTransition? defaultTransition;
  final DevEssentialCustomTransition? customTransition;
  final Duration? defaultTransitionDuration;
  final Curve? defaultTransitionCurve;
  final Curve? defaultDialogTransitionCurve;
  final Duration? defaultDialogTransitionDuration;
  final List<DevEssentialPage>? pages;

  @override
  HookState<DevEssentialHookState, Hook<DevEssentialHookState>> createState() =>
      DevEssentialHookState();
}

class DevEssentialHookState
    extends HookState<DevEssentialHookState, DevEssentialHook> {
  static DevEssentialHookState? _instance;
  static DevEssentialHookState get instance {
    if (_instance == null) {
      throw Exception('DevEssentialHookState is not part of the tree');
    } else {
      return _instance!;
    }
  }

  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode _currentThemeMode;

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeMode get themeMode => _currentThemeMode;

  ThemeData get theme {
    if (_currentThemeMode == ThemeMode.dark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }

  bool defaultPopGesture = Platform.isIOS;
  bool defaultOpaqueRoute = true;

  late DevEssentialTransition defaultTransition;

  late Duration defaultTransitionDuration = 300.milliseconds;
  late Curve defaultTransitionCurve = Curves.easeOutQuad;

  late Curve defaultDialogTransitionCurve = Curves.easeOutQuad;

  late Duration defaultDialogTransitionDuration = 300.milliseconds;

  DevEssentialCustomTransition? customTransition;

  final DevEssentialRouting routing = DevEssentialRouting();
  final DevEssentialRouting nestedRouting = DevEssentialRouting();

  void _addPages() {
    if (hook.pages != null) {
      routing.addPages(hook.pages!);
    }
  }

  @override
  void initHook() {
    _addPages();

    _lightTheme = hook.theme;
    _darkTheme = hook.darkTheme;
    _currentThemeMode = hook.themeMode;

    defaultTransition =
        hook.defaultTransition ?? DevEssentialTransition.rightToLeft;
    defaultTransitionDuration =
        hook.defaultTransitionDuration ?? 300.milliseconds;
    defaultTransitionCurve = hook.defaultTransitionCurve ?? Curves.easeOutQuad;
    defaultDialogTransitionCurve =
        hook.defaultDialogTransitionCurve ?? Curves.easeOutQuad;
    defaultDialogTransitionDuration =
        hook.defaultDialogTransitionDuration ?? 300.milliseconds;
    customTransition = hook.customTransition;

    DevEssentialHookState._instance = this;
    super.initHook();
  }

  @override
  void didUpdateHook(covariant DevEssentialHook oldHook) {
    if (oldHook.themeMode != hook.themeMode ||
        oldHook.theme != hook.theme ||
        oldHook.darkTheme != hook.darkTheme ||
        oldHook.defaultTransition != hook.defaultTransition ||
        oldHook.defaultTransitionDuration != hook.defaultTransitionDuration ||
        oldHook.defaultTransitionCurve != hook.defaultTransitionCurve ||
        oldHook.defaultDialogTransitionCurve !=
            hook.defaultDialogTransitionCurve ||
        oldHook.defaultDialogTransitionDuration !=
            hook.defaultDialogTransitionDuration ||
        oldHook.customTransition != hook.customTransition) {
      _lightTheme = hook.theme;
      _darkTheme = hook.darkTheme;
      _currentThemeMode = hook.themeMode;

      defaultTransition =
          hook.defaultTransition ?? DevEssentialTransition.rightToLeft;
      defaultTransitionDuration =
          hook.defaultTransitionDuration ?? 300.milliseconds;
      defaultTransitionCurve =
          hook.defaultTransitionCurve ?? Curves.easeOutQuad;
      defaultDialogTransitionCurve =
          hook.defaultDialogTransitionCurve ?? Curves.easeOutQuad;
      defaultDialogTransitionDuration =
          hook.defaultDialogTransitionDuration ?? 300.milliseconds;
      customTransition = hook.customTransition;
    }

    DevEssentialHookState._instance = this;
    setState(() {});
    super.didUpdateHook(oldHook);
  }

  void changeThemeData(ThemeData themeData) => setState(
        () {
          if (_currentThemeMode == ThemeMode.dark) {
            _darkTheme = themeData;
          } else {
            _lightTheme = themeData;
          }
        },
      );

  void changeThemeMode(ThemeMode themeMode) =>
      setState(() => _currentThemeMode = themeMode);

  @override
  DevEssentialHookState build(BuildContext context) => this;
}
