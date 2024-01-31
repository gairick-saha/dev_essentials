part of '../utils.dart';

class DevEssentialQueue {
  final List<_DevEssentialQueueItem> _queue = [];
  bool _active = false;

  Future<T> add<T>(Function job) {
    var completer = Completer<T>();
    _queue.add(_DevEssentialQueueItem(completer, job));
    _check();
    return completer.future;
  }

  void cancelAllJobs() {
    _queue.clear();
  }

  void _check() async {
    if (!_active && _queue.isNotEmpty) {
      _active = true;
      var item = _queue.removeAt(0);
      try {
        item.completer.complete(await item.job());
      } on Exception catch (e) {
        item.completer.completeError(e);
      }
      _active = false;
      _check();
    }
  }
}

class _DevEssentialQueueItem {
  final dynamic completer;
  final dynamic job;

  _DevEssentialQueueItem(this.completer, this.job);
}
