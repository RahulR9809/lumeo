part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {
    @override
  List<Object> get props => [];
}


final class CommentLoading extends CommentState {
    @override
  List<Object> get props => [];
}


final class CommentLoaded extends CommentState {
  final List<CommentEntity> comments;

  const CommentLoaded({required this.comments});
    @override
  List<Object> get props => [comments];
}


final class CommentFailure extends CommentState {
    @override
  List<Object> get props => [];
}
