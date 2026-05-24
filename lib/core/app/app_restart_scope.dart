import 'package:flutter/material.dart';

class AppRestartScope extends StatefulWidget {
  final Widget child;

  const AppRestartScope({super.key, required this.child});

  static bool restart(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<_AppRestartInherited>();
    if (scope == null) return false;
    scope.restart();
    return true;
  }

  @override
  State<AppRestartScope> createState() => _AppRestartScopeState();
}

class _AppRestartScopeState extends State<AppRestartScope> {
  Key _key = UniqueKey();

  void _restart() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return _AppRestartInherited(
      restart: _restart,
      child: KeyedSubtree(key: _key, child: widget.child),
    );
  }
}

class _AppRestartInherited extends InheritedWidget {
  final VoidCallback restart;

  const _AppRestartInherited({required this.restart, required super.child});

  @override
  bool updateShouldNotify(_AppRestartInherited oldWidget) {
    return restart != oldWidget.restart;
  }
}
