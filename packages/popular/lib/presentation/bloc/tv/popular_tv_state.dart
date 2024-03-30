part of 'popular_tv_bloc.dart';

sealed class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object> get props => [];
}

final class PopularTvEmpty extends PopularTvState {}

final class PopularTvLoading extends PopularTvState {}

final class PopularTvError extends PopularTvState {
  final Failure error;

  const PopularTvError(this.error);
  @override
  List<Object> get props => [error];
}

final class PopularTvHasData extends PopularTvState {
  final List<Tv> result;

  const PopularTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
