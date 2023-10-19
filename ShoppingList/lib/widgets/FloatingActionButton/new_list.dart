import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewList extends StatefulWidget {
  const NewList({Key? key}) : super(key: key);

  @override
  State<NewList> createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  final _nameController = TextEditingController();
  int selectedContainerIndex = -1;

  List<String> users = [];
  List<String> userIds = [];

  List<Color> containerColors = [const Color(0xFFE65100), const Color(0xFF006B54), const Color(0xFF004881)];
  List<String> containerTitles = ['High', 'Medium', 'Low'];

  void onContainerClicked(int index) {
    setState(() {
      selectedContainerIndex = index;
    });
  }

  Widget buildContainerWidget(int index, StateSetter setState) {
    final isSelected = selectedContainerIndex == index;
    final borderColor = isSelected ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedContainerIndex = index;
        });
        onContainerClicked(index);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: containerColors[index],
          border: Border.all(
            color: borderColor,
            width: 3.0,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            containerTitles[index],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _addGroceryList() {
    final enteredName = _nameController.text;
    String _selectedPriority = 'default';

    if (enteredName.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _nameController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    userIds.add(user.email ?? 'admin@admin.com');
    if (selectedContainerIndex == -1) {
      _selectedPriority;
    } else {
      _selectedPriority = containerTitles[selectedContainerIndex];
    }

    FirebaseFirestore.instance.collection('grocery-list').add({
      'name': enteredName,
      'userId': userIds,
      'priority': _selectedPriority,
      'createdAt': Timestamp.now(),
    });

    userIds = [];

    Navigator.pop(context, "Added successfully");
    setState(() {
      selectedContainerIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('Create'),
      icon: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: ((context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 500,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter a shopping list name...',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Set Priority'),
                      Row(
                        children: [
                          Expanded(
                            child: buildContainerWidget(0, setState),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildContainerWidget(1, setState),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildContainerWidget(2, setState),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addGroceryList,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
