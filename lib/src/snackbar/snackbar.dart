import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';

part 'src/snackbar_controller.dart';
part 'src/snackbar.dart';

typedef OnSnackbarTap = void Function(DevEssentialSnackBar snack);
typedef OnSnackbarHover = void Function(
    DevEssentialSnackBar snack, SnackHoverState snackHoverState);

typedef SnackbarStatusCallback = void Function(SnackbarStatus? status);

enum RowStyle {
  icon,
  action,
  all,
  none,
}

enum SnackbarStatus { open, closed, opening, closing }

enum SnackPosition { top, bottom }

enum SnackStyle { floating, grounded }

enum SnackHoverState { entered, exited }
