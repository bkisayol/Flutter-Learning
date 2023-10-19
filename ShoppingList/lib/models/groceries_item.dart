import 'package:cloud_firestore/cloud_firestore.dart';

class GroceriesItem {
  const GroceriesItem({required this.listName, required this.createdAt, required this.userId});
  final Timestamp createdAt;
  final String userId;
  final String listName;
}
