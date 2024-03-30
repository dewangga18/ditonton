part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final bool isLoading;
  final bool isLoadingRecommendation;
  final bool isWatchlist;
  final Failure? error;
  final Failure? errorRecommendation;
  final MovieDetail? data;
  final List<Movie>? dataRecomendation;

  const MovieDetailState({
    this.isLoading = true,
    this.isLoadingRecommendation = true,
    this.isWatchlist = false,
    this.error,
    this.errorRecommendation,
    this.data,
    this.dataRecomendation,
  });

  MovieDetailState copyWith({
    bool? isLoading,
    bool? isLoadingRecommendation,
    bool? isWatchlist,
    Failure? error,
    final Failure? errorRecommendation,
    final MovieDetail? data,
    final List<Movie>? dataRecomendation,
  }) {
    return MovieDetailState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingRecommendation:
          isLoadingRecommendation ?? this.isLoadingRecommendation,
      isWatchlist: isWatchlist ?? this.isWatchlist,
      error: error ?? this.error,
      errorRecommendation: errorRecommendation ?? this.errorRecommendation,
      data: data ?? this.data,
      dataRecomendation: dataRecomendation ?? this.dataRecomendation,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingRecommendation,
        isWatchlist,
        error,
        errorRecommendation,
        data,
        dataRecomendation,
      ];
}
