import 'package:frontend2/features/articles/domain/entities/article_entity.dart';

abstract class LocalArticleState {
  const LocalArticleState();
}

class LocalArticleInitial extends LocalArticleState {
  const LocalArticleInitial();
}

class LocalArticleLoading extends LocalArticleState {
  const LocalArticleLoading();
}

class LocalArticlesLoaded extends LocalArticleState {
  final List<ArticleEntity> articles;
  const LocalArticlesLoaded(this.articles);
}

class LocalArticleError extends LocalArticleState {
  final String message;
  const LocalArticleError(this.message);
}
