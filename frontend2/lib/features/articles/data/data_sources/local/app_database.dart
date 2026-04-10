import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';

part 'app_database.g.dart';

class SavedArticles extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text()();
  TextColumn get author => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get content => text()();
  TextColumn get thumbnailPath => text()();
  TextColumn get thumbnailURL => text()();
  TextColumn get category => text().nullable()();
  DateTimeColumn get publishedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isPublished => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [SavedArticles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'saved_articles_db');
  }

  Future<List<ArticleEntity>> getAllSavedArticles() async {
    final rows = await select(savedArticles).get();
    return rows.map(_rowToEntity).toList();
  }

  Future<void> insertArticle(ArticleEntity article) async {
    await into(savedArticles).insertOnConflictUpdate(
      SavedArticlesCompanion.insert(
        id: article.id,
        authorId: article.authorId,
        author: article.author,
        title: article.title,
        description: article.description,
        content: article.content,
        thumbnailPath: article.thumbnailPath,
        thumbnailURL: article.thumbnailURL,
        category: Value(article.category),
        publishedAt: article.publishedAt,
        updatedAt: article.updatedAt,
        isPublished: article.isPublished,
      ),
    );
  }

  Future<void> deleteArticle(String articleId) async {
    await (delete(savedArticles)..where((t) => t.id.equals(articleId))).go();
  }

  ArticleEntity _rowToEntity(SavedArticle row) {
    return ArticleEntity(
      id: row.id,
      authorId: row.authorId,
      author: row.author,
      title: row.title,
      description: row.description,
      content: row.content,
      thumbnailPath: row.thumbnailPath,
      thumbnailURL: row.thumbnailURL,
      category: row.category,
      publishedAt: row.publishedAt,
      updatedAt: row.updatedAt,
      isPublished: row.isPublished,
    );
  }
}
