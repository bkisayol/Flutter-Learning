import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListDetailsCard extends StatefulWidget {
  ListDetailsCard({super.key, required this.itemName, required this.itemImagePath, required this.itemQuantity});
  final String itemImagePath;
  final String itemName;
  int itemQuantity;

  @override
  State<ListDetailsCard> createState() => _ListDetailsCardState();
}

class _ListDetailsCardState extends State<ListDetailsCard> {
  void _increasmentQuantity() {
    setState(() {
      widget.itemQuantity++;
    });
  }

  void _decreasmentQuantity() {
    setState(() {
      widget.itemQuantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                child: Image.network(widget.itemImagePath),
              ),
            ), //Image
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  widget.itemName,
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
                  SizedBox(width: 26, child: IconButton(onPressed: _increasmentQuantity, icon: const Icon(Icons.add))),
                  const SizedBox(width: 6),
                  SizedBox(width: 26, child: Center(child: Text('${widget.itemQuantity}'))),
                  const SizedBox(width: 6),
                  SizedBox(
                      width: 26,
                      child: IconButton(
                          onPressed: widget.itemQuantity > 1 ? _decreasmentQuantity : null,
                          icon: const Icon(Icons.remove)))
                ],
              ),
            ),
            const SizedBox(width: 8)
          ],
        ),
      ),
    );
  }
}
