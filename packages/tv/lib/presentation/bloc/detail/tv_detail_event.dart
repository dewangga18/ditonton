part of 'tv_detail_bloc.dart';

sealed class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
}

class FetchTvRecommendation extends TvDetailEvent {
  final int id;

  const FetchTvRecommendation(this.id);

  @override
  List<Object> get props => [id];
}

class AddTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const AddTvWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class DeleteTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const DeleteTvWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
