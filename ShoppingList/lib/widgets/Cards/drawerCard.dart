import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/lists_screen.dart';

class DrawerCard extends StatefulWidget {
  DrawerCard({super.key, required this.imgList, required this.itemNameList, required this.itemQuantityList});
  final List<String> imgList;
  final List<String> itemNameList;
  List<int> itemQuantityList;

  @override
  State<DrawerCard> createState() => _DrawerCardState();
}

class _DrawerCardState extends State<DrawerCard> {
  List<String> _imgList = [];
  List<String> _itemNameList = [];
  List<int> _itemQuantityList = [];
  void saveToList() {
    _imgList = widget.imgList;
    _itemNameList = widget.itemNameList;
    _itemQuantityList = widget.itemQuantityList;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroceryLists(
            imagePaths: _imgList,
            itemNames: _itemNameList,
            itemQuantities: _itemQuantityList,
          ),
        ));
  }

  void _increasmentQuantity(index) {
    setState(() {
      widget.itemQuantityList[index]++;
    });
  }

  void _decreasmentQuantity(index) {
    setState(() {
      widget.itemQuantityList[index]--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.itemNameList.length,
              itemBuilder: (context, index) => Dismissible(
                key: Key(widget.itemNameList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  // Handle dismiss action
                  setState(() {
                    widget.itemNameList.removeAt(index);
                    widget.itemQuantityList.removeAt(index);
                    widget.imgList.removeAt(index);
                  });
                },
                child: SizedBox(
                  height: 75,
                  child: Card(
                    color: Colors.pinkAccent,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.white,
                          width: 50,
                          height: double.infinity,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(widget.imgList[index]),
                          ),
                        ), //Image
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              widget.itemNameList[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        Container(
                          color: Colors.white,
                          width: 96,
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 26,
                                  child: IconButton(
                                      onPressed: () => _increasmentQuantity(index), icon: const Icon(Icons.add))),
                              const SizedBox(width: 6),
                              SizedBox(width: 26, child: Center(child: Text('${widget.itemQuantityList[index]}'))),
                              const SizedBox(width: 6),
                              SizedBox(
                                  width: 26,
                                  child: IconButton(
                                      onPressed:
                                          widget.itemQuantityList[index] > 1 ? () => _decreasmentQuantity(index) : null,
                                      icon: const Icon(Icons.remove)))
                            ],
                          ),
                        ),
                        const SizedBox(width: 8)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: saveToList,
            child: Text('Save the list'),
          ),
        ],
      ),
    );
  }
}
