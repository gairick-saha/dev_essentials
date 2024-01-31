part of '../utils.dart';

class Engine {
  static WidgetsBinding get instance =>
      WidgetsFlutterBinding.ensureInitialized();

  static SchedulerBinding get schedulerBinding => SchedulerBinding.instance;

  static void addObserver(WidgetsBindingObserver observer) =>
      instance.addObserver(observer);

  static void removeObserver(WidgetsBindingObserver observer) =>
      instance.removeObserver(observer);
}
