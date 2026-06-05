import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> noTransitionPage({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (_, __, ___, child) => child,
  );
}
