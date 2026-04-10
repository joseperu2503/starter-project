import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class SaveArticle implements UseCase<void, ArticleEntity> {
  final ArticleRepository _repository;

  SaveArticle(this._repository);

  @override
  Future<void> call(ArticleEntity article) {
    return _repository.saveArticle(article);
  }
}
