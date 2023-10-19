import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppinglist/firebase_service.dart';
import 'package:shoppinglist/screens/new_list_screen.dart';
import 'package:shoppinglist/widgets/FloatingActionButton/new_list.dart';

import '../widgets/Cards/lists_card.dart';
import 'main_groceries.dart';

class GroceryLists extends StatefulWidget {
  const GroceryLists({super.key, required this.itemNames, required this.imagePaths, required this.itemQuantities});

  final List<String> itemNames;
  final List<String> imagePaths;
  final List<int> itemQuantities;

  @override
  State<GroceryLists> createState() => _GroceryListsState();
}

class _GroceryListsState extends State<GroceryLists> {
  final String groceryColPath = 'grocery-list';
  final String listDetailsColPath = 'list-details';
  String? priority;
  int? _selectedCardIndex;
  String? name;
  DateTime? dateTime;
  List loadedList = [];
  String? documentId;
  bool _isSelected = false;
  final user = FirebaseAuth.instance.currentUser!;

  void _onListCardIconButtonPressed(String documentId) {
    for (int i = 0; i < widget.itemNames.length; i++) {
      FirebaseService().addSubList(
        groceryColPath,
        documentId,
        listDetailsColPath,
        widget.itemNames[i],
        widget.imagePaths[i],
        widget.itemQuantities[i],
      );
    }

    widget.itemNames.clear();
    widget.imagePaths.clear();
    widget.itemQuantities.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Groceries()),
    );
  }

  void _createAList() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NewListScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: FirebaseService().getDocumentByUserId(user.email ?? 'admin@admin.com', groceryColPath),
        builder: (ctx, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Scaffold(
              floatingActionButton: const NewList(),
              appBar: AppBar(
                title: const Text('All groceries'),
              ),
              body: const Center(
                child: Text('No list found first create a shoopinglist'),
              ),
            );
          }
          if (!snapshots.hasData || snapshots.data!.isEmpty) {
            return Scaffold(
              floatingActionButton: const NewList(),
              appBar: AppBar(
                title: const Text('All groceries'),
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
              body: Column(children: [
                const SizedBox(height: 100),
                Image.asset('assets/MainImages/emptybasket.png'),
                const Text('No list found first create a shooping list'),
              ]),
            );
          }
          if (snapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          final loadedList = snapshots.data!;
          loadedList.sort((a, b) => -a['createdAt'].compareTo(b['createdAt']));

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Select or Create a list to save list. ',
                style: TextStyle(fontSize: 16),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: loadedList.length,
                    itemBuilder: (ctx, index) {
                      final listData = loadedList[index];
                      if (listData == null) {
                        return const SizedBox(); // Skip rendering if data is null
                      }
                      dateTime = listData['createdAt'].toDate();
                      String formattedDate = DateFormat('dd.MM.yyyy - kk:mm').format(dateTime!);

                      name = listData['name'] + ' - ' + formattedDate;
                      priority = listData['priority'];

                      return ListCard(
                        name: name!,
                        priority: priority ?? 'Low',
                        index: index, // Pass the index to ListCard
                        onIconButtonPressed: _onListCardIconButtonPressed, // Pass the callback function
                        loadedList: loadedList, // Pass the _loadedList to ListCard
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: _createAList,
                  child: ListCard(
                    name: 'Create A New List',
                    priority: 'New',
                    onIconButtonPressed: _onListCardIconButtonPressed,
                    index: null, // Pass the callback function
                    loadedList: loadedList, //
                  ),
                )
              ],
            ),
          );
        });
  }
}
