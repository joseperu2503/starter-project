import 'package:flutter_test/flutter_test.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';

void main() {
  final now = DateTime(2025, 4, 10);

  ArticleEntity makeArticle({
    String id = 'abc123',
    bool isPublished = true,
    bool isPremium = false,
    String? category,
  }) {
    return ArticleEntity(
      id: id,
      authorId: 'user1',
      author: 'Jose Perez',
      title: 'Test Article',
      description: 'A short description',
      content: 'Full content here',
      thumbnailPath: 'media/articles/abc123/thumbnail.jpg',
      thumbnailURL: 'https://example.com/thumb.jpg',
      category: category,
      publishedAt: now,
      updatedAt: now,
      isPublished: isPublished,
      isPremium: isPremium,
    );
  }

  group('ArticleEntity equality', () {
    test('two articles with same fields are equal', () {
      final a = makeArticle();
      final b = makeArticle();
      expect(a, equals(b));
    });

    test('articles with different ids are not equal', () {
      final a = makeArticle(id: 'abc123');
      final b = makeArticle(id: 'xyz999');
      expect(a, isNot(equals(b)));
    });

    test('articles with different isPremium are not equal', () {
      final a = makeArticle(isPremium: false);
      final b = makeArticle(isPremium: true);
      expect(a, isNot(equals(b)));
    });
  });

  group('ArticleEntity defaults', () {
    test('isPremium defaults to false', () {
      final article = makeArticle();
      expect(article.isPremium, isFalse);
    });

    test('category can be null', () {
      final article = makeArticle(category: null);
      expect(article.category, isNull);
    });

    test('category is preserved when set', () {
      final article = makeArticle(category: 'Technology');
      expect(article.category, equals('Technology'));
    });
  });

  group('ArticleEntity props', () {
    test('props list contains all fields', () {
      final article = makeArticle(isPremium: true, category: 'Sports');
      expect(article.props, contains('abc123'));
      expect(article.props, contains('Jose Perez'));
      expect(article.props, contains(true)); // isPremium
      expect(article.props, contains('Sports'));
    });
  });
}
