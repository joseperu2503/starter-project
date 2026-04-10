import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:newsly/features/articles/data/data_sources/local/app_database.dart';
import 'package:newsly/features/articles/data/data_sources/remote/firestore_article_data_source.dart';
import 'package:newsly/features/articles/data/repository/article_repository_impl.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';
import 'package:newsly/features/articles/domain/use_cases/delete_article.dart';
import 'package:newsly/features/articles/domain/use_cases/get_my_articles.dart';
import 'package:newsly/features/articles/domain/use_cases/get_published_articles.dart';
import 'package:newsly/features/articles/domain/use_cases/get_saved_articles.dart';
import 'package:newsly/features/articles/domain/use_cases/remove_saved_article.dart';
import 'package:newsly/features/articles/domain/use_cases/save_article.dart';
import 'package:newsly/features/articles/domain/use_cases/update_article.dart';
import 'package:newsly/features/articles/domain/use_cases/upload_article.dart';
import 'package:newsly/features/articles/presentation/bloc/local/local_article_bloc.dart';
import 'package:newsly/features/articles/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:newsly/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:newsly/features/auth/data/repository/auth_repository_impl.dart';
import 'package:newsly/features/auth/domain/repository/auth_repository.dart';
import 'package:newsly/features/auth/domain/use_cases/register.dart';
import 'package:newsly/features/auth/domain/use_cases/sign_in.dart';
import 'package:newsly/features/auth/domain/use_cases/sign_out.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => FirebaseFirestore.instanceFor(
      app: FirebaseFirestore.instance.app,
      databaseId: 'newsly',
    ),
  );
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => AppDatabase());

  // ── Auth ────────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => FirebaseAuthDataSource(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      register: sl(),
      signOut: sl(),
      authRepository: sl(),
    ),
  );

  // ── Articles Data Sources ───────────────────────────────────────────────────
  sl.registerLazySingleton(() => FirestoreArticleDataSource(sl(), sl()));

  // ── Articles Repository ─────────────────────────────────────────────────────
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(sl(), sl()),
  );

  // ── Articles Use Cases ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetPublishedArticles(sl()));
  sl.registerLazySingleton(() => GetMyArticles(sl()));
  sl.registerLazySingleton(() => UploadArticle(sl()));
  sl.registerLazySingleton(() => UpdateArticle(sl()));
  sl.registerLazySingleton(() => DeleteArticle(sl()));
  sl.registerLazySingleton(() => GetSavedArticles(sl()));
  sl.registerLazySingleton(() => SaveArticle(sl()));
  sl.registerLazySingleton(() => RemoveSavedArticle(sl()));

  // ── Articles BLoCs ──────────────────────────────────────────────────────────
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
