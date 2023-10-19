// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:shoppinglist/screens/category_details_screen.dart';

class ItemCard extends StatefulWidget {
  ItemCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.imageList,
    required this.itemList,
  }) : super(key: key);
  late final List<String> itemList;
  late final List<String> imageList;
  final String imagePath;
  final String name;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isSelected = false;

  void _addItem() {
    widget.imageList.add(widget.imagePath);
    widget.itemList.add(widget.name);
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  void _removeItem() {
    widget.imageList.remove(widget.imagePath);
    widget.itemList.remove(widget.name);

    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Stack(children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isSelected == false ? Colors.white : Colors.blue, // Set the border color
                width: 1, // Set the border width
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.imagePath),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Column(children: [
              IconButton(
                iconSize: 15,
                icon: const Icon(Icons.add),
                onPressed: _isSelected == false ? _addItem : null,
              ),
              const SizedBox(
                height: 16,
              ),
              _isSelected == false
                  ? const SizedBox()
                  : IconButton(
                      iconSize: 15,
                      icon: const Icon(Icons.delete),
                      onPressed: _removeItem,
                    )
            ]),
          ),
        ]),
        const SizedBox(height: 6),
        Text(
          widget.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
