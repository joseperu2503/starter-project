import 'package:frontend2/features/articles/domain/entities/article_entity.dart';

abstract class LocalArticleEvent {
  const LocalArticleEvent();
}

class GetSavedArticlesEvent extends LocalArticleEvent {
  const GetSavedArticlesEvent();
}

class SaveArticleEvent extends LocalArticleEvent {
  final ArticleEntity article;
  const SaveArticleEvent(this.article);
}

class RemoveSavedArticleEvent extends LocalArticleEvent {
  final String articleId;
  const RemoveSavedArticleEvent(this.articleId);
}
