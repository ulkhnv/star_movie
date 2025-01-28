import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:star_movie/src/presentation/bloc/bloc.dart';

abstract class BlocScreen<A> extends StatefulWidget {
  const BlocScreen({super.key, this.args});

  final A? args;
}

abstract class BlocScreenState<BS extends BlocScreen, B extends Bloc>
    extends State<BS> with WidgetsBindingObserver {
  @protected
  final bloc = GetIt.I.get<B>();

  @override
  void initState() {
    super.initState();
    bloc.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ModalRoute.of(context)?.settings;
      if (settings?.arguments != null || widget.args != null) {
        bloc.initArgs(settings?.arguments ?? widget.args);
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
