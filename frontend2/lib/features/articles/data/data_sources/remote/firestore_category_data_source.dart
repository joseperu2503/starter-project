import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryItem {
  final String id;
  final String name;
  final int order;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.order,
  });
}

class FirestoreCategoryDataSource {
  final FirebaseFirestore _firestore;

  FirestoreCategoryDataSource(this._firestore);

  Future<List<CategoryItem>> getCategories() async {
    final snap = await _firestore
        .collection('categories')
        .orderBy('order')
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return CategoryItem(
        id: doc.id,
        name: data['name'] as String,
        order: (data['order'] as num).toInt(),
      );
    }).toList();
  }
}
