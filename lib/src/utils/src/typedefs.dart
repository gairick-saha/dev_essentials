part of '../utils.dart';

typedef OnAppCloseCallback = Future<bool> Function();

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
  Color? backgroundColor,
);

typedef OnSplashInitCallback = Future<String> Function(
    BuildContext splashContext);

typedef DevEssentialSvgPicture = SvgPicture;
typedef DevEssentialSvgTheme = SvgTheme;

typedef DevEssentialToast = BotToast;

typedef DevEssentialFormGroup = FormGroup;
typedef DevEssentialFormControl<T> = FormControl<T>;
typedef DevEssentialFormValidators = Validators;
typedef DevEssentialFormValidationMessage = ValidationMessage;
typedef DevEssentialReactiveFormBuilder = ReactiveFormBuilder;
typedef DevEssentialReactiveCheckBox = ReactiveCheckbox;
typedef DevEssentialReactiveCheckboxListTile = ReactiveCheckboxListTile;

typedef FlipAnimationChildBuilder = Widget Function(
  BuildContext context,
  AnimationController flipAnimationController,
);

typedef DevEssentialSnackbarOnTapCallback = void Function(
    DevEssentialSnackbar snackbar);

typedef DevEssentialSnackbarStatusCallback = void Function(
  DevEssentialSnackbarStatus? status,
);
