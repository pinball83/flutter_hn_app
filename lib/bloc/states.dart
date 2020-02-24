abstract class NewsState{
  final bool isLoading;
  NewsState({this.isLoading = false});

  copy(bool isLoading);
}

class NewsLoadedState extends NewsState{

  NewsLoadedState({bool isLoading = false}) : super(isLoading: isLoading);

  @override
  copy(bool isLoading) {
    return NewsLoadedState(isLoading: isLoading);
  }

}

class NewsScrolledState extends NewsState{

  NewsScrolledState({bool isLoading = false}) : super(isLoading: isLoading);

  @override
  copy(bool isLoading) {
    return NewsScrolledState(isLoading: isLoading);
  }

}