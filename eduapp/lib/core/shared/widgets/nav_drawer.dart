import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/add_admins/presentation/pages/add_admin.dart';
import 'package:eduapp/features/admin/add_courses/presentation/pages/add_courses.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/pages/admin_profile.dart';
import 'package:eduapp/features/admin/courses/presentation/pages/admin_all_courses.dart';
import 'package:eduapp/features/admin/enrollments/presentation/pages/enrollments.dart';
import 'package:eduapp/features/admin/home/presentation/pages/admin_home.dart';
import 'package:eduapp/features/admin/submissions/presentation/pages/submissions.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int _hoverIndex = -1;
  int _selectedIndex = -1;

  void _onEnter(int index) {
    setState(() {
      _hoverIndex = index;
    });
  }

  void _onExit() {
    setState(() {
      _hoverIndex = -1;
    });
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildListTile({
    required int index,
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    bool isHovered = _hoverIndex == index;
    bool isSelected = _selectedIndex == index;

    return MouseRegion(
      onEnter: (_) => _onEnter(index),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: () {
          _onTap(index);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isHovered || isSelected
                ? AppPallete.darkblue
                : AppPallete.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              size: 20,
              color:
                  isHovered || isSelected ? AppPallete.white : AppPallete.black,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isHovered || isSelected
                    ? AppPallete.white
                    : AppPallete.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppPallete.white,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppPallete.white,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(color: AppPallete.darkblue),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            '/logos/logo.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Edu',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppPallete.lightblue,
                            ),
                            children: [
                              TextSpan(
                                text: 'App',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppPallete.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 9, // Number of items
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _buildListTile(
                      index: 0,
                      icon: Iconsax.home,
                      title: 'Dashboard',
                      destination: AdminHome(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  case 1:
                    return _buildListTile(
                      index: 1,
                      icon: Iconsax.book,
                      title: 'Courses',
                      destination: AdminAllCourses(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  case 2:
                    return _buildListTile(
                      index: 2,
                      icon: Iconsax.book_saved,
                      title: 'Add Courses',
                      destination: AddCourses(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  // case 3:
                  //   return _buildListTile(
                  //     index: 3,
                  //     icon: Iconsax.people,
                  //     title: 'Students',
                  //     destination: AdminStudents(
                  //         username: '', accessToken: '', refreshToken: ''),
                  //   );
                  case 4:
                    return _buildListTile(
                      index: 4,
                      icon: Iconsax.add,
                      title: 'Enrollments',
                      destination: Enrollments(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  case 5:
                    return _buildListTile(
                      index: 5,
                      icon: Iconsax.document,
                      title: 'Submissions',
                      destination: Submissions(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  case 6:
                    return _buildListTile(
                      index: 6,
                      icon: Iconsax.people,
                      title: 'Admins',
                      destination: Admins(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  case 7:
                    return _buildListTile(
                      index: 7,
                      icon: Iconsax.user,
                      title: 'Profile',
                      destination: AdminProfile(
                          username: '', accessToken: '', refreshToken: ''),
                    );
                  case 8:
                    return _buildListTile(
                      index: 8,
                      icon: Iconsax.logout,
                      title: 'Logout',
                      destination: Login(),
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
