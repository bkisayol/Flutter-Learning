import 'package:flutter/material.dart';
import 'package:shoppinglist/screens/main_groceries.dart';
import 'package:shoppinglist/screens/main_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar({Key? key, required this.selectedIndex}) : super(key: key);

  int selectedIndex;

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    Groceries(),
  ];

  void pushThePage(index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Groceries(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GNav(
      rippleColor: Colors.grey, // tab button ripple color when pressed
      hoverColor: Colors.blueGrey, // tab button hover color
      haptic: true, // haptic feedback
      tabBorderRadius: 15,
      tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
      tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
      tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
      curve: Curves.easeOutExpo, // tab animation curves
      duration: const Duration(milliseconds: 900), // tab animation duration
      gap: 8, // the tab button gap between icon and text
      color: Colors.grey[800], // unselected icon color
      activeColor: Colors.purple, // selected icon and text color
      iconSize: 24, // tab button icon size
      tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'Home',
          onPressed: () {
            pushThePage(widget.selectedIndex);
          },
        ),
        GButton(
          icon: Icons.list_alt_sharp,
          text: 'Lists',
          onPressed: () {
            pushThePage(widget.selectedIndex);
          },
        ),
      ],
      selectedIndex: widget.selectedIndex,
      onTabChange: (index) {
        if (mounted) {
          setState(() {
            widget.selectedIndex = index;
          });
        }
      },
    );
  }
}
