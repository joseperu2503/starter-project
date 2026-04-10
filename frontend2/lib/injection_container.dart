import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend2/features/articles/data/data_sources/local/app_database.dart';
import 'package:frontend2/features/articles/data/data_sources/remote/firestore_article_data_source.dart';
import 'package:frontend2/features/articles/data/repository/article_repository_impl.dart';
import 'package:frontend2/features/articles/domain/repository/article_repository.dart';
import 'package:frontend2/features/articles/domain/use_cases/delete_article.dart';
import 'package:frontend2/features/articles/domain/use_cases/get_my_articles.dart';
import 'package:frontend2/features/articles/domain/use_cases/get_published_articles.dart';
import 'package:frontend2/features/articles/domain/use_cases/get_saved_articles.dart';
import 'package:frontend2/features/articles/domain/use_cases/remove_saved_article.dart';
import 'package:frontend2/features/articles/domain/use_cases/save_article.dart';
import 'package:frontend2/features/articles/domain/use_cases/update_article.dart';
import 'package:frontend2/features/articles/domain/use_cases/upload_article.dart';
import 'package:frontend2/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:frontend2/features/articles/presentation/bloc/remote/remote_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => AppDatabase());

  // ── Data Sources ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => FirestoreArticleDataSource(sl(), sl()),
  );

  // ── Repository ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(sl(), sl()),
  );

  // ── Use Cases ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetPublishedArticles(sl()));
  sl.registerLazySingleton(() => GetMyArticles(sl()));
  sl.registerLazySingleton(() => UploadArticle(sl()));
  sl.registerLazySingleton(() => UpdateArticle(sl()));
  sl.registerLazySingleton(() => DeleteArticle(sl()));
  sl.registerLazySingleton(() => GetSavedArticles(sl()));
  sl.registerLazySingleton(() => SaveArticle(sl()));
  sl.registerLazySingleton(() => RemoveSavedArticle(sl()));

  // ── BLoCs ───────────────────────────────────────────────────────────────────
  sl.registerFactory(
    () => RemoteArticleBloc(
      getPublishedArticles: sl(),
      getMyArticles: sl(),
      uploadArticle: sl(),
      updateArticle: sl(),
      deleteArticle: sl(),
    ),
  );

  sl.registerFactory(
    () => LocalArticleBloc(
      getSavedArticles: sl(),
      saveArticle: sl(),
      removeSavedArticle: sl(),
    ),
  );
}
