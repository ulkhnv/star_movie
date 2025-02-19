import 'package:star_movie/src/presentation/navigator/base_page.dart';
import 'package:star_movie/src/presentation/screen/home/home_screen.dart';

class AppTile {
  AppTile({required this.pages});

  final List<BasePage> pages;

  factory AppTile.init() => AppTile(pages: [HomeScreen.page()]);
}
