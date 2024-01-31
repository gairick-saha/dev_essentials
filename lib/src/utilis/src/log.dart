part of '../utils.dart';

typedef DevEssentialLogWriterCallback = void Function(dynamic message,
    {String? name});

void defaultLogWriterCallback(dynamic message, {String? name}) {
  if (Dev.isLogEnable) {
    developer.log((message).toString(), name: name ?? 'DevEssential');
  }
}
