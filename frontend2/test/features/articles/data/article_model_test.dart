import 'package:flutter_test/flutter_test.dart';
import 'package:newsly/features/articles/data/models/article_model.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';

void main() {
  final now = DateTime(2025, 4, 10);

  ArticleModel makeModel({
    bool isPremium = false,
    String? category,
    bool isPublished = true,
  }) {
    return ArticleModel(
      id: 'model1',
      authorId: 'user1',
      author: 'Jose Perez',
      title: 'Model Article',
      description: 'Description',
      content: 'Content',
      thumbnailPath: 'media/articles/model1/thumbnail.jpg',
      thumbnailURL: 'https://example.com/thumb.jpg',
      category: category,
      publishedAt: now,
      updatedAt: now,
      isPublished: isPublished,
      isPremium: isPremium,
    );
  }

  group('ArticleModel.fromEntity', () {
    test('creates model from entity preserving all fields', () {
      final entity = ArticleEntity(
        id: 'e1',
        authorId: 'user1',
        author: 'Jose Perez',
        title: 'Entity Article',
        description: 'Desc',
        content: 'Content',
        thumbnailPath: 'media/articles/e1/thumbnail.jpg',
        thumbnailURL: 'https://example.com/thumb.jpg',
        category: 'Health',
        publishedAt: now,
        updatedAt: now,
        isPublished: true,
        isPremium: true,
      );

      final model = ArticleModel.fromEntity(entity);

      expect(model.id, equals('e1'));
      expect(model.author, equals('Jose Perez'));
      expect(model.category, equals('Health'));
      expect(model.isPremium, isTrue);
      expect(model.isPublished, isTrue);
    });

    test('isPremium defaults to false when not set on entity', () {
      final entity = ArticleEntity(
        id: 'e2',
        authorId: 'user1',
        author: 'Jose',
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        thumbnailPath: '',
        thumbnailURL: '',
        publishedAt: now,
        updatedAt: now,
        isPublished: true,
      );

      final model = ArticleModel.fromEntity(entity);
      expect(model.isPremium, isFalse);
    });
  });

  group('ArticleModel.toFirestore', () {
    test('serializes all fields correctly', () {
      final model = makeModel(isPremium: true, category: 'Technology');
      final map = model.toFirestore();

      expect(map['id'], equals('model1'));
      expect(map['author'], equals('Jose Perez'));
      expect(map['isPremium'], isTrue);
      expect(map['category'], equals('Technology'));
      expect(map['isPublished'], isTrue);
      expect(map.containsKey('publishedAt'), isTrue);
      expect(map.containsKey('updatedAt'), isTrue);
    });

    test('isPremium false is serialized correctly', () {
      final model = makeModel(isPremium: false);
      expect(model.toFirestore()['isPremium'], isFalse);
    });

    test('null category is preserved in serialization', () {
      final model = makeModel(category: null);
      expect(model.toFirestore()['category'], isNull);
    });
  });

  group('ArticleModel.copyWith', () {
    test('copyWith changes only specified fields', () {
      final original = makeModel(isPremium: false, category: 'Sports');
      final updated = original.copyWith(isPremium: true, category: 'Business');

      expect(updated.isPremium, isTrue);
      expect(updated.category, equals('Business'));
      expect(updated.id, equals(original.id));
      expect(updated.author, equals(original.author));
    });

    test('copyWith without args returns equivalent model', () {
      final model = makeModel(isPremium: true, category: 'Science');
      final copy = model.copyWith();

      expect(copy.isPremium, equals(model.isPremium));
      expect(copy.category, equals(model.category));
      expect(copy.title, equals(model.title));
    });
  });
}
