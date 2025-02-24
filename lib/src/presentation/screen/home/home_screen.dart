import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:star_movie/src/presentation/bloc/bloc_screen.dart';
import 'package:star_movie/src/presentation/constants/constants.dart';
import 'package:star_movie/src/presentation/models/toggle_button_model.dart';
import 'package:star_movie/src/presentation/navigator/base_page.dart';
import 'package:star_movie/src/presentation/screen/home/home_bloc.dart';
import 'package:star_movie/src/presentation/screen/home/home_tile.dart';
import 'package:star_movie/src/presentation/theme/app_spacing.dart';
import 'package:star_movie/src/presentation/widgets/home/movie_grid_shimmer.dart';
import 'package:star_movie/src/presentation/widgets/home/movie_grid_view.dart';
import 'package:star_movie/src/presentation/widgets/home/toggle_menu.dart';

class HomeScreen extends BlocScreen {
  const HomeScreen({super.key});

  static const routeName = '/HomeScreen';

  static BasePage page() => BasePage(
        key: UniqueKey(),
        builder: (context) => const HomeScreen(),
        name: routeName,
        isShowAnim: true,
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BlocScreenState<HomeScreen, HomeBloc>
    with SingleTickerProviderStateMixin {
  static const int _tabLength = 2;

  late final TabController _tabController;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLength, vsync: this)
      ..addListener(_stopSearch);
    _searchController = TextEditingController()..addListener(_searchMovies);
    _scrollController = ScrollController()..addListener(_getNextMovies);
  }

  void _startSearch() => setState(() => _isSearching = true);

  void _stopSearch() {
    if (_isSearching) {
      setState(() => _isSearching = false);
    }
    _searchController.clear();
  }

  void _getNextMovies() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      bloc.getNextMovies(_tabController.index);
    }
  }

  void _searchMovies() {
    bloc.searchMovies(_tabController.index, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: [_buildAppBarAction()],
      ),
      body: RefreshIndicator(
        onRefresh: () async => bloc.updateMovies(_tabController.index),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.large,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildToggleMenu(),
                const SizedBox(height: AppSpacing.large),
                _buildMovieList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: searchHint,
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      homeTitle,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildAppBarAction() {
    return IconButton(
      icon: Icon(_isSearching ? Icons.close : Icons.search_outlined, size: 30),
      onPressed: _isSearching ? _stopSearch : _startSearch,
    );
  }

  Widget _buildToggleMenu() {
    return ToggleMenu(
      tabController: _tabController,
      toggleButtons: [
        ToggleButtonModel(text: nowShowing, icon: Icons.play_circle),
        ToggleButtonModel(text: comingSoon, icon: Icons.access_time_rounded),
      ],
    );
  }

  Widget _buildMovieList() {
    return StreamBuilder(
      stream: bloc.dataStream,
      builder: (context, snapshot) {
        final tile = snapshot.data;
        if (tile?.isLoading ?? true) return const MovieGridShimmer();
        if (tile?.data is! HomeTile) return const SizedBox.shrink();

        final data = tile!.data as HomeTile;
        return ContentSizeTabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            MovieGridView(movies: data.nowShowingMovies),
            MovieGridView(movies: data.upcomingMovies),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_stopSearch)
      ..dispose();
    _searchController
      ..removeListener(_searchMovies)
      ..dispose();
    _scrollController
      ..removeListener(_getNextMovies)
      ..dispose();
    super.dispose();
  }
}
