// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../dev_essentials.dart';

part 'src/snackbar_queue.dart';
part 'src/controller.dart';
part 'src/hook.dart';
part 'src/snackbar.dart';

enum DevEssentialSnackbarStatus { OPEN, CLOSED, OPENING, CLOSING }

enum DevEssentialSnackbarPosition { TOP, BOTTOM }

enum DevEssentialSnackbarStyle { FLOATING, DOCKED }

enum DevEssentialSnackbarRowStyle {
  icon,
  action,
  all,
  none,
}
