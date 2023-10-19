import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shoppinglist/firebase_service.dart';
import 'package:shoppinglist/screens/grocery_list_details.dart';
import 'package:shoppinglist/widgets/bottom_navigation_bar.dart';

import 'package:shoppinglist/widgets/FloatingActionButton/new_list.dart';

import '../widgets/Cards/mainListCard.dart';

class Groceries extends StatefulWidget {
  const Groceries({Key? key}) : super(key: key);

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  final TextEditingController _emailController = TextEditingController();
  final String groceryColPath = 'grocery-list';
  String? priority;
  String? name;
  DateTime? dateTime;
  List loadedList = [];
  final user = FirebaseAuth.instance.currentUser!;

  void _showListDetails(String documentId) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => GroceryListDetails(docId: documentId)));
  }

  void _saveEmailToFirestore(String documentId, List<DocumentSnapshot<Object?>> loadedList, int index) async {
    String enteredEmail = _emailController.text;
    if (enteredEmail.isNotEmpty) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('grocery-list').doc(documentId);

      try {
        // Fetch the current document data
        DocumentSnapshot snapshot = await docRef.get();

        // Check if the document exists and if it contains the 'userId' field of List type
        if (snapshot.exists && snapshot.data() != null) {
          final listData = loadedList[index];
          List<dynamic> userId = List.from(listData['userId']); // Explicitly cast and create a new List

          // Check if the email already exists in the 'userIds' array
          if (userId.contains(enteredEmail)) {
            // Show an error message indicating that the email already exists
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email already exists in the list.')),
            );
            return;
          }

          // If the email doesn't exist in the array, update the document
          Map<String, dynamic> dataToAdd = {
            'userId': FieldValue.arrayUnion([enteredEmail]),
          };
          await docRef.update(dataToAdd);

          // Close the AlertDialog
          Navigator.of(context).pop(true);
        } else {
          // If the 'userId' field doesn't exist or is not a List type, handle the error
          print('Error: Invalid data format or missing field.');
        }
      } catch (e) {
        // Handle any errors that might occur during the update process
        print('Error updating data: $e');
      }
    }
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
          final _loadedList = snapshots.data!;
          _loadedList.sort((a, b) => -a['createdAt'].compareTo(b['createdAt']));

          return Scaffold(
            bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1),
            floatingActionButton: const NewList(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            body: ListView.builder(
              itemCount: _loadedList.length,
              itemBuilder: (ctx, index) {
                final listData = _loadedList[index];
                if (listData == null) {
                  return const SizedBox(); // Skip rendering if data is null
                }
                dateTime = listData['createdAt'].toDate();
                String formattedDate = DateFormat('dd.MM.yyyy - kk:mm').format(dateTime!);

                name = listData['name'] + ' - ' + formattedDate;
                priority = listData['priority'];

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
                    secondaryBackground: Container(
                      color: Colors.blue,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.share),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Move to share')
                          ],
                        ),
                      ),
                    ),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      FirebaseService().removeList(_loadedList[index].id, groceryColPath);
                    },
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Move to trash'),
                                content: const Text('Are you sure want to delete this list?'),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes')),
                                  ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(false), child: const Text('No'))
                                ],
                              );
                            });
                      } else {
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Move to share'),
                                content: const Text('Are you sure want to share this list?'),
                                actions: <Widget>[
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(label: Text('Enter a E-mail address')),
                                  ),
                                  ElevatedButton(
                                      onPressed: () => _saveEmailToFirestore(_loadedList[index].id, _loadedList, index),
                                      child: const Text('Yes')),
                                  ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(false), child: const Text('No'))
                                ],
                              );
                            });
                      }
                      ;
                    },
                    key: ObjectKey(_loadedList[index].id),
                    child: InkWell(
                      child: MainListCard(
                        name: name!,
                        priority: priority ?? 'Low',
                      ),
                      onTap: () => _showListDetails(_loadedList[index].id),
                    ));
              },
            ),
          );
        });
  }
}
