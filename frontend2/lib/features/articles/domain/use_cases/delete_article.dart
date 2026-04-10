import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class DeleteArticleParams {
  final String articleId;
  final String thumbnailPath;

  const DeleteArticleParams({required this.articleId, required this.thumbnailPath});
}

class DeleteArticle implements UseCase<void, DeleteArticleParams> {
  final ArticleRepository _repository;

  DeleteArticle(this._repository);

  @override
  Future<void> call(DeleteArticleParams params) {
    return _repository.deleteArticle(params.articleId, params.thumbnailPath);
  }
}
