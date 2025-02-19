import 'package:star_movie/src/presentation/navigator/base_page.dart';
import 'package:star_movie/src/presentation/navigator/nav_result.dart';

class PopPageResult {
  PopPageResult({
    required this.page,
    this.navResult,
  });

  final BasePage page;
  final NavResult? navResult;
}
