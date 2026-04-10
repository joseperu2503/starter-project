import 'dart:io';

import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class UpdateArticleParams {
  final ArticleEntity article;
  final File? newThumbnail;

  const UpdateArticleParams({required this.article, this.newThumbnail});
}

class UpdateArticle implements UseCase<void, UpdateArticleParams> {
  final ArticleRepository _repository;

  UpdateArticle(this._repository);

  @override
  Future<void> call(UpdateArticleParams params) {
    return _repository.updateArticle(params.article, newThumbnail: params.newThumbnail);
  }
}
