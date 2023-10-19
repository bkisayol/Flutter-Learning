import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/firebase_service.dart';
import 'package:shoppinglist/screens/category_details_screen.dart';
import 'package:shoppinglist/screens/lists_screen.dart';
import 'package:shoppinglist/widgets/bottom_navigation_bar.dart';
import 'package:shoppinglist/widgets/Cards/category_card.dart';

import '../widgets/Cards/drawerCard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String catologColPath = 'catalog';

  List<String> mainScreenDrawerList = [];
  List<String> mainScreenDrawerImgList = [];
  List<int> itemQuantityList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: FirebaseService().getDocuments(catologColPath),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched.
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs.
        }

        final catalogData = snapshot.data;

        return Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
          appBar: AppBar(
            title: const Text('Shooping List'),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.shopping_basket),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
          drawer: StreamBuilder<Object>(builder: (context, snapshot) {
            return DrawerCard(
                imgList: mainScreenDrawerImgList,
                itemNameList: mainScreenDrawerList,
                itemQuantityList: itemQuantityList);
          }),
          body: GridView.builder(
            itemCount: catalogData!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final imagePath = catalogData[index]['image_path'];
              final imageName = catalogData[index]['name'];

              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriesDetailsScreen(
                          name: imageName,
                          mainScreenDrawerList: mainScreenDrawerList,
                          mainScreenDrawerImgList: mainScreenDrawerImgList,
                        ),
                      )).then((value) => itemQuantityList = List.generate(mainScreenDrawerList.length, (index) => 1));
                },
                child: CategoryCard(
                  imagePath: imagePath,
                  name: imageName,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
