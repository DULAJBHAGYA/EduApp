import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/student/home/presentation/student_home.dart';
import 'package:eduapp/features/student/profile/presentation/pages/student_profile.dart';
import 'package:eduapp/features/student/courses/presentation/pages/all_courses.dart';
import 'package:eduapp/features/student/my_courses/presentation/pages/my_courses.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHome(
              username: '',
              accessToken: '',
              refreshToken: '',
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StdAllCourses(
              username: '',
              accessToken: '',
              refreshToken: '',
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCourses(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentProfile(
              username: '',
              accessToken: '',
              refreshToken: '',
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppPallete.white,
      height: 70,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      destinations: [
        NavigationDestination(
          icon: Icon(Iconsax.home,
              color: _selectedIndex == 0 ? AppPallete.darkblue : null),
          label: 'Home',
          selectedIcon: Icon(Iconsax.home, color: AppPallete.darkblue),
        ),
        NavigationDestination(
          icon: Icon(Iconsax.book,
              color: _selectedIndex == 1 ? AppPallete.darkblue : null),
          label: 'All Courses',
          selectedIcon: Icon(Iconsax.book, color: AppPallete.darkblue),
        ),
        NavigationDestination(
          icon: Icon(Iconsax.book_1,
              color: _selectedIndex == 2 ? AppPallete.darkblue : null),
          label: 'My Courses',
          selectedIcon: Icon(Iconsax.book_1, color: AppPallete.darkblue),
        ),
        NavigationDestination(
          icon: Icon(Iconsax.user,
              color: _selectedIndex == 3 ? AppPallete.darkblue : null),
          label: 'Profile',
          selectedIcon: Icon(Iconsax.user, color: AppPallete.darkblue),
        ),
      ],
    );
  }
}
