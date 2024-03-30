part of 'tv_list_bloc.dart';

sealed class TvListState extends Equatable {
  const TvListState();
  
  @override
  List<Object> get props => [];
}

final class TvListEmpty extends TvListState {}

final class TvListLoading extends TvListState {}

final class TvListError extends TvListState {
  final Failure error;

  const TvListError(this.error);
  @override
  List<Object> get props => [error];
}

final class TvListHasData extends TvListState {
  final List<Tv> result;

  const TvListHasData(this.result);

  @override
  List<Object> get props => [result];
}
