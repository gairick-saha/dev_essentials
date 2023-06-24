part of '../dev_snackbar.dart';

class _SnackBarQueue {
  final DevEssentialQueue _queue = DevEssentialQueue();
  final _snackbarList = <DevEssentialSnackbarController>[];

  DevEssentialSnackbarController? get _currentSnackbar {
    if (_snackbarList.isEmpty) return null;
    return _snackbarList.first;
  }

  bool get _isJobInProgress => _snackbarList.isNotEmpty;

  Future<void> _addJob(DevEssentialSnackbarController job) async {
    _snackbarList.add(job);
    final data = await _queue.add(job._show);
    _snackbarList.remove(job);
    return data;
  }

  Future<void> _cancelAllJobs() async {
    await _currentSnackbar?.close();
    _queue.cancelAllJobs();
    _snackbarList.clear();
  }

  Future<void> _closeCurrentJob() async {
    if (_currentSnackbar == null) return;
    await _currentSnackbar!.close();
  }
}
