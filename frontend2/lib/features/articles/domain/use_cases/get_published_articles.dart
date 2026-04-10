import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class GetPublishedArticles implements UseCase<List<ArticleEntity>, NoParams> {
  final ArticleRepository _repository;

  GetPublishedArticles(this._repository);

  @override
  Future<List<ArticleEntity>> call(NoParams params) {
    return _repository.getPublishedArticles();
  }
}
