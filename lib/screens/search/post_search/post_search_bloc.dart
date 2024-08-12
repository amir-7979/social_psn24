import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'post_search_event.dart';
part 'post_search_state.dart';

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  PostSearchBloc() : super(PostSearchInitial()) {
    on<PostSearchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
