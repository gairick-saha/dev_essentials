part of '../utils.dart';

class Engine {
  static WidgetsBinding get widgetsBinding =>
      WidgetsFlutterBinding.ensureInitialized();

  static SchedulerBinding get schedulerBinding => SchedulerBinding.instance;
}
