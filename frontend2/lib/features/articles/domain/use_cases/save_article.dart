import 'package:frontend2/core/usecase/usecase.dart';
import 'package:frontend2/features/articles/domain/entities/article_entity.dart';
import 'package:frontend2/features/articles/domain/repository/article_repository.dart';

class SaveArticle implements UseCase<void, ArticleEntity> {
  final ArticleRepository _repository;

  SaveArticle(this._repository);

  @override
  Future<void> call(ArticleEntity article) {
    return _repository.saveArticle(article);
  }
}
