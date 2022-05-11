import 'package:blog_app/provider/homepage_level_provider.dart';
import 'package:blog_app/services/newtworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottomHomeNav/bookmarks_page.dart';
import 'bottomHomeNav/main_page.dart';
import 'bottomHomeNav/profile_page.dart';
import 'bottomHomeNav/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   List pages=[
     MainPage(),
     SearchPage(),
     BookMarksPage(),
     ProfilePage(),
   ];
  int _currentIndex=0;
  void onTap(int index){
    setState(() {
      _currentIndex=index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageLevelProvider>(
      create: (_)=>HomePageLevelProvider(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
                icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              label: 'Search',
                icon: Icon(Icons.search)),
            BottomNavigationBarItem(
              label: 'BookMarks',
                icon: Icon(Icons.bookmarks)),
            BottomNavigationBarItem(
              label: 'Profile',
                icon: Icon(Icons.person)),
          ],

        ),
        body: pages[_currentIndex],
      ),
    );
  }
}
