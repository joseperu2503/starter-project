import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/features/articles/data/data_sources/remote/firestore_interaction_data_source.dart';
import 'package:newsly/features/articles/domain/entities/comment_entity.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class InteractionEvent {
  const InteractionEvent();
}

class LoadInteractionsEvent extends InteractionEvent {
  final String articleId;
  final String userId;
  const LoadInteractionsEvent({required this.articleId, required this.userId});
}

class ToggleLikeEvent extends InteractionEvent {
  final String articleId;
  final String userId;
  const ToggleLikeEvent({required this.articleId, required this.userId});
}

class AddCommentEvent extends InteractionEvent {
  final String articleId;
  final String authorId;
  final String author;
  final String content;
  const AddCommentEvent({
    required this.articleId,
    required this.authorId,
    required this.author,
    required this.content,
  });
}

class DeleteCommentEvent extends InteractionEvent {
  final String articleId;
  final String commentId;
  const DeleteCommentEvent({required this.articleId, required this.commentId});
}

// ── States ────────────────────────────────────────────────────────────────────

class InteractionState {
  final bool isLiked;
  final int likesCount;
  final List<CommentEntity> comments;
  final bool isLoading;
  final bool isSendingComment;

  const InteractionState({
    this.isLiked = false,
    this.likesCount = 0,
    this.comments = const [],
    this.isLoading = false,
    this.isSendingComment = false,
  });

  InteractionState copyWith({
    bool? isLiked,
    int? likesCount,
    List<CommentEntity>? comments,
    bool? isLoading,
    bool? isSendingComment,
  }) {
    return InteractionState(
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isSendingComment: isSendingComment ?? this.isSendingComment,
    );
  }
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class InteractionBloc extends Bloc<InteractionEvent, InteractionState> {
  final FirestoreInteractionDataSource _dataSource;

  InteractionBloc(this._dataSource) : super(const InteractionState()) {
    on<LoadInteractionsEvent>(_onLoad);
    on<ToggleLikeEvent>(_onToggleLike);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
  }

  Future<void> _onLoad(
      LoadInteractionsEvent event, Emitter<InteractionState> emit) async {
    emit(state.copyWith(isLoading: true));
    final results = await Future.wait([
      _dataSource.isLiked(event.articleId, event.userId),
      _dataSource.getLikesCount(event.articleId),
      _dataSource.getComments(event.articleId),
    ]);
    emit(state.copyWith(
      isLiked: results[0] as bool,
      likesCount: results[1] as int,
      comments: results[2] as List<CommentEntity>,
      isLoading: false,
    ));
  }

  Future<void> _onToggleLike(
      ToggleLikeEvent event, Emitter<InteractionState> emit) async {
    if (event.userId.isEmpty) return;
    final wasLiked = state.isLiked;
    // Optimistic update
    emit(state.copyWith(
      isLiked: !wasLiked,
      likesCount: wasLiked ? state.likesCount - 1 : state.likesCount + 1,
    ));
    try {
      if (wasLiked) {
        await _dataSource.unlikeArticle(event.articleId, event.userId);
      } else {
        await _dataSource.likeArticle(event.articleId, event.userId);
      }
    } catch (_) {
      // Revert on error
      emit(state.copyWith(isLiked: wasLiked, likesCount: state.likesCount));
    }
  }

  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<InteractionState> emit) async {
    emit(state.copyWith(isSendingComment: true));
    try {
      await _dataSource.addComment(
        articleId: event.articleId,
        authorId: event.authorId,
        author: event.author,
        content: event.content,
      );
      final comments = await _dataSource.getComments(event.articleId);
      emit(state.copyWith(comments: comments, isSendingComment: false));
    } catch (_) {
      emit(state.copyWith(isSendingComment: false));
    }
  }

  Future<void> _onDeleteComment(
      DeleteCommentEvent event, Emitter<InteractionState> emit) async {
    await _dataSource.deleteComment(event.articleId, event.commentId);
    final updated =
        state.comments.where((c) => c.id != event.commentId).toList();
    emit(state.copyWith(comments: updated));
  }
}
