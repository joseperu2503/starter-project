import 'dart:io';

import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class UploadArticleParams {
  final ArticleEntity article;
  final File thumbnail;

  const UploadArticleParams({required this.article, required this.thumbnail});
}

class UploadArticle implements UseCase<void, UploadArticleParams> {
  final ArticleRepository _repository;

  UploadArticle(this._repository);

  @override
  Future<void> call(UploadArticleParams params) {
    return _repository.uploadArticle(params.article, params.thumbnail);
  }
}
