import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';

abstract class SavedpostState extends Equatable{}


class SavedPostInitial extends SavedpostState {
  @override
  List<Object?> get props => [];
}

class  SavedPostLoading extends SavedpostState {
  @override
  List<Object?> get props => [];
}

class  SavedPostLoaded extends SavedpostState {
  final List<PostEntity> posts;

   SavedPostLoaded({required this.posts});
  @override
  List<Object?> get props => [posts];
}

class  SavedPostFailure extends SavedpostState {
  @override
  List<Object?> get props => [];
}
