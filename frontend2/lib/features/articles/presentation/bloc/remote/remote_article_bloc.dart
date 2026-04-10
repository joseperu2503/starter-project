import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/use_cases/delete_article.dart';
import 'package:newsly/features/articles/domain/use_cases/get_my_articles.dart';
import 'package:newsly/features/articles/domain/use_cases/get_published_articles.dart';
import 'package:newsly/features/articles/domain/use_cases/update_article.dart';
import 'package:newsly/features/articles/domain/use_cases/upload_article.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_state.dart';

class RemoteArticleBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetPublishedArticles _getPublishedArticles;
  final GetMyArticles _getMyArticles;
  final UploadArticle _uploadArticle;
  final UpdateArticle _updateArticle;
  final DeleteArticle _deleteArticle;

  RemoteArticleBloc({
    required GetPublishedArticles getPublishedArticles,
    required GetMyArticles getMyArticles,
    required UploadArticle uploadArticle,
    required UpdateArticle updateArticle,
    required DeleteArticle deleteArticle,
  })  : _getPublishedArticles = getPublishedArticles,
        _getMyArticles = getMyArticles,
        _uploadArticle = uploadArticle,
        _updateArticle = updateArticle,
        _deleteArticle = deleteArticle,
        super(const RemoteArticleInitial()) {
    on<GetPublishedArticlesEvent>(_onGetPublishedArticles);
    on<GetMyArticlesEvent>(_onGetMyArticles);
    on<UploadArticleEvent>(_onUploadArticle);
    on<UpdateArticleEvent>(_onUpdateArticle);
    on<DeleteArticleEvent>(_onDeleteArticle);
  }

  Future<void> _onGetPublishedArticles(
    GetPublishedArticlesEvent event,
    Emitter<RemoteArticleState> emit,
  ) async {
    emit(const RemoteArticleLoading());
    try {
      final articles = await _getPublishedArticles(NoParams());
      emit(RemoteArticlesLoaded(articles));
    } catch (e) {
      emit(RemoteArticleError(e.toString()));
    }
  }

  Future<void> _onGetMyArticles(
    GetMyArticlesEvent event,
    Emitter<RemoteArticleState> emit,
  ) async {
    emit(const RemoteArticleLoading());
    try {
      final articles = await _getMyArticles(event.authorId);
      emit(RemoteArticlesLoaded(articles));
    } catch (e) {
      emit(RemoteArticleError(e.toString()));
    }
  }

  Future<void> _onUploadArticle(
    UploadArticleEvent event,
    Emitter<RemoteArticleState> emit,
  ) async {
    emit(const RemoteArticleLoading());
    try {
      await _uploadArticle(
        UploadArticleParams(article: event.article, thumbnail: event.thumbnail),
      );
      emit(const RemoteArticleActionSuccess());
    } catch (e) {
      emit(RemoteArticleError(e.toString()));
    }
  }

  Future<void> _onUpdateArticle(
    UpdateArticleEvent event,
    Emitter<RemoteArticleState> emit,
  ) async {
    emit(const RemoteArticleLoading());
    try {
      await _updateArticle(
        UpdateArticleParams(article: event.article, newThumbnail: event.newThumbnail),
      );
      emit(const RemoteArticleActionSuccess());
    } catch (e) {
      emit(RemoteArticleError(e.toString()));
    }
  }

  Future<void> _onDeleteArticle(
    DeleteArticleEvent event,
    Emitter<RemoteArticleState> emit,
  ) async {
    emit(const RemoteArticleLoading());
    try {
      await _deleteArticle(
        DeleteArticleParams(articleId: event.articleId, thumbnailPath: event.thumbnailPath),
      );
      emit(const RemoteArticleActionSuccess());
    } catch (e) {
      emit(RemoteArticleError(e.toString()));
    }
  }
}
