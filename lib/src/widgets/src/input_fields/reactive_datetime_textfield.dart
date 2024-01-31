part of '../../widgets.dart';

class DevEssentialReactiveDateTimeTextField
    extends ReactiveFormField<DateTime, DateTime> {
  DevEssentialReactiveDateTimeTextField({
    Key? key,
    String? formControlName,
    DevEssentialFormControl<DateTime>? formControl,
    TextEditingController? controller,
    void Function(FocusNode focusNode)? focusListener,
    Map<String, ValidationMessageFunction>? validationMessages,
    bool Function(AbstractControl<DateTime>)? showErrorsCallback,
    InputDecoration decoration = const InputDecoration(),
    bool readOnly = false,
    Color? fillColor,
    bool filled = false,
    EdgeInsetsGeometry? contentPadding,
    String? hintText,
    bool showHintText = true,
    TextStyle? hintStyle,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    bool enabelBorder = true,
    InputBorder? border,
    TextStyle? style,
    bool showLabel = true,
    bool isRequired = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String formatDate = 'dd-MMM-yyyy',
    Color? errorTextColor,
  })  : _textController = controller,
        _focusListener = focusListener,
        _formatDate = formatDate,
        super(
          key: key,
          formControlName: formControlName,
          formControl: formControl,
          validationMessages: validationMessages,
          showErrors: showErrorsCallback,
          builder: (ReactiveFormFieldState<DateTime, DateTime> field) {
            final _DevEssentialReactiveDateTimeTextFieldState state =
                field as _DevEssentialReactiveDateTimeTextFieldState;

            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(state.context).inputDecorationTheme)
                .copyWith(
                  enabled: false,
                  error: state.errorText == null
                      ? null
                      : Text(
                          state.errorText!,
                          textScaler: Dev.textScaler,
                          style: (errorStyle ??
                                  Theme.of(state.context)
                                      .inputDecorationTheme
                                      .errorStyle ??
                                  DefaultTextStyle.of(state.context)
                                      .style
                                      .copyWith(fontSize: 12.0))
                              .copyWith(
                            color: errorTextColor ??
                                Theme.of(state.context).colorScheme.error,
                          ),
                        ),
                  fillColor: fillColor,
                  filled: filled,
                  contentPadding: contentPadding,
                  label: showLabel
                      ? Text.rich(
                          TextSpan(
                            text: hintText ?? formControlName?.capitalize,
                            children: [
                              if (isRequired)
                                TextSpan(
                                  text: ' *',
                                  style: (labelStyle ??
                                          Theme.of(state.context)
                                              .textTheme
                                              .labelLarge)
                                      ?.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          style: labelStyle,
                        )
                      : null,
                  hintText: hintText ??
                      (showHintText ? formControlName?.capitalize : null),
                  hintStyle: hintStyle ??
                      Theme.of(state.context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                          ),
                  labelText: labelText,
                  labelStyle: labelStyle ??
                      Theme.of(state.context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                          ),
                  errorStyle: errorStyle ??
                      Theme.of(state.context).inputDecorationTheme.errorStyle,
                  focusedBorder: !enabelBorder ? InputBorder.none : border,
                  errorBorder: !enabelBorder
                      ? InputBorder.none
                      : border?.copyWith(
                          borderSide: border.borderSide.copyWith(
                            color: Theme.of(state.context).colorScheme.error,
                          ),
                        ),
                  border: !enabelBorder ? InputBorder.none : border,
                  enabledBorder: !enabelBorder ? InputBorder.none : border,
                  disabledBorder: !enabelBorder ? InputBorder.none : border,
                  focusedErrorBorder: !enabelBorder ? InputBorder.none : border,
                  alignLabelWithHint: true,
                );

            return GestureDetector(
              onTap: () async {
                if (readOnly) return;

                firstDate ??= DateTime(2000);
                lastDate ??= firstDate!.add((365.days) * 100);

                final DateTime selectedValue =
                    DateTime.tryParse(state.value?.toString() ?? '') ??
                        DateTime.now();

                final DateTime? pickedDate = await showDatePicker(
                  context: state.context,
                  firstDate: firstDate!,
                  lastDate: lastDate!,
                  initialDate: selectedValue,
                );

                if (pickedDate != null) {
                  state.control.updateValue(pickedDate);
                } else {
                  state.control.markAsTouched();
                }
              },
              child: TextField(
                controller: state._textController,
                style: style ?? DefaultTextStyle.of(state.context).style,
                focusNode: state.focusNode,
                decoration: effectiveDecoration,
                enabled: false,
              ),
            );
          },
        );

  final TextEditingController? _textController;
  final String? _formatDate;
  final void Function(FocusNode focusNode)? _focusListener;

  @override
  ReactiveFormFieldState<DateTime, DateTime> createState() =>
      _DevEssentialReactiveDateTimeTextFieldState();
}

class _DevEssentialReactiveDateTimeTextFieldState
    extends ReactiveFocusableFormFieldState<DateTime, DateTime> {
  late TextEditingController _textController;

  DevEssentialReactiveDateTimeTextField get currentWidget =>
      widget as DevEssentialReactiveDateTimeTextField;

  @override
  void initState() {
    super.initState();
    _initializeTextController();
    focusNode.addListener(() => currentWidget._focusListener?.call(focusNode));
  }

  @override
  void dispose() {
    focusNode
        .removeListener(() => currentWidget._focusListener?.call(focusNode));
    super.dispose();
  }

  void _initializeTextController() {
    final initialValue = (value == null)
        ? ''
        : (value as DateTime).custom(currentWidget._formatDate);
    _textController = (currentWidget._textController != null)
        ? currentWidget._textController!
        : TextEditingController();
    _textController.text = initialValue;
  }

  @override
  void onControlValueChanged(dynamic value) {
    final effectiveValue = (value == null)
        ? ''
        : (value as DateTime).custom(currentWidget._formatDate);
    _textController.value = _textController.value.copyWith(
      text: effectiveValue,
      selection: TextSelection.collapsed(offset: effectiveValue.length),
      composing: TextRange.empty,
    );

    super.onControlValueChanged(value);
  }
}
