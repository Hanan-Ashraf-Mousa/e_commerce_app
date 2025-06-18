import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../favourite/favorite_screen.dart';
import '../home/home_screen.dart';
import '../products/products-screen.dart';
import '../profile/profile_screen.dart';

class LayoutScreen extends StatefulWidget {
  static const String routeName = '/layout';

  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final PageController _pageController = PageController();
   String userId ='';
  int _currentIndex = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }
  getUserId()async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  userId = prefs.getString('userId')!;
  setState(() {

  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index)=>setState(() {
          _currentIndex=index;
        }),
        children: [
          HomeScreen(),
          ProductsScreen(),
          FavoritesScreen(userId: userId,),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff004182),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedIconTheme: IconThemeData(color: Colors.white ,size: 25),
          selectedIconTheme: IconThemeData(size: 35),

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              label: 'Home',
              activeIcon: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.home_outlined , color: Color(0xff004182)),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined, color: Colors.white),
              label: 'Products',
              activeIcon: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.category_outlined , color: Color(0xff004182)),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined, color: Colors.white),
              label: 'favourite',
              activeIcon: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.favorite_border_outlined , color: Color(0xff004182)),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white),
              label: 'Account',
              activeIcon: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.account_circle_outlined , color: Color(0xff004182)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
