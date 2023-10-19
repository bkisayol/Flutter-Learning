// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:shoppinglist/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
}
