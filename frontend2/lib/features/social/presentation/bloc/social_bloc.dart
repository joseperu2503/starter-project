import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/features/social/data/social_remote_data_source.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class SocialEvent {
  const SocialEvent();
}

class CheckFollowEvent extends SocialEvent {
  final String followerId;
  final String followingId;
  const CheckFollowEvent({required this.followerId, required this.followingId});
}

class ToggleFollowEvent extends SocialEvent {
  final String followerId;
  final String followingId;
  const ToggleFollowEvent({required this.followerId, required this.followingId});
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class SocialState {
  const SocialState();
}

class SocialInitial extends SocialState {
  const SocialInitial();
}

class SocialLoading extends SocialState {
  const SocialLoading();
}

class FollowState extends SocialState {
  final bool isFollowing;
  final int followerCount;
  const FollowState({required this.isFollowing, required this.followerCount});
}

class SocialError extends SocialState {
  final String message;
  const SocialError(this.message);
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRemoteDataSource _dataSource;

  SocialBloc(this._dataSource) : super(const SocialInitial()) {
    on<CheckFollowEvent>(_onCheck);
    on<ToggleFollowEvent>(_onToggle);
  }

  Future<void> _onCheck(CheckFollowEvent event, Emitter<SocialState> emit) async {
    emit(const SocialLoading());
    try {
      final isFollowing = await _dataSource.isFollowing(event.followerId, event.followingId);
      final count = await _dataSource.getFollowerCount(event.followingId);
      emit(FollowState(isFollowing: isFollowing, followerCount: count));
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onToggle(ToggleFollowEvent event, Emitter<SocialState> emit) async {
    final current = state;
    if (current is! FollowState) return;

    final wasFollowing = current.isFollowing;
    // Optimistic update
    emit(FollowState(
      isFollowing: !wasFollowing,
      followerCount: wasFollowing ? current.followerCount - 1 : current.followerCount + 1,
    ));

    try {
      if (wasFollowing) {
        await _dataSource.unfollowUser(event.followerId, event.followingId);
      } else {
        await _dataSource.followUser(event.followerId, event.followingId);
      }
    } catch (e) {
      // Revert on error
      emit(FollowState(isFollowing: wasFollowing, followerCount: current.followerCount));
    }
  }
}
