import 'package:flutter/material.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/presentation/screens/article_detail_screen.dart';
import 'package:newsly/features/articles/presentation/screens/home_screen.dart';
import 'package:newsly/features/articles/presentation/screens/my_articles_screen.dart';
import 'package:newsly/features/articles/presentation/screens/my_firestore_articles_screen.dart';
import 'package:newsly/features/articles/presentation/screens/upload_article_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String articleDetail = '/article-detail';
  static const String myArticles = '/my-articles';
  static const String myFirestoreArticles = '/my-firestore-articles';
  static const String uploadArticle = '/upload-article';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case articleDetail:
        final article = settings.arguments as ArticleEntity;
        return MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        );
      case myArticles:
        return MaterialPageRoute(builder: (_) => const MyArticlesScreen());
      case myFirestoreArticles:
        return MaterialPageRoute(
            builder: (_) => const MyFirestoreArticlesScreen());
      case uploadArticle:
        final article = settings.arguments as ArticleEntity?;
        return MaterialPageRoute(
          builder: (_) => UploadArticleScreen(article: article),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
