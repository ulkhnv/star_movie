import 'package:star_movie/src/domain/entities/enums/movie_cover_category.dart';
import 'package:star_movie/src/domain/usecases/get_movie_covers_use_case.dart';
import 'package:star_movie/src/domain/usecases/movie_cover_params.dart';
import 'package:star_movie/src/presentation/bloc/bloc.dart';
import 'package:star_movie/src/presentation/mappers/movie_ui_mapper.dart';
import 'package:star_movie/src/presentation/models/movie_cover_ui_model.dart';
import 'package:star_movie/src/presentation/screen/home/home_tile.dart';

class HomeBloc extends BlocImpl<HomeTile> {
  HomeBloc({
    required this.getMovieCoversUseCase,
    required this.movieUiMapper,
  });

  final GetMovieCoversUseCase getMovieCoversUseCase;
  final MovieUiMapper movieUiMapper;

  var homeTile = HomeTile.init();
  var pageNumbers = {
    MovieCoverCategory.nowShowing: 1,
    MovieCoverCategory.upcoming: 1
  };

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    await _updateMovies(MovieCoverCategory.nowShowing);
    await _updateMovies(MovieCoverCategory.upcoming);
  }

  Future<void> getNextMovies(int index) async {
    final category = _getCategory(index);
    if (category == null) return;

    pageNumbers[category] = (pageNumbers[category] ?? 1) + 1;
    await _updateMovies(category, append: true);
  }

  Future<void> updateMovies(int index) async {
    final category = _getCategory(index);
    if (category == null) return;

    pageNumbers[category] = 1;
    await _updateMovies(category, forceUpdate: true);
  }

  Future<void> searchMovies(int index, String query) async {
    final category = _getCategory(index);
    if (category == null) return;

    final filteredMovies = _filterMovies(
      category == MovieCoverCategory.nowShowing
          ? homeTile.nowShowingMovies
          : homeTile.upcomingMovies,
      query,
    );

    handleData(
      data: homeTile.copyWith(
        nowShowingMovies: category == MovieCoverCategory.nowShowing
            ? filteredMovies
            : homeTile.nowShowingMovies,
        upcomingMovies: category == MovieCoverCategory.upcoming
            ? filteredMovies
            : homeTile.upcomingMovies,
      ),
    );
  }

  Future<void> _updateMovies(MovieCoverCategory category,
      {bool append = false, bool forceUpdate = false}) async {
    final params = MovieCoverParams(
      movieCoverCategory: category,
      page: pageNumbers[category] ?? 1,
      forceUpdate: forceUpdate,
    );

    final movies = await _fetchMovies(params);
    final updatedMovies =
        append ? [..._getMoviesByCategory(category), ...movies] : movies;

    _updateTile(category, updatedMovies);
  }

  Future<List<MovieCoverUIModel>> _fetchMovies(MovieCoverParams params) async {
    final movies = await getMovieCoversUseCase(params);
    return movies.map(movieUiMapper.toMovieCoverUIModel).toList();
  }

  List<MovieCoverUIModel> _filterMovies(
      List<MovieCoverUIModel> movies, String query) {
    return query.isEmpty
        ? movies
        : movies
            .where((movie) =>
                movie.title.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
  }

  MovieCoverCategory? _getCategory(int index) {
    return index >= 0 && index < MovieCoverCategory.values.length
        ? MovieCoverCategory.values[index]
        : null;
  }

  List<MovieCoverUIModel> _getMoviesByCategory(MovieCoverCategory category) {
    return category == MovieCoverCategory.nowShowing
        ? homeTile.nowShowingMovies
        : homeTile.upcomingMovies;
  }

  void _updateTile(
      MovieCoverCategory category, List<MovieCoverUIModel> movies) {
    homeTile = category == MovieCoverCategory.nowShowing
        ? homeTile.copyWith(nowShowingMovies: movies)
        : homeTile.copyWith(upcomingMovies: movies);

    _updateData();
  }

  void _updateData() {
    handleData(data: homeTile);
  }
}
