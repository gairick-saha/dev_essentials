part of '../../widgets.dart';

class DevEssentialReactiveDropdownField<T> extends ReactiveFormField<T, T> {
  DevEssentialReactiveDropdownField({
    Key? key,
    String? formControlName,
    FormControl<T>? formControl,
    Map<String, ValidationMessageFunction>? validationMessages,
    bool Function(AbstractControl<dynamic>)? showErrorsCallback,
    InputDecoration decoration = const InputDecoration(),
    required List<DropdownMenuItem<T>> items,
    bool readOnly = false,
    Widget? disabledHint,
    DropdownButtonBuilder? selectedItemBuilder,
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
    ReactiveFormFieldCallback<T>? onTap,
    ReactiveFormFieldCallback<T>? onChanged,
  })  : _items = items,
        _readOnly = readOnly,
        _disabledHint = disabledHint,
        _selectedItemBuilder = selectedItemBuilder,
        super(
          key: key,
          formControlName: formControlName,
          formControl: formControl,
          validationMessages: validationMessages,
          showErrors: showErrorsCallback,
          builder: (ReactiveFormFieldState<T, T> field) {
            final _DevEssentialReactiveDropdownFormTextFieldState<T> state =
                field as _DevEssentialReactiveDropdownFormTextFieldState<T>;

            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(state.context).inputDecorationTheme)
                .copyWith(
                  errorText: state.errorText,
                  enabled: !state.isDisabled,
                  fillColor: fillColor,
                  filled: filled,
                  contentPadding: contentPadding,
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

            return FormField<T>(
              enabled: !state.isDisabled,
              builder: (_) => InputDecorator(
                baseStyle: style,
                isFocused: state.focusNode.hasFocus,
                isEmpty: state.effectiveValue == null,
                decoration: effectiveDecoration,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    focusNode: state.focusNode,
                    value: state.effectiveValue,
                    items: items,
                    disabledHint: state.effectiveDisabledHint,
                    isDense: true,
                    alignment: AlignmentDirectional.topCenter,
                    onTap: onTap != null ? () => onTap(state.control) : null,
                    onChanged: state.isDisabled
                        ? null
                        : (value) {
                            state.didChange(value);
                            onChanged?.call(state.control);
                          },
                  ),
                ),
              ),
            );
          },
        );

  final bool _readOnly;
  final Widget? _disabledHint;
  final List<DropdownMenuItem<T>> _items;
  final DropdownButtonBuilder? _selectedItemBuilder;

  @override
  ReactiveFormFieldState<T, T> createState() =>
      _DevEssentialReactiveDropdownFormTextFieldState<T>();
}

class _DevEssentialReactiveDropdownFormTextFieldState<T>
    extends ReactiveFocusableFormFieldState<T, T> {
  late T? effectiveValue;
  late bool isDisabled;
  Widget? effectiveDisabledHint;

  @override
  void initState() {
    super.initState();
    _initDropdownData();
  }

  void _initDropdownData() {
    final DevEssentialReactiveDropdownField<T> currentWidget =
        widget as DevEssentialReactiveDropdownField<T>;

    effectiveValue = value;
    if (effectiveValue != null &&
        !currentWidget._items.any((item) => item.value == effectiveValue)) {
      effectiveValue = null;
    }

    isDisabled = currentWidget._readOnly || control.disabled;
    effectiveDisabledHint = currentWidget._disabledHint;
    if (isDisabled && currentWidget._disabledHint == null) {
      final int selectedItemIndex = currentWidget._items
          .indexWhere((item) => item.value == effectiveValue);
      if (selectedItemIndex > -1) {
        effectiveDisabledHint = currentWidget._selectedItemBuilder != null
            ? currentWidget._selectedItemBuilder!(context)
                .elementAt(selectedItemIndex)
            : currentWidget._items.elementAt(selectedItemIndex).child;
      }
    }
  }

  @override
  void didChange(T? value) {
    effectiveValue = value;
    super.didChange(value);
  }

  @override
  void onControlValueChanged(dynamic value) {
    effectiveValue = value as T?;
    super.onControlValueChanged(value);
  }
}
