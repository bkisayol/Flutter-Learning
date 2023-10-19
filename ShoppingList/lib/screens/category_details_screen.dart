import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/screens/main_screen.dart';
import '../widgets/Cards/item_card.dart';

class CategoriesDetailsScreen extends StatefulWidget {
  CategoriesDetailsScreen({super.key, required this.name, this.mainScreenDrawerList, this.mainScreenDrawerImgList});

  final String name;
  List<String>? mainScreenDrawerList;
  List<String>? mainScreenDrawerImgList;

  @override
  State<CategoriesDetailsScreen> createState() => _CategoriesDetailsScreenState();
}

class _CategoriesDetailsScreenState extends State<CategoriesDetailsScreen> {
  var quantity = 0;
  List<String> _generalList = [];
  List<String> _generalImgList = [];
  Future<List<Map<String, dynamic>>> fetchCatalogData() async {
    String collectionName = widget.name;
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('catalog').doc(collectionName).collection(collectionName).get();

    List<Map<String, dynamic>> catalogData = [];

    snapshot.docs.forEach((DocumentSnapshot doc) {
      catalogData.add(doc.data() as Map<String, dynamic>);
    });

    return catalogData;
  }

  void getCatalogImageData() async {
    List<Map<String, dynamic>> catalogData = await fetchCatalogData();
  }

  List<String> itemList = [];
  List<String> imageList = [];

  void _pushList() async {
    if (widget.mainScreenDrawerList == null && widget.mainScreenDrawerImgList == null) {
      _generalList == [];
      _generalImgList == [];
    } else {
      widget.mainScreenDrawerList!.addAll(itemList);
      widget.mainScreenDrawerImgList!.addAll(imageList);
      widget.mainScreenDrawerImgList!;
    }

    Navigator.pop(context, widget.mainScreenDrawerImgList);

    setState(() {
      itemList.clear();
      imageList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchCatalogData().asStream(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched.
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs.
        }
        final catalogData = snapshot.data;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              label: const Text('Add Item'), icon: const Icon(Icons.add), onPressed: _pushList),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: Text(widget.name),
          ),
          body: GridView.builder(
            itemCount: catalogData!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final imagePath = catalogData[index]['item_image_path'];
              final imageName = catalogData[index]['item_name'];

              return ItemCard(
                itemList: itemList,
                imageList: imageList,
                imagePath: imagePath,
                name: imageName,
              );
            },
          ),
        );
      },
    );
  }
}
