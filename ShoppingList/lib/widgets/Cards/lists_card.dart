import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../screens/new_list_screen.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
    required this.name,
    this.priority,
    required this.onIconButtonPressed,
    required this.index,
    required this.loadedList,
  }) : super(key: key);

  final String name;
  final String? priority;

  final int? index;
  final Function(String documentId) onIconButtonPressed;
  final List<DocumentSnapshot> loadedList;

  @override
  Widget build(BuildContext context) {
    void _createAList() {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NewListScreen()));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            height: priority == 'New' ? 75 : 150,
            child: Card(
              color: _getColor(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      name.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: priority == 'New' ? 15 : 50,
            right: 0,
            child: priority == 'New'
                ? IconButton(
                    onPressed: _createAList,
                    icon: const Icon(Icons.add),
                  )
                : IconButton(
                    onPressed: () {
                      String documentId = loadedList[index!].id; // Get the document ID based on the index
                      onIconButtonPressed(documentId); // Call the callback function with the document ID
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
          ),
          Positioned(
              top: 15,
              right: 30,
              child: Container(
                height: 100,
                width: 100,
                child: Transform.rotate(
                  angle: 45,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      'assets/MainImages/whiteShopCart.png', // Replace 'image.png' with the actual file name and path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Color _getColor() {
    if (priority == 'New') {
      return const Color.fromARGB(255, 181, 183, 184).withOpacity(0.1);
    } else if (priority == 'Low') {
      return const Color(0xFF004881);
    } else if (priority == 'Medium') {
      return const Color(0xFF006B54);
    } else if (priority == 'High') {
      return const Color(0xFFE65100);
    } else {
      return const Color.fromARGB(255, 176, 0, 230);
    }
  }
}
