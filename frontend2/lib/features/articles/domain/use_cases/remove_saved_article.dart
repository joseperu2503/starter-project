import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class RemoveSavedArticle implements UseCase<void, String> {
  final ArticleRepository _repository;

  RemoveSavedArticle(this._repository);

  @override
  Future<void> call(String articleId) {
    return _repository.removeSavedArticle(articleId);
  }
}
