import 'package:frontend2/features/articles/domain/entities/article_entity.dart';

abstract class RemoteArticleState {
  const RemoteArticleState();
}

class RemoteArticleInitial extends RemoteArticleState {
  const RemoteArticleInitial();
}

class RemoteArticleLoading extends RemoteArticleState {
  const RemoteArticleLoading();
}

class RemoteArticlesLoaded extends RemoteArticleState {
  final List<ArticleEntity> articles;
  const RemoteArticlesLoaded(this.articles);
}

class RemoteArticleActionSuccess extends RemoteArticleState {
  const RemoteArticleActionSuccess();
}

class RemoteArticleError extends RemoteArticleState {
  final String message;
  const RemoteArticleError(this.message);
}
