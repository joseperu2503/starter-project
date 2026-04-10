import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/use_cases/get_saved_articles.dart';
import 'package:newsly/features/articles/domain/use_cases/remove_saved_article.dart';
import 'package:newsly/features/articles/domain/use_cases/save_article.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_event.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_state.dart';

class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticleState> {
  final GetSavedArticles _getSavedArticles;
  final SaveArticle _saveArticle;
  final RemoveSavedArticle _removeSavedArticle;

  LocalArticleBloc({
    required GetSavedArticles getSavedArticles,
    required SaveArticle saveArticle,
    required RemoveSavedArticle removeSavedArticle,
  })  : _getSavedArticles = getSavedArticles,
        _saveArticle = saveArticle,
        _removeSavedArticle = removeSavedArticle,
        super(const LocalArticleInitial()) {
    on<GetSavedArticlesEvent>(_onGetSavedArticles);
    on<SaveArticleEvent>(_onSaveArticle);
    on<RemoveSavedArticleEvent>(_onRemoveSavedArticle);
  }

  Future<void> _onGetSavedArticles(
    GetSavedArticlesEvent event,
    Emitter<LocalArticleState> emit,
  ) async {
    emit(const LocalArticleLoading());
    try {
      final articles = await _getSavedArticles(NoParams());
      emit(LocalArticlesLoaded(articles));
    } catch (e) {
      emit(LocalArticleError(e.toString()));
    }
  }

  Future<void> _onSaveArticle(
    SaveArticleEvent event,
    Emitter<LocalArticleState> emit,
  ) async {
    try {
      await _saveArticle(event.article);
      final articles = await _getSavedArticles(NoParams());
      emit(LocalArticlesLoaded(articles));
    } catch (e) {
      emit(LocalArticleError(e.toString()));
    }
  }

  Future<void> _onRemoveSavedArticle(
    RemoveSavedArticleEvent event,
    Emitter<LocalArticleState> emit,
  ) async {
    try {
      await _removeSavedArticle(event.articleId);
      final articles = await _getSavedArticles(NoParams());
      emit(LocalArticlesLoaded(articles));
    } catch (e) {
      emit(LocalArticleError(e.toString()));
    }
  }
}
