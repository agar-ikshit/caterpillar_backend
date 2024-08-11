import 'package:arkitone/ar_screen.dart';
import 'package:arkitone/clientpage.dart';
import 'package:arkitone/health.dart';
import 'package:arkitone/start.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int _selectedIndex = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 35, 37, 100),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _widgetOptions(), // Call _widgetOptions as a function
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        items: <Widget>[
          _buildNavItem(Icons.people, 0),
          _buildNavItem(Icons.emergency, 1),
          _buildNavItem(Icons.home, 2),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex,
        color: Color.fromARGB(255, 48, 47, 47),
        buttonBackgroundColor: Color.fromARGB(255, 48, 47, 47),
        height: 60,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = index == _selectedIndex;
    Color iconColor =
        isSelected ? Colors.amber: Color.fromRGBO(113, 91, 35, 1);

    return Container(
      margin: const EdgeInsets.all(8),
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: isSelected
            ? Border.all(color: Colors.amber, width: 2.0)
            : Border.all(color: Colors.transparent),
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }

  List<Widget> _widgetOptions() {
    DateTime dueDate = DateTime.now(); // Obtain or set dueDate here
    return <Widget>[
      CaterpillarTechnicianPage(),
      CaterpillarProgressPage(),
      ClientPage()
      
    ];
  }
}
