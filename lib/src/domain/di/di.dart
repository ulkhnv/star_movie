import 'package:get_it/get_it.dart';
import 'package:star_movie/src/domain/usecases/get_now_showing_movies_use_case.dart';
import 'package:star_movie/src/domain/usecases/get_upcoming_movies_use_case.dart';

Future<void> initDomainDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<GetNowShowingMoviesUseCase>(
    () => GetNowShowingMoviesUseCase(movieRepository: getIt()),
  );

  getIt.registerLazySingleton<GetUpcomingMoviesUseCase>(
    () => GetUpcomingMoviesUseCase(movieRepository: getIt()),
  );
}
