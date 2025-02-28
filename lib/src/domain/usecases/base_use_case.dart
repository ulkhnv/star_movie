abstract class BaseUseCase<T, Params> {
  T call(Params params);
}
