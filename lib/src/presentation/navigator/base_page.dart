import 'package:flutter/material.dart';

class BasePage<T> extends Page<T> {
  const BasePage({
    required LocalKey super.key,
    required String super.name,
    required this.builder,
    super.arguments,
    this.isShowAnim,
    this.onWillPop,
  });

  final WidgetBuilder builder;
  final bool? isShowAnim;
  final bool? onWillPop;

  @override
  Route<T> createRoute(BuildContext context) => _AppRoute(
        settings: this,
        builder: builder,
        isShowAnim: isShowAnim,
        onWillPop: onWillPop ?? true,
      );

  @override
  String toString() => '$name';
}

class _AppRoute<T> extends MaterialPageRoute<T> {
  _AppRoute({
    required super.builder,
    required RouteSettings super.settings,
    this.isShowAnim = true,
    this.onWillPop = true,
  });

  final bool? isShowAnim;
  final bool onWillPop;

  @override
  @protected
  bool get hasScopedWillPopCallback => !onWillPop;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!(isShowAnim ?? true)) {
      return child;
    }

    return Theme.of(context).pageTransitionsTheme.buildTransitions<T>(
          this,
          context,
          animation,
          secondaryAnimation,
          child,
        );
  }
}
