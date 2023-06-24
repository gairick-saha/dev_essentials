part of '../utils.dart';

class DevEssentialMicrotask {
  int _version = 0;
  int _microtask = 0;

  int get microtask => _microtask;
  int get version => _version;

  void exec(Function callback) {
    if (_microtask == _version) {
      _microtask++;
      scheduleMicrotask(
        () {
          _version++;
          _microtask = _version;
          callback();
        },
      );
    }
  }
}
