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
import 'package:star_movie/src/presentation/widgets/home/tab_view.dart';
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
  late TabController _tabController;
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _tabController.addListener(_stopSearch);
    _searchController.addListener(_searchMovies);
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _searchMovies() {
    bloc.searchMovies(_tabController.index, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: searchHint,
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.titleMedium,
              )
            : Text(
                homeTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _stopSearch,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.search_outlined,
                    size: 30,
                  ),
                  onPressed: _startSearch,
                ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return bloc.updateMovie(_tabController.index);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.large,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleMenu(
                  tabController: _tabController,
                  toggleButtons: [
                    ToggleButtonModel(
                      text: nowShowing,
                      icon: Icons.play_circle,
                    ),
                    ToggleButtonModel(
                      text: comingSoon,
                      icon: Icons.access_time_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.large),
                StreamBuilder(
                  stream: bloc.dataStream,
                  builder: (context, snapshot) {
                    final tile = snapshot.data;
                    if (tile == null || tile.isLoading) {
                      return const MovieGridShimmer();
                    } else if (tile.data is HomeTile) {
                      final data = tile.data as HomeTile;
                      return TabView(
                        controller: _tabController,
                        children: [
                          MovieGridView(movies: data.nowShowingMovies),
                          MovieGridView(movies: data.upcomingMovies),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_stopSearch);
    _searchController.removeListener(_searchMovies);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
