// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SavedArticlesTable extends SavedArticles
    with TableInfo<$SavedArticlesTable, SavedArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailURLMeta = const VerificationMeta(
    'thumbnailURL',
  );
  @override
  late final GeneratedColumn<String> thumbnailURL = GeneratedColumn<String>(
    'thumbnail_u_r_l',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorId,
    author,
    title,
    description,
    content,
    thumbnailPath,
    thumbnailURL,
    category,
    publishedAt,
    updatedAt,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedArticle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (data.containsKey('thumbnail_u_r_l')) {
      context.handle(
        _thumbnailURLMeta,
        thumbnailURL.isAcceptableOrUnknown(
          data['thumbnail_u_r_l']!,
          _thumbnailURLMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbnailURLMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isPublishedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedArticle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      )!,
      thumbnailURL: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_u_r_l'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $SavedArticlesTable createAlias(String alias) {
    return $SavedArticlesTable(attachedDatabase, alias);
  }
}

class SavedArticle extends DataClass implements Insertable<SavedArticle> {
  final String id;
  final String authorId;
  final String author;
  final String title;
  final String description;
  final String content;
  final String thumbnailPath;
  final String thumbnailURL;
  final String? category;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final bool isPublished;
  const SavedArticle({
    required this.id,
    required this.authorId,
    required this.author,
    required this.title,
    required this.description,
    required this.content,
    required this.thumbnailPath,
    required this.thumbnailURL,
    this.category,
    required this.publishedAt,
    required this.updatedAt,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['author_id'] = Variable<String>(authorId);
    map['author'] = Variable<String>(author);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['content'] = Variable<String>(content);
    map['thumbnail_path'] = Variable<String>(thumbnailPath);
    map['thumbnail_u_r_l'] = Variable<String>(thumbnailURL);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['published_at'] = Variable<DateTime>(publishedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  SavedArticlesCompanion toCompanion(bool nullToAbsent) {
    return SavedArticlesCompanion(
      id: Value(id),
      authorId: Value(authorId),
      author: Value(author),
      title: Value(title),
      description: Value(description),
      content: Value(content),
      thumbnailPath: Value(thumbnailPath),
      thumbnailURL: Value(thumbnailURL),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      publishedAt: Value(publishedAt),
      updatedAt: Value(updatedAt),
      isPublished: Value(isPublished),
    );
  }

  factory SavedArticle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedArticle(
      id: serializer.fromJson<String>(json['id']),
      authorId: serializer.fromJson<String>(json['authorId']),
      author: serializer.fromJson<String>(json['author']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      content: serializer.fromJson<String>(json['content']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      thumbnailURL: serializer.fromJson<String>(json['thumbnailURL']),
      category: serializer.fromJson<String?>(json['category']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authorId': serializer.toJson<String>(authorId),
      'author': serializer.toJson<String>(author),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'content': serializer.toJson<String>(content),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'thumbnailURL': serializer.toJson<String>(thumbnailURL),
      'category': serializer.toJson<String?>(category),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  SavedArticle copyWith({
    String? id,
    String? authorId,
    String? author,
    String? title,
    String? description,
    String? content,
    String? thumbnailPath,
    String? thumbnailURL,
    Value<String?> category = const Value.absent(),
    DateTime? publishedAt,
    DateTime? updatedAt,
    bool? isPublished,
  }) => SavedArticle(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    author: author ?? this.author,
    title: title ?? this.title,
    description: description ?? this.description,
    content: content ?? this.content,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    thumbnailURL: thumbnailURL ?? this.thumbnailURL,
    category: category.present ? category.value : this.category,
    publishedAt: publishedAt ?? this.publishedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPublished: isPublished ?? this.isPublished,
  );
  SavedArticle copyWithCompanion(SavedArticlesCompanion data) {
    return SavedArticle(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      author: data.author.present ? data.author.value : this.author,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      content: data.content.present ? data.content.value : this.content,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      thumbnailURL: data.thumbnailURL.present
          ? data.thumbnailURL.value
          : this.thumbnailURL,
      category: data.category.present ? data.category.value : this.category,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedArticle(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('author: $author, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('thumbnailURL: $thumbnailURL, ')
          ..write('category: $category, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    authorId,
    author,
    title,
    description,
    content,
    thumbnailPath,
    thumbnailURL,
    category,
    publishedAt,
    updatedAt,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedArticle &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.author == this.author &&
          other.title == this.title &&
          other.description == this.description &&
          other.content == this.content &&
          other.thumbnailPath == this.thumbnailPath &&
          other.thumbnailURL == this.thumbnailURL &&
          other.category == this.category &&
          other.publishedAt == this.publishedAt &&
          other.updatedAt == this.updatedAt &&
          other.isPublished == this.isPublished);
}

class SavedArticlesCompanion extends UpdateCompanion<SavedArticle> {
  final Value<String> id;
  final Value<String> authorId;
  final Value<String> author;
  final Value<String> title;
  final Value<String> description;
  final Value<String> content;
  final Value<String> thumbnailPath;
  final Value<String> thumbnailURL;
  final Value<String?> category;
  final Value<DateTime> publishedAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isPublished;
  final Value<int> rowid;
  const SavedArticlesCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.author = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.thumbnailURL = const Value.absent(),
    this.category = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedArticlesCompanion.insert({
    required String id,
    required String authorId,
    required String author,
    required String title,
    required String description,
    required String content,
    required String thumbnailPath,
    required String thumbnailURL,
    this.category = const Value.absent(),
    required DateTime publishedAt,
    required DateTime updatedAt,
    required bool isPublished,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       authorId = Value(authorId),
       author = Value(author),
       title = Value(title),
       description = Value(description),
       content = Value(content),
       thumbnailPath = Value(thumbnailPath),
       thumbnailURL = Value(thumbnailURL),
       publishedAt = Value(publishedAt),
       updatedAt = Value(updatedAt),
       isPublished = Value(isPublished);
  static Insertable<SavedArticle> custom({
    Expression<String>? id,
    Expression<String>? authorId,
    Expression<String>? author,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? content,
    Expression<String>? thumbnailPath,
    Expression<String>? thumbnailURL,
    Expression<String>? category,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isPublished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (author != null) 'author': author,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (content != null) 'content': content,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (thumbnailURL != null) 'thumbnail_u_r_l': thumbnailURL,
      if (category != null) 'category': category,
      if (publishedAt != null) 'published_at': publishedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isPublished != null) 'is_published': isPublished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedArticlesCompanion copyWith({
    Value<String>? id,
    Value<String>? authorId,
    Value<String>? author,
    Value<String>? title,
    Value<String>? description,
    Value<String>? content,
    Value<String>? thumbnailPath,
    Value<String>? thumbnailURL,
    Value<String?>? category,
    Value<DateTime>? publishedAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isPublished,
    Value<int>? rowid,
  }) {
    return SavedArticlesCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      category: category ?? this.category,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (thumbnailURL.present) {
      map['thumbnail_u_r_l'] = Variable<String>(thumbnailURL.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedArticlesCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('author: $author, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('thumbnailURL: $thumbnailURL, ')
          ..write('category: $category, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPublished: $isPublished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedArticlesTable savedArticles = $SavedArticlesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedArticles];
}

typedef $$SavedArticlesTableCreateCompanionBuilder =
    SavedArticlesCompanion Function({
      required String id,
      required String authorId,
      required String author,
      required String title,
      required String description,
      required String content,
      required String thumbnailPath,
      required String thumbnailURL,
      Value<String?> category,
      required DateTime publishedAt,
      required DateTime updatedAt,
      required bool isPublished,
      Value<int> rowid,
    });
typedef $$SavedArticlesTableUpdateCompanionBuilder =
    SavedArticlesCompanion Function({
      Value<String> id,
      Value<String> authorId,
      Value<String> author,
      Value<String> title,
      Value<String> description,
      Value<String> content,
      Value<String> thumbnailPath,
      Value<String> thumbnailURL,
      Value<String?> category,
      Value<DateTime> publishedAt,
      Value<DateTime> updatedAt,
      Value<bool> isPublished,
      Value<int> rowid,
    });

class $$SavedArticlesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedArticlesTable> {
  $$SavedArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailURL => $composableBuilder(
    column: $table.thumbnailURL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedArticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedArticlesTable> {
  $$SavedArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailURL => $composableBuilder(
    column: $table.thumbnailURL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedArticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedArticlesTable> {
  $$SavedArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailURL => $composableBuilder(
    column: $table.thumbnailURL,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );
}

class $$SavedArticlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedArticlesTable,
          SavedArticle,
          $$SavedArticlesTableFilterComposer,
          $$SavedArticlesTableOrderingComposer,
          $$SavedArticlesTableAnnotationComposer,
          $$SavedArticlesTableCreateCompanionBuilder,
          $$SavedArticlesTableUpdateCompanionBuilder,
          (
            SavedArticle,
            BaseReferences<_$AppDatabase, $SavedArticlesTable, SavedArticle>,
          ),
          SavedArticle,
          PrefetchHooks Function()
        > {
  $$SavedArticlesTableTableManager(_$AppDatabase db, $SavedArticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> thumbnailPath = const Value.absent(),
                Value<String> thumbnailURL = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedArticlesCompanion(
                id: id,
                authorId: authorId,
                author: author,
                title: title,
                description: description,
                content: content,
                thumbnailPath: thumbnailPath,
                thumbnailURL: thumbnailURL,
                category: category,
                publishedAt: publishedAt,
                updatedAt: updatedAt,
                isPublished: isPublished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String authorId,
                required String author,
                required String title,
                required String description,
                required String content,
                required String thumbnailPath,
                required String thumbnailURL,
                Value<String?> category = const Value.absent(),
                required DateTime publishedAt,
                required DateTime updatedAt,
                required bool isPublished,
                Value<int> rowid = const Value.absent(),
              }) => SavedArticlesCompanion.insert(
                id: id,
                authorId: authorId,
                author: author,
                title: title,
                description: description,
                content: content,
                thumbnailPath: thumbnailPath,
                thumbnailURL: thumbnailURL,
                category: category,
                publishedAt: publishedAt,
                updatedAt: updatedAt,
                isPublished: isPublished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedArticlesTable,
      SavedArticle,
      $$SavedArticlesTableFilterComposer,
      $$SavedArticlesTableOrderingComposer,
      $$SavedArticlesTableAnnotationComposer,
      $$SavedArticlesTableCreateCompanionBuilder,
      $$SavedArticlesTableUpdateCompanionBuilder,
      (
        SavedArticle,
        BaseReferences<_$AppDatabase, $SavedArticlesTable, SavedArticle>,
      ),
      SavedArticle,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedArticlesTableTableManager get savedArticles =>
      $$SavedArticlesTableTableManager(_db, _db.savedArticles);
}
