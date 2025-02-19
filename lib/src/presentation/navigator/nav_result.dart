class NavResult {
  NavResult({
    this.code = NONE,
    this.value,
  });

  static const OK = 1;
  static const ERROR = -2;
  static const NONE = -1;
  static const CANCEL = 0;

  final int code;
  final dynamic value;
}
