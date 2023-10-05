part of '../utils.dart';

typedef OnAppCloseCallback = Future<bool> Function();

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
  Color? backgroundColor,
);

typedef OnSplashInitCallback = Future<String?> Function(
    BuildContext splashContext);

typedef DevEssentialSvgPicture = SvgPicture;
typedef DevEssentialSvgTheme = SvgTheme;

typedef DevEssentialToast = BotToast;

typedef DevEssentialForm = ReactiveForm;
typedef DevEssentialFormGroup = FormGroup;
typedef DevEssentialAbstractFormControl<T> = AbstractControl<T>;
typedef DevEssentialFormControl<T> = FormControl<T>;
typedef DevEssentialFormValidator<T> = Validator<T>;
typedef DevEssentialFormValidators = Validators;
typedef DevEssentialFormValidationMessage = ValidationMessage;
typedef DevEssentialFormBuilder = ReactiveFormBuilder;
typedef DevEssentialFormConsumerBuilder = ReactiveFormConsumerBuilder;
typedef DevEssentialFormConsumer = ReactiveFormConsumer;
typedef DevEssentialPinCodeFormField = ReactivePinCodeTextField;
typedef DevEssentialPinTheme = PinTheme;
typedef DevEssentialPinCodeFieldShape = PinCodeFieldShape;
typedef DevEssentialCheckBoxFormField = ReactiveCheckbox;
typedef DevEssentialCheckboxListTileFormField = ReactiveCheckboxListTile;

typedef FlipAnimationChildBuilder = Widget Function(
  BuildContext context,
  AnimationController flipAnimationController,
);

typedef DevEssentialSnackbarOnTapCallback = void Function(
    DevEssentialSnackbar snackbar);

typedef DevEssentialSnackbarStatusCallback = void Function(
  DevEssentialSnackbarStatus? status,
);
