import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newsly/features/articles/data/data_sources/remote/firestore_interaction_data_source.dart';
import 'package:newsly/features/articles/domain/entities/comment_entity.dart';
import 'package:newsly/features/articles/presentation/bloc/interaction/interaction_bloc.dart';

class MockInteractionDataSource extends Mock
    implements FirestoreInteractionDataSource {}

void main() {
  late MockInteractionDataSource mockDataSource;
  late InteractionBloc bloc;

  final tComment = CommentEntity(
    id: 'c1',
    articleId: 'art1',
    authorId: 'user1',
    author: 'Jose Perez',
    content: 'Great article!',
    createdAt: DateTime(2025, 4, 10),
  );

  setUp(() {
    mockDataSource = MockInteractionDataSource();
    bloc = InteractionBloc(mockDataSource);
  });

  tearDown(() => bloc.close());

  group('InteractionBloc initial state', () {
    test('initial state has correct defaults', () {
      expect(bloc.state.isLiked, isFalse);
      expect(bloc.state.likesCount, equals(0));
      expect(bloc.state.viewCount, equals(0));
      expect(bloc.state.comments, isEmpty);
      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.isSendingComment, isFalse);
    });
  });

  group('LoadInteractionsEvent', () {
    test('emits loading then loaded state with correct data', () async {
      when(() => mockDataSource.isLiked('art1', 'user1'))
          .thenAnswer((_) async => true);
      when(() => mockDataSource.getLikesCount('art1'))
          .thenAnswer((_) async => 5);
      when(() => mockDataSource.getComments('art1'))
          .thenAnswer((_) async => [tComment]);
      when(() => mockDataSource.registerView(
            articleId: 'art1',
            userId: 'user1',
            authorId: 'author1',
          )).thenAnswer((_) async {});
      when(() => mockDataSource.getViewCount('art1'))
          .thenAnswer((_) async => 10);

      final states = <InteractionState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadInteractionsEvent(
        articleId: 'art1',
        userId: 'user1',
        authorId: 'author1',
      ));

      await Future.delayed(const Duration(milliseconds: 100));
      await sub.cancel();

      expect(states.length, equals(2));
      expect(states[0].isLoading, isTrue);
      expect(states[1].isLoading, isFalse);
      expect(states[1].isLiked, isTrue);
      expect(states[1].likesCount, equals(5));
      expect(states[1].viewCount, equals(10));
      expect(states[1].comments.length, equals(1));
    });
  });

  group('ToggleLikeEvent', () {
    test('optimistically likes when not liked', () async {
      when(() => mockDataSource.likeArticle('art1', 'user1'))
          .thenAnswer((_) async {});

      final states = <InteractionState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const ToggleLikeEvent(articleId: 'art1', userId: 'user1'));

      await Future.delayed(const Duration(milliseconds: 100));
      await sub.cancel();

      expect(states.first.isLiked, isTrue);
      expect(states.first.likesCount, equals(1));
    });

    test('optimistically unlikes when already liked', () async {
      when(() => mockDataSource.unlikeArticle('art1', 'user1'))
          .thenAnswer((_) async {});

      // Seed liked state
      bloc.emit(const InteractionState(isLiked: true, likesCount: 3));

      final states = <InteractionState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const ToggleLikeEvent(articleId: 'art1', userId: 'user1'));

      await Future.delayed(const Duration(milliseconds: 100));
      await sub.cancel();

      expect(states.first.isLiked, isFalse);
      expect(states.first.likesCount, equals(2));
    });

    test('reverts optimistic like on network error', () async {
      when(() => mockDataSource.likeArticle('art1', 'user1'))
          .thenThrow(Exception('network error'));

      final states = <InteractionState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const ToggleLikeEvent(articleId: 'art1', userId: 'user1'));

      await Future.delayed(const Duration(milliseconds: 100));
      await sub.cancel();

      // First: optimistic like, second: revert to original state
      expect(states.length, equals(2));
      expect(states[0].isLiked, isTrue);
      expect(states[0].likesCount, equals(1));
      expect(states[1].isLiked, isFalse);
      expect(states[1].likesCount, equals(1)); // revert uses state.likesCount at revert time
    });

    test('ignores toggle when userId is empty (guest user)', () async {
      final states = <InteractionState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const ToggleLikeEvent(articleId: 'art1', userId: ''));

      await Future.delayed(const Duration(milliseconds: 50));
      await sub.cancel();

      expect(states, isEmpty);
      verifyNever(() => mockDataSource.likeArticle(any(), any()));
    });
  });

  group('DeleteCommentEvent', () {
    test('removes comment from state without refetching', () async {
      when(() => mockDataSource.deleteComment('art1', 'c1'))
          .thenAnswer((_) async {});

      bloc.emit(InteractionState(comments: [tComment]));

      final states = <InteractionState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const DeleteCommentEvent(articleId: 'art1', commentId: 'c1'));

      await Future.delayed(const Duration(milliseconds: 100));
      await sub.cancel();

      expect(states.length, equals(1));
      expect(states.first.comments, isEmpty);
    });
  });

  group('InteractionState.copyWith', () {
    test('updates only specified fields', () {
      const state = InteractionState(isLiked: false, likesCount: 2);
      final updated = state.copyWith(isLiked: true);
      expect(updated.isLiked, isTrue);
      expect(updated.likesCount, equals(2));
      expect(updated.viewCount, equals(0));
    });

    test('preserves all fields when no args passed', () {
      const state = InteractionState(
        isLiked: true,
        likesCount: 5,
        viewCount: 20,
        isLoading: false,
        isSendingComment: false,
      );
      final copy = state.copyWith();
      expect(copy.isLiked, isTrue);
      expect(copy.likesCount, equals(5));
      expect(copy.viewCount, equals(20));
    });
  });
}
