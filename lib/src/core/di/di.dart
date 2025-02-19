import 'package:get_it/get_it.dart';
import 'package:star_movie/src/data/di/di.dart';
import 'package:star_movie/src/domain/di/di.dart';
import 'package:star_movie/src/presentation/di/di.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  await initPresentationDependencies(getIt);
  await initDomainDependencies(getIt);
  await initDataDependencies(getIt);
}
