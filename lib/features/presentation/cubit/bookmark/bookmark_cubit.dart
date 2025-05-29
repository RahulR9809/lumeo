import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/usecases/savedposts/read_savedpost_usecase.dart';

// class BookmarkCubit extends Cubit<Set<String>> {
//   BookmarkCubit() : super({});

//   void toggleBookmark(String postId) {
//     if (state.contains(postId)) {
//       emit({...state}..remove(postId));
//     } else {
//       emit({...state}..add(postId));
//     }
//   }

//    bool isBookmarked(String postId) => state.contains(postId);
// }


// class BookmarkCubit extends Cubit<Set<String>> {
//   final ReadSavedpostUsecase readSavedpostUsecase;

//   BookmarkCubit({required this.readSavedpostUsecase}) : super({});

//   /// Load saved bookmarks from Firestore when the user logs in
//   Future<void> loadBookmarks(String userId) async {
//     final savedPostStream = readSavedpostUsecase.call(userId);
//     final savedPosts = await savedPostStream.first;
//     final bookmarkedIds = savedPosts.map((e) => e.postId).toSet();
//     emit(bookmarkedIds);
//   }

//   /// Toggle bookmark locally (UI) — you'll also need to call Firestore update
//   void toggleBookmark(String postId) {
//     final updatedBookmarks = Set<String>.from(state);
//     if (updatedBookmarks.contains(postId)) {
//       updatedBookmarks.remove(postId);
//     } else {
//       updatedBookmarks.add(postId);
//     }
//     emit(updatedBookmarks);
//   }

//   bool isBookmarked(String postId) => state.contains(postId);
// }


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
