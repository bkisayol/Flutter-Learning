import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Stream<List<DocumentSnapshot>> getDocumentByUserId(String userId, String collectionPath) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .where('userId', arrayContains: userId)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs);
  }

  Stream<List<DocumentSnapshot>> getDocuments(String collectionPath) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs);
  }

  Stream<List<DocumentSnapshot>> getSubCollectionDocuments(
      String collectionPath, String subCollectionPath, String documentId) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(documentId)
        .collection(subCollectionPath)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs);
  }

  void removeList(String documentId, String collectionPath) {
    FirebaseFirestore.instance.collection(collectionPath).doc(documentId).delete();
  }

  void removeSubList(String collectionPath, String documentId, String subCollectionPath, String subDocumentId) {
    FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(documentId)
        .collection(subCollectionPath)
        .doc(subDocumentId)
        .delete();
  }

  void addList(String name, String listPriority, String collectionPath, String userIds, String selectedPriority) {
    FirebaseFirestore.instance.collection(collectionPath).add({
      'name': name,
      'userId': userIds,
      'priority': selectedPriority,
      'createdAt': Timestamp.now(),
    });
  }

  void addSubList(String collectionPath, String documentId, String subCollectionPath, String itemName, String imagePath,
      int itemQuantity) {
    FirebaseFirestore.instance.collection(collectionPath).doc(documentId).collection(subCollectionPath).add({
      'name': itemName,
      'quantity': itemQuantity,
      'imagePath': imagePath,
    });
  }
}
