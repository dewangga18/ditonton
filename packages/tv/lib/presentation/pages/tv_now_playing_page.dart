
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/list/tv_list_bloc.dart';

class TvNowPlayingPage extends StatelessWidget {
  const TvNowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Now Playing',
        ),
      ),
      body: BlocBuilder<TvListBloc, TvListState>(
        builder: (context, state) {
          if (state is TvListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvListHasData) {
            final result = state.result;

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = result[index];

                return CardList(tv: tv);
              },
              itemCount: result.length,
            );
          } else if (state is TvListError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.error.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}