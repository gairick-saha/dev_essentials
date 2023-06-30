part of '../../widgets.dart';

class DevEssentialReactiveFormTextfield<T>
    extends ReactiveFormField<T, String> {
  DevEssentialReactiveFormTextfield({
    Key? key,
    String? formControlName,
    FormControl<T>? formControl,
    Map<String, ValidationMessageFunction>? validationMessages,
    ControlValueAccessor<T, String>? valueAccessor,
    ShowErrorsFunction<T>? showErrors,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    String? labelText,
    TextStyle? labelStyle,
    String? hintText,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    bool? showCursor,
    bool? obscureText,
    String obscuringCharacter = '•',
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    MouseCursor? mouseCursor,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    AppPrivateCommandCallback? onAppPrivateCommand,
    String? restorationId,
    ScrollController? scrollController,
    TextSelectionControls? selectionControls,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    TextEditingController? controller,
    Clip clipBehavior = Clip.hardEdge,
    bool enableIMEPersonalizedLearning = true,
    bool scribbleEnabled = true,
    ReactiveFormFieldCallback<T>? onTap,
    ReactiveFormFieldCallback<T>? onEditingComplete,
    ReactiveFormFieldCallback<T>? onSubmitted,
    ReactiveFormFieldCallback<T>? onChanged,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    String counterText = '',
    Widget? suffix,
    Widget? prefix,
    String? prefixText,
    bool enabelBorder = true,
    InputBorder? border,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    bool filled = false,
    TapRegionCallback? onTapOutside,
    bool Function(AbstractControl<dynamic>)? showErrorsCallback,
    bool showHintText = true,
    void Function(FocusNode focusNode)? focusListener,
  })  : _textController = controller,
        _obscureText = obscureText,
        _focusListener = focusListener,
        super(
          key: key,
          formControlName: formControlName,
          formControl: formControl,
          validationMessages: validationMessages,
          showErrors: showErrorsCallback,
          focusNode: focusNode,
          builder: (ReactiveFormFieldState<T, String> field) {
            final _DevEssentialReactiveTextFieldState<T> state =
                field as _DevEssentialReactiveTextFieldState<T>;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(state.context).inputDecorationTheme);

            return TextField(
              controller: state._textController,
              focusNode: state.focusNode,
              decoration: effectiveDecoration.copyWith(
                fillColor: fillColor,
                filled: filled,
                contentPadding: contentPadding,
                counterText: counterText,
                prefixText: prefixText,
                prefixIcon: prefix,
                errorText: state.errorText,
                suffixIcon:
                    (formControlName?.toLowerCase() ?? '').contains('password')
                        ? IconButton(
                            onPressed: state.togglePasswordVisibility,
                            icon: Icon(
                              state._obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Theme.of(state.context).iconTheme.color,
                            ),
                          )
                        : suffix,
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
              ),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              contextMenuBuilder: contextMenuBuilder,
              readOnly: readOnly,
              showCursor: showCursor,
              onTapOutside: (event) {
                if (onTapOutside != null) {
                  onTapOutside(event);
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              obscureText: state._obscureText,
              autocorrect: autocorrect,
              smartDashesType: smartDashesType ??
                  (state._obscureText
                      ? SmartDashesType.disabled
                      : SmartDashesType.enabled),
              smartQuotesType: smartQuotesType ??
                  (state._obscureText
                      ? SmartQuotesType.disabled
                      : SmartQuotesType.enabled),
              enableSuggestions: enableSuggestions,
              maxLengthEnforcement: maxLengthEnforcement,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              inputFormatters: inputFormatters,
              enabled: field.control.enabled,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              scrollPhysics: scrollPhysics,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              buildCounter: buildCounter,
              autofillHints: autofillHints,
              mouseCursor: mouseCursor,
              obscuringCharacter: obscuringCharacter,
              dragStartBehavior: dragStartBehavior,
              onAppPrivateCommand: onAppPrivateCommand,
              restorationId: restorationId,
              scrollController: scrollController,
              selectionControls: selectionControls,
              selectionHeightStyle: selectionHeightStyle,
              selectionWidthStyle: selectionWidthStyle,
              clipBehavior: clipBehavior,
              enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
              scribbleEnabled: scribbleEnabled,
              onTap: onTap != null ? () => onTap(field.control) : null,
              onSubmitted: onSubmitted != null
                  ? (_) => onSubmitted(field.control)
                  : null,
              onEditingComplete: onEditingComplete != null
                  ? () => onEditingComplete.call(field.control)
                  : null,
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(field.control);
              },
            );
          },
        );

  final TextEditingController? _textController;

  final bool? _obscureText;

  final void Function(FocusNode focusNode)? _focusListener;

  @override
  ReactiveFormFieldState<T, String> createState() =>
      _DevEssentialReactiveTextFieldState<T>();
}

class _DevEssentialReactiveTextFieldState<T>
    extends ReactiveFocusableFormFieldState<T, String> {
  late TextEditingController _textController;
  late bool _obscureText;

  void togglePasswordVisibility() => setState(() {
        _obscureText = !_obscureText;
      });

  DevEssentialReactiveFormTextfield<T> get currentWidget =>
      widget as DevEssentialReactiveFormTextfield<T>;

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

  @override
  void onControlValueChanged(dynamic value) {
    final effectiveValue = (value == null) ? '' : value.toString();
    _textController.value = _textController.value.copyWith(
      text: effectiveValue,
      selection: TextSelection.collapsed(offset: effectiveValue.length),
      composing: TextRange.empty,
    );

    super.onControlValueChanged(value);
  }

  @override
  ControlValueAccessor<T, String> selectValueAccessor() {
    if (control is FormControl<int>) {
      return IntValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<double>) {
      return DoubleValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<DateTime>) {
      return DateTimeValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<TimeOfDay>) {
      return TimeOfDayValueAccessor() as ControlValueAccessor<T, String>;
    }

    return super.selectValueAccessor();
  }

  void _initializeTextController() {
    final initialValue = value;
    _textController = (currentWidget._textController != null)
        ? currentWidget._textController!
        : TextEditingController();
    _obscureText = (currentWidget._obscureText != null)
        ? currentWidget._obscureText!
        : ((currentWidget.formControlName ?? '')
            .toLowerCase()
            .contains('password'));
    _textController.text = initialValue == null ? '' : initialValue.toString();
  }
}
