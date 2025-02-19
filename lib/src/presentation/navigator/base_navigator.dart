import 'package:star_movie/src/presentation/navigator/base_page.dart';
import 'package:star_movie/src/presentation/navigator/nav_result.dart';

abstract class BaseNavigator {
  void init({
    Function(BasePage page) push,
    Function(BasePage page, {NavResult? result}) popAllAndPush,
    Function(List<BasePage> pages) pushPages,
    Function(BasePage page, {NavResult? result}) popAndPush,
    Function(List<BasePage> pages) popAllAndPushPages,
    Function(NavResult result) pop,
    Function(BasePage page, NavResult result) popUntil,
    Function(String screenName, {NavResult? result, bool includingLast})?
        popUntilByScreenName,
    BasePage Function() currentPage,
    bool Function() canPop,
    bool Function(String pageName) hasPage,
  });

  void dispose();

  void push(BasePage page);

  void popAllAndPush(BasePage page, {NavResult? result});

  void pushPages(List<BasePage> pages);

  void popAndPush(BasePage page, {NavResult result});

  void popAllAndPushPages(List<BasePage> pages);

  void pop({NavResult result});

  void popUntil(BasePage page, {NavResult result});

  void popUntilByScreenName(
    String screenName, {
    NavResult? result,
    bool includingLast = false,
  });

  bool canPop();

  bool hasPage(String pageName);

  BasePage? get currentPage;
}

class NavigatorImpl implements BaseNavigator {
  Function(BasePage page)? _push;
  Function(BasePage page, {NavResult? result})? _popAllAndPush;
  Function(List<BasePage> pages)? _pushPages;
  Function(BasePage page, {NavResult? result})? _popAndPush;
  Function(List<BasePage> pages)? _popAllAndPushPages;
  Function(NavResult result)? _pop;
  Function(BasePage page, NavResult result)? _popUntil;
  Function(
    String screenName, {
    NavResult? result,
    bool includingLast,
  })? _popUntilByScreenName;
  bool Function()? _canPop;
  bool Function(String pageName)? _hasPage;
  BasePage Function()? _currentPage;

  @override
  void init({
    Function(BasePage page)? push,
    Function(BasePage page, {NavResult? result})? popAllAndPush,
    Function(List<BasePage> pages)? pushPages,
    Function(BasePage page, {NavResult? result})? popAndPush,
    Function(List<BasePage> pages)? popAllAndPushPages,
    Function(NavResult result)? pop,
    Function(BasePage page, NavResult result)? popUntil,
    Function(String screenName, {NavResult? result, bool includingLast})?
        popUntilByScreenName,
    BasePage Function()? currentPage,
    bool Function()? canPop,
    bool Function(String pageName)? hasPage,
  }) {
    _push = push;
    _popAllAndPush = popAllAndPush;
    _pushPages = pushPages;
    _popAndPush = popAndPush;
    _popAllAndPushPages = popAllAndPushPages;
    _pop = pop;
    _popUntil = popUntil;

    _hasPage = hasPage;
    _popUntilByScreenName = popUntilByScreenName;
    _currentPage = currentPage;
  }

  @override
  void dispose() => init();

  @override
  void push(BasePage page) => _push?.call(page);

  @override
  void popAllAndPush(BasePage page, {NavResult? result}) {
    _popAllAndPush?.call(page, result: result);
  }

  @override
  void pushPages(List<BasePage> pages) => _pushPages?.call(pages);

  @override
  void pop({NavResult? result}) => _pop?.call(result ?? NavResult());

  @override
  void popUntil(BasePage page, {NavResult? result}) =>
      _popUntil?.call(page, result ?? NavResult());

  @override
  void popAndPush(BasePage page, {NavResult? result}) =>
      _popAndPush?.call(page, result: result);

  @override
  void popAllAndPushPages(List<BasePage> pages) {
    _popAllAndPushPages?.call(pages);
  }

  @override
  bool hasPage(String pageName) => _hasPage?.call(pageName) == true;

  @override
  bool canPop() => _canPop?.call() == true;

  @override
  BasePage? get currentPage => _currentPage?.call();

  @override
  void popUntilByScreenName(
    String screenName, {
    NavResult? result,
    bool includingLast = false,
  }) {
    _popUntilByScreenName?.call(
      screenName,
      result: result,
      includingLast: includingLast,
    );
  }
}
