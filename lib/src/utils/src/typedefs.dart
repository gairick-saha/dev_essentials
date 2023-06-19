part of '../utils.dart';

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
typedef DevEssentialReactiveDropdownField<T> = ReactiveDropdownField<T>;
