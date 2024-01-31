part of '../extensions.dart';

extension StringExt on String {
  Future<String?> get download async =>
      await DevEssentialUtility.downloadFile(this);

  String? getMimeType() => lookupMimeType(this);

  void showToast({
    WrapAnimation? wrapAnimation,
    WrapAnimation? wrapToastAnimation,
    Color backgroundColor = Colors.transparent,
    Color contentColor = Colors.black54,
    BorderRadiusGeometry borderRadius = const BorderRadius.all(
      Radius.circular(8),
    ),
    TextStyle textStyle = const TextStyle(
      fontSize: 17,
      color: Colors.white,
    ),
    AlignmentGeometry? align = const Alignment(
      0,
      0.8,
    ),
    EdgeInsetsGeometry contentPadding = const EdgeInsets.only(
      left: 14,
      right: 14,
      top: 5,
      bottom: 7,
    ),
    Duration? duration = const Duration(seconds: 2),
    Duration? animationDuration,
    Duration? animationReverseDuration,
    BackButtonBehavior? backButtonBehavior,
    VoidCallback? onClose,
    bool enableKeyboardSafeArea = true,
    bool clickClose = false,
    bool crossPage = true,
    bool onlyOne = true,
  }) =>
      DevEssentialToast.showText(
        text: this,
        wrapAnimation: wrapAnimation,
        wrapToastAnimation: wrapToastAnimation,
        backgroundColor: backgroundColor,
        contentColor: contentColor,
        borderRadius: borderRadius,
        textStyle: textStyle,
        align: align,
        contentPadding: contentPadding,
        duration: duration,
        animationDuration: animationDuration,
        animationReverseDuration: animationReverseDuration,
        backButtonBehavior: backButtonBehavior,
        onClose: onClose,
        enableKeyboardSafeArea: enableKeyboardSafeArea,
        clickClose: clickClose,
        crossPage: crossPage,
        onlyOne: onlyOne,
      );

  bool get isNum => DevEssentialUtility.isNum(this);

  bool get isNumericOnly => DevEssentialUtility.isNumericOnly(this);

  bool get isAlphabetOnly => DevEssentialUtility.isAlphabetOnly(this);

  bool get isBool => DevEssentialUtility.isBool(this);

  bool get isVectorFileName => DevEssentialUtility.isVector(this);

  bool get isImageFileName => DevEssentialUtility.isImage(this);

  bool get isAudioFileName => DevEssentialUtility.isAudio(this);

  bool get isVideoFileName => DevEssentialUtility.isVideo(this);

  bool get isTxtFileName => DevEssentialUtility.isTxt(this);

  bool get isDocumentFileName => DevEssentialUtility.isWord(this);

  bool get isExcelFileName => DevEssentialUtility.isExcel(this);

  bool get isPPTFileName => DevEssentialUtility.isPPT(this);

  bool get isAPKFileName => DevEssentialUtility.isAPK(this);

  bool get isPDFFileName => DevEssentialUtility.isPDF(this);

  bool get isHTMLFileName => DevEssentialUtility.isHTML(this);

  bool get isURL => DevEssentialUtility.isURL(this);

  bool get isEmail => DevEssentialUtility.isEmail(this);

  bool get isPhoneNumber => DevEssentialUtility.isPhoneNumber(this);

  bool get isDateTime => DevEssentialUtility.isDateTime(this);

  bool get isMD5 => DevEssentialUtility.isMD5(this);

  bool get isSHA1 => DevEssentialUtility.isSHA1(this);

  bool get isSHA256 => DevEssentialUtility.isSHA256(this);

  bool get isBinary => DevEssentialUtility.isBinary(this);

  bool get isIPv4 => DevEssentialUtility.isIPv4(this);

  bool get isIPv6 => DevEssentialUtility.isIPv6(this);

  bool get isHexadecimal => DevEssentialUtility.isHexadecimal(this);

  bool get isPalindrom => DevEssentialUtility.isPalindrom(this);

  bool get isPassport => DevEssentialUtility.isPassport(this);

  bool get isCurrency => DevEssentialUtility.isCurrency(this);

  bool isCaseInsensitiveContains(String b) =>
      DevEssentialUtility.isCaseInsensitiveContains(this, b);

  bool isCaseInsensitiveContainsAny(String b) =>
      DevEssentialUtility.isCaseInsensitiveContainsAny(this, b);

  String? get capitalize => DevEssentialUtility.capitalize(this);

  String? get capitalizeFirst => DevEssentialUtility.capitalizeFirst(this);

  String get removeAllWhitespace =>
      DevEssentialUtility.removeAllWhitespace(this);

  String? get camelCase => DevEssentialUtility.camelCase(this);

  String? get paramCase => DevEssentialUtility.paramCase(this);

  String numericOnly({bool firstWordOnly = false}) =>
      DevEssentialUtility.numericOnly(this, firstWordOnly: firstWordOnly);
}
