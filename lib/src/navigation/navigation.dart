import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../dev_essentials.dart';
import '../hooks/hooks.dart';

// Decoders
part 'src/decoders/path_decoded.dart';
part 'src/decoders/parse_route_tree.dart';
part 'src/decoders/route_decoder.dart';

// Transition
part 'src/transition/directionality_drag_gesure_recognizer.dart';
part 'src/transition/dev_essential_back_gesture.dart';
part 'src/transition/dev_essential_page_route_transition.dart';

// Middleware
part 'src/middleware/route_middleware.dart';
part 'src/middleware/dev_essential_middleware.dart';
part 'src/middleware/middleware_runner.dart';
part 'src/middleware/page_redirect.dart';

//Navigation Observer
part 'src/observer/dev_essential_navigation_observer.dart';

// Navigation Interface
part 'src/dev_essential_navigation_interface.dart';

// Router Delegate
part 'src/dev_essential_router_delegate.dart';

// Route Information Parser
part 'src/dev_essential_route_information_parser.dart';

//Router Outlet
part 'src/dev_essential_router_lisener.dart';
part 'src/dev_essential_router_outlet.dart';
part 'src/dev_essential_indexed_route_builder.dart';

part 'src/dev_essential_routing.dart';
part 'src/dev_essential_page_route.dart';
part 'src/dev_essential_page.dart';
part 'src/dev_essential_bottomsheet_route.dart';
part 'src/dev_essential_dialog_route.dart';
part 'src/dev_essential_navigator.dart';

enum PopMode {
  history,
  page,
}

enum PreventDuplicateHandlingMode {
  popUntilOriginalRoute,

  doNothing,

  reorderRoutes,

  recreate,
}

String? _extractRouteName(Route? route) {
  if (route?.settings.name != null) {
    return route!.settings.name;
  }

  if (route is DevEssentialPageRoute) {
    return route.name;
  }

  if (route is DevEssentialDialogRoute) {
    return 'DIALOG ${route.hashCode}';
  }

  if (route is DevEssentialModalBottomSheetRoute) {
    return 'BOTTOMSHEET ${route.hashCode}';
  }

  return null;
}
