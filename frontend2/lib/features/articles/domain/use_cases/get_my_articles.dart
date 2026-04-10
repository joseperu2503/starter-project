import 'package:frontend2/core/usecase/usecase.dart';
import 'package:frontend2/features/articles/domain/entities/article_entity.dart';
import 'package:frontend2/features/articles/domain/repository/article_repository.dart';

class GetMyArticles implements UseCase<List<ArticleEntity>, String> {
  final ArticleRepository _repository;

  GetMyArticles(this._repository);

  @override
  Future<List<ArticleEntity>> call(String authorId) {
    return _repository.getMyArticles(authorId);
  }
}
