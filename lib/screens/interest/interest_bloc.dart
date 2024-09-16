import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../repos/models/liked.dart';

import '../../repos/repositories/graphql/post_repository.dart';
import '../../services/graphql_service.dart';

part 'interest_event.dart';
part 'interest_state.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;

  InterestBloc() : super(InterestInitial()) {
    on<InterestEvent>((event, emit) {});
  }

  static Future<void> fetchLikedContent(PagingController<int, Liked> pagingController, int offset, int limit, int? userId) async {
    try {
      final QueryOptions options = getUserFavorites(offset, limit, userId);
      final QueryResult result = await GraphQLService.instance.client.query(options);
      final List<Liked> likedContents = (result.data?['liked'] as List<dynamic>?)
          ?.map((dynamic item) => Liked.fromJson(item as Map<String, dynamic>)).toList() ?? [];
      final isLastPage = likedContents.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(likedContents);
      } else {
        final nextPageKey = pagingController.nextPageKey! + likedContents.length;
        pagingController.appendPage(likedContents, nextPageKey);
      }
    } catch (error) {
      print(error.toString());
      pagingController.error = error;
    }
  }

}
