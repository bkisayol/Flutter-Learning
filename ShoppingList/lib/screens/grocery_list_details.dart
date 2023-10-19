import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/data/categories.dart';
import 'package:shoppinglist/firebase_service.dart';
import 'package:shoppinglist/widgets/Cards/drawerCard.dart';
import 'package:shoppinglist/widgets/Cards/listDetailsCard.dart';
import 'package:shoppinglist/widgets/new_item.dart';

class GroceryListDetails extends StatefulWidget {
  GroceryListDetails({super.key, required this.docId});

  String docId;

  @override
  State<GroceryListDetails> createState() => _GroceryListDetailsState();
}

class _GroceryListDetailsState extends State<GroceryListDetails> {
  String groceryColPath = 'grocery-list';
  String listDetailsColPath = 'list-details';
  List<int> _itemQuantityList = [];

  String? name;
  Color? color;
  void _newItem() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => NewItem(docId: widget.docId)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getSubCollectionDocuments(groceryColPath, listDetailsColPath, widget.docId),
      builder: (ctx, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Scaffold(
            floatingActionButton: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _newItem,
            ),
            appBar: AppBar(
              title: const Text('Shooping List Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            body: const Center(child: Text('No item found lets add a item first')),
          );
        }
        if (!snapshots.hasData) {
          return Scaffold(
            floatingActionButton: IconButton(icon: const Icon(Icons.add), onPressed: _newItem),
            appBar: AppBar(
              title: const Text('Shooping List Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            body: const Center(
              child: Text('No item found lets add a item first'),
            ),
          );
        }
        if (snapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final _loadedListDetails = snapshots.data!;

        return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
                label: const Text('Save List'),
                icon: const Icon(Icons.save_outlined),
                onPressed: () => Navigator.pop(context)),
            appBar: AppBar(
              title: const Text('Shooping List Details'),
              actions: [
                IconButton(
                  onPressed: _newItem,
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            body: ListView.builder(
                itemCount: _loadedListDetails.length,
                itemBuilder: (ctx, index) {
                  final listDetailsData = _loadedListDetails[index];
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Move to trash')
                          ],
                        ),
                      ),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      FirebaseService().removeSubList(
                          groceryColPath, widget.docId, listDetailsColPath, _loadedListDetails[index].id);
                    },
                    key: ObjectKey(_loadedListDetails[index].id),
                    child: ListDetailsCard(
                        itemImagePath: listDetailsData['imagePath'],
                        itemName: listDetailsData['name'],
                        itemQuantity: listDetailsData['quantity']),
                  );
                }));
      },
    );
  }
}
