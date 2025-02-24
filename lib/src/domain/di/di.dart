import 'package:get_it/get_it.dart';
import 'package:star_movie/src/domain/usecases/get_movie_covers_use_case.dart';

Future<void> initDomainDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<GetMovieCoversUseCase>(
    () => GetMovieCoversUseCase(movieRepository: getIt()),
  );
}
