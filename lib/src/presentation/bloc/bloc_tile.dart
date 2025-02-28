class BlocTile {
  BlocTile(
    this.isLoading,
    this.isValid,
    this.data,
    this.isDispose,
    this.isScreenLoading,
    this.actualDataHasLoaded,
  );

  bool isLoading;
  bool isValid;
  dynamic data;
  bool isDispose;
  bool isScreenLoading;
  bool actualDataHasLoaded;

  factory BlocTile.init() => BlocTile(
        false,
        false,
        null,
        false,
        true,
        true,
      );

  void updateParams(
    bool? isLoading,
    bool? isValid,
    dynamic data,
    bool? isScreenLoading,
    bool? actualDataHasLoaded,
  ) {
    if (isLoading != null) this.isLoading = isLoading;
    if (isValid != null) this.isValid = isValid;
    if (data != null) this.data = data;
    if (isScreenLoading != null) this.isScreenLoading = isScreenLoading;
    if (actualDataHasLoaded != null) {
      this.actualDataHasLoaded = actualDataHasLoaded;
    }
  }

  void dispose() {
    isDispose = true;
  }

  BlocTile copy() {
    return BlocTile(
      isLoading,
      isValid,
      data,
      isDispose,
      isScreenLoading,
      actualDataHasLoaded,
    );
  }
}
