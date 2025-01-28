import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:star_movie/src/presentation/bloc/bloc_tile.dart';
import 'package:star_movie/src/presentation/navigator/base_navigator.dart';

abstract class Bloc<T extends dynamic> {
  Stream<BlocTile> get dataStream;

  void initState();

  void initArgs(T value);

  void dispose();
}

abstract class BlocImpl<T extends dynamic> implements Bloc<T> {
  @override
  Stream<BlocTile> get dataStream => _data.stream;

  final _data = StreamController<BlocTile>();

  final _blocTile = BlocTile.init();

  @protected
  final appNavigator = GetIt.I.get<NavigatorImpl>();

  @override
  void initState() {}

  @override
  void initArgs(T value) {}

  @override
  void dispose() {
    _blocTile.dispose();
    _data.close();
  }

  @protected
  void handleData({
    bool? isLoading,
    bool? isValid,
    dynamic data,
    bool? isScreenLoading,
    bool? actualDataHasLoaded,
  }) {
    _blocTile.updateParams(
      isLoading,
      isValid,
      data,
      isScreenLoading,
      actualDataHasLoaded,
    );
    _data.add(_blocTile.copy());
  }
}
