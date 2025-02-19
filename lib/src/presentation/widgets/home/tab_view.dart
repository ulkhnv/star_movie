import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({
    super.key,
    required this.controller,
    required this.children,
  });

  final TabController controller;
  final List<Widget> children;

  @override
  State<TabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<TabView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    setState(() {
      _currentIndex = widget.controller.index;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: List.generate(
        widget.children.length,
        (index) => widget.children[index],
      ),
    );
  }
}
