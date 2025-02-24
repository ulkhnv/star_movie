import 'package:get_it/get_it.dart';
import 'package:star_movie/src/presentation/mappers/movie_ui_mapper.dart';
import 'package:star_movie/src/presentation/navigator/base_navigator.dart';
import 'package:star_movie/src/presentation/screen/app/app_bloc.dart';
import 'package:star_movie/src/presentation/screen/home/home_bloc.dart';

Future<void> initPresentationDependencies(GetIt getIt) async {
  getIt.registerFactory<AppBloc>(
    () => AppBloc(),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMovieCoversUseCase: getIt(),
      movieUiMapper: getIt(),
    ),
  );

  getIt.registerSingleton<NavigatorImpl>(
    NavigatorImpl(),
  );

  getIt.registerLazySingleton<MovieUiMapper>(
    () => MovieUIMapperImpl(),
  );
}
