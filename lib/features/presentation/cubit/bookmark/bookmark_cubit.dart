import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/usecases/savedposts/read_savedpost_usecase.dart';

class BookmarkCubit extends Cubit<Set<String>> {
  final ReadSavedpostUsecase readSavedpostUsecase;

  BookmarkCubit({required this.readSavedpostUsecase}) : super({});

  Future<void> loadBookmarks(String userId) async {
    final savedStream = readSavedpostUsecase.call(userId);
    await for (final saved in savedStream) {
      final postIds = saved.map((e) => e.postId).toSet();
      emit(postIds);
      break; // Exit after first snapshot
    }
  }

  void toggleBookmark(String postId) {
    final current = Set<String>.from(state);
    if (current.contains(postId)) {
      current.remove(postId);
    } else {
      current.add(postId);
    }
    emit(current);
  }

  bool isBookmarked(String postId) => state.contains(postId);
}
