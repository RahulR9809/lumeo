part of 'replay_cubit.dart';

sealed class ReplayState extends Equatable {
  const ReplayState();

  @override
  List<Object> get props => [];
}

final class ReplayInitial extends ReplayState {
    @override
  List<Object> get props => [];
}

final class ReplayLoading extends ReplayState {
    @override
  List<Object> get props => [];
}


final class ReplayLoaded extends ReplayState {
  final List<ReplayEntity> replays;

  const ReplayLoaded({required this.replays});
    @override
  List<Object> get props => [replays];
}


final class ReplayFailure extends ReplayState {
    @override
  List<Object> get props => [];
}
