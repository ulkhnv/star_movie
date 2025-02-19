import 'package:star_movie/src/domain/entities/movie_cover.dart';
import 'package:star_movie/src/domain/usecases/get_now_showing_movies_use_case.dart';
import 'package:star_movie/src/domain/usecases/get_upcoming_movies_use_case.dart';
import 'package:star_movie/src/presentation/bloc/bloc.dart';
import 'package:star_movie/src/presentation/mappers/movie_ui_mapper.dart';
import 'package:star_movie/src/presentation/models/movie_cover_ui_model.dart';
import 'package:star_movie/src/presentation/screen/home/home_tile.dart';

class HomeBloc extends BlocImpl<HomeTile> {
  HomeBloc({
    required this.getNowShowingMoviesUseCase,
    required this.getUpcomingMoviesUseCase,
    required this.movieUiMapper,
  });

  final GetNowShowingMoviesUseCase getNowShowingMoviesUseCase;
  final GetUpcomingMoviesUseCase getUpcomingMoviesUseCase;
  final MovieUiMapper movieUiMapper;
  var homeTile = HomeTile.init();

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    final nowShowingMovies =
        await _fetchMovies(getNowShowingMoviesUseCase.call);
    final upcomingMovies = await _fetchMovies(getUpcomingMoviesUseCase.call);

    homeTile = homeTile.copyWith(
      nowShowingMovies: nowShowingMovies,
      upcomingMovies: upcomingMovies,
    );

    _updateData();
  }

  Future<void> updateMovie(int index) async {
    final movies = await _fetchMovies(
      (index == 0 ? getNowShowingMoviesUseCase : getUpcomingMoviesUseCase).call,
      forceUpdate: true,
    );

    homeTile = homeTile.copyWith(
      nowShowingMovies: index == 0 ? movies : homeTile.nowShowingMovies,
      upcomingMovies: index == 1 ? movies : homeTile.upcomingMovies,
    );

    _updateData();
  }

  Future<void> searchMovies(int index, String query) async {
    final filteredMovies = _filterMovies(
      index == 0 ? homeTile.nowShowingMovies : homeTile.upcomingMovies,
      query,
    );

    handleData(
      data: index == 0
          ? homeTile.copyWith(nowShowingMovies: filteredMovies)
          : homeTile.copyWith(upcomingMovies: filteredMovies),
    );
  }

  Future<List<MovieCoverUIModel>> _fetchMovies(
      Future<List<MovieCover>> Function(bool) useCase,
      {bool forceUpdate = false}) async {
    final movies = await useCase(forceUpdate);
    return movies
        .map((movie) => movieUiMapper.toMovieCoverUIModel(movie))
        .toList();
  }

  List<MovieCoverUIModel> _filterMovies(
      List<MovieCoverUIModel> movies, String query) {
    if (query.isEmpty) return movies;
    return movies
        .where((movie) =>
            movie.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }

  void _updateData() {
    handleData(data: homeTile);
  }
}
