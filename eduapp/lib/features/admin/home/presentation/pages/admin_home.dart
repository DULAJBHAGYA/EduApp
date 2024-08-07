import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/add_courses/presentation/pages/add_courses.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/pages/admin_profile.dart';
import 'package:eduapp/features/admin/courses/presentation/pages/admin_all_courses.dart';
import 'package:eduapp/features/admin/home/data/dataSources/count_service.dart';
import 'package:eduapp/features/admin/home/data/dataSources/course_service.dart';
import 'package:eduapp/features/admin/home/data/dataSources/student_service.dart';
import 'package:eduapp/features/shared/auth/data/dataSources/user_services.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String first_name = '';
  late String last_name = '';
  late String picture = '';
  int deleteRequestCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUserById();
    fetchDeleteRequestCount();
  }

  Future<void> fetchDeleteRequestCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        final response =
            await CountService.instance.getDeleteRequestByUserId(userId);

        if (response != null) {
          if (response is int) {
            setState(() {
              deleteRequestCount = response;
            });
          } else {
            throw Exception('Course count is not an integer');
          }
        } else {
          throw Exception('Response is null');
        }
      } else {
        throw Exception('User ID is null');
      }
    } catch (e) {
      print('Error fetching ongoing course count: $e');
    }
  }

  Future<void> fetchUserById() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');
      final accessToken = prefs.getString('access_token');

      if (user_id != null && accessToken != null) {
        final response =
            await UserService.instance.fetchUsersById(user_id, accessToken);

        setState(() {
          first_name = response['GetUserIDRow']['first_name'];
          last_name = response['GetUserIDRow']['last_name'];
          picture = response['GetUserIDRow']['picture'];
        });

        print('Fetched User: $first_name $last_name');
      } else {
        print('User ID or Access Token not found in SharedPreferences');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPallete.background,
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: AppPallete.background,
        elevation: 0,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(Iconsax.menu_1, size: 30, color: AppPallete.black),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppPallete.white,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DeleteRequests(
                  //             username: '',
                  //             accessToken: '',
                  //             refreshToken: '')));
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Iconsax.notification_status4,
                          size: 30,
                          color: AppPallete.black,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppPallete.darkblue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              deleteRequestCount.toString(),
                              style: GoogleFonts.poppins(
                                color: AppPallete.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              AdminInfo(
                first_name: first_name,
                last_name: last_name,
                picture: picture,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      AdminStats(),
                      SizedBox(
                        height: 20,
                      ),
                      AdminDashStudents(
                          username: '', refreshToken: '', accessToken: ''),
                      SizedBox(
                        height: 20,
                      ),
                      AdminDashCourses(
                          username: '', refreshToken: '', accessToken: ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                  // case 4:
                  //   return _buildListTile(
                  //     index: 4,
                  //     icon: Iconsax.add,
                  //     title: 'Enrollments',
                  //     destination: Enrollments(
                  //         username: '', accessToken: '', refreshToken: ''),
                  //   );
                  // case 5:
                  //   return _buildListTile(
                  //     index: 5,
                  //     icon: Iconsax.document,
                  //     title: 'Submissions',
                  //     destination: Submissions(
                  //         username: '', accessToken: '', refreshToken: ''),
                  //   );
                  // case 6:
                  //   return _buildListTile(
                  //     index: 6,
                  //     icon: Iconsax.people,
                  //     title: 'Admins',
                  //     destination: Admins(
                  //         username: '', accessToken: '', refreshToken: ''),
                  //   );
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

class AdminInfo extends StatelessWidget {
  final String first_name;
  final String last_name;
  final String picture;

  const AdminInfo({
    required this.first_name,
    required this.last_name,
    required this.picture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WELCOME BACK',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppPallete.grey,
                    ),
                  ),
                  Text(
                    '$first_name $last_name'.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(picture),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminStats extends StatefulWidget {
  const AdminStats({Key? key}) : super(key: key);

  @override
  _AdminStatsState createState() => _AdminStatsState();
}

class _AdminStatsState extends State<AdminStats> {
  int studentCount = 0;
  int courseCount = 0;
  int adminCount = 0;
  int subscriptionCount = 0;

  @override
  void initState() {
    super.initState();
    fetchStudentCount();
    fetchCourseCount();
    fetchAdminCount();
    fetchSubscriptionCount();
  }

  Future<void> fetchStudentCount() async {
    try {
      final response = await CountService.instance.getStudentCount();

      if (response != null) {
        if (response is int) {
          setState(() {
            studentCount = response;
          });
        } else {
          throw Exception('Student count is not an integer');
        }
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error fetching student count: $e');
    }
  }

  Future<void> fetchCourseCount() async {
    try {
      final response = await CountService.instance.getCoursesCount();

      if (response != null) {
        if (response is int) {
          setState(() {
            courseCount = response;
          });
        } else {
          throw Exception('Course count is not an integer');
        }
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error fetching student count: $e');
    }
  }

  Future<void> fetchSubscriptionCount() async {
    try {
      final response = await CountService.instance.getSubscriptionCount();

      if (response != null) {
        if (response is int) {
          setState(() {
            subscriptionCount = response;
          });
        } else {
          throw Exception('Subscription count is not an integer');
        }
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error fetching subscription count: $e');
    }
  }

  Future<void> fetchAdminCount() async {
    try {
      final response = await CountService.instance.getAdminsCount();

      if (response != null) {
        if (response is int) {
          setState(() {
            adminCount = response;
          });
        } else {
          throw Exception('Admins count is not an integer');
        }
      } else {
        throw Exception('Response is null');
      }
    } catch (e) {
      print('Error fetching student count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppPallete.darkblue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      studentCount.toString(),
                      style: GoogleFonts.openSans(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppPallete.white,
                      ),
                    ),
                    Text(
                      'Registered Students',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppPallete.white),
                    ),
                  ],
                ),
              )),
          SizedBox(width: 5),
          Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppPallete.darkblue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            courseCount.toString(),
                            style: GoogleFonts.openSans(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: AppPallete.white),
                          ),
                          Text(
                            'Courses',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.white),
                          ),
                        ],
                      ),
                    ])
                  ],
                ),
              )),
        ]),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppPallete.darkblue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      subscriptionCount.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: AppPallete.white),
                    ),
                    Text(
                      'Enrolled Students',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.white),
                    ),
                  ],
                ),
              )),
          SizedBox(width: 5),
          Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppPallete.darkblue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      adminCount.toString(),
                      style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: AppPallete.white),
                    ),
                    Text(
                      'Admins',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppPallete.white),
                    ),
                  ],
                ),
              )),
        ])
      ]),
    );
  }
}

class AdminDashStudents extends StatefulWidget {
  const AdminDashStudents({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _AdminDashStudentsState createState() => _AdminDashStudentsState();
}

class _AdminDashStudentsState extends State<AdminDashStudents> {
  List<dynamic> _students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final studentData = await StudentService.instance.fetchAllStudents();
      setState(() {
        _students = studentData ?? [];
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Students'.toUpperCase(),
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppPallete.black),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AdminStudents(
                      //               username: widget.username,
                      //               accessToken: widget.accessToken,
                      //               refreshToken: widget.refreshToken,
                      //             )));
                    },
                    child: Text(
                      'View all',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppPallete.darkblue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: _students.take(3).map((student) {
                  return AdminDashStudentsDisplayCard(
                      user_name: student['user_name'] ?? 'N/A',
                      email: student['email'] ?? 'N/A',
                      first_name: student['first_name'] ?? 'N/A',
                      last_name: student['last_name'] ?? 'N/A',
                      picture: student['picture'] ?? 'N/A');
                }).toList(),
              )
            ],
          ),
        ));
  }
}

class AdminDashStudentsDisplayCard extends StatelessWidget {
  final String email;
  final String first_name;
  final String last_name;
  final String user_name;
  final String picture;

  const AdminDashStudentsDisplayCard({
    required this.user_name,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.picture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppPallete.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(picture),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$first_name $last_name',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppPallete.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$user_name',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppPallete.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$email',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppPallete.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
        ));
  }
}

class AdminDashCourses extends StatefulWidget {
  const AdminDashCourses({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _AdminDashCoursesState createState() => _AdminDashCoursesState();
}

class _AdminDashCoursesState extends State<AdminDashCourses> {
  List<dynamic> _courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final courseData = await CourseService.instance.fetchAllCourses();
      setState(() {
        _courses = courseData ?? [];
      });
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Courses'.toUpperCase(),
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppPallete.black),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AdminCourses(
                    //               username: '',
                    //               accessToken: '',
                    //               refreshToken: '',
                    //             )));
                  },
                  child: Text(
                    'View all',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppPallete.darkblue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: _courses.take(3).map((course) {
                return AdminDashCoursessDisplayCard(
                  what_will: course['what_will'] ?? {},
                  description: course['description'] ?? 'No Description',
                  course_id: course['course_id'] ?? 0,
                  image: course['image'] ?? '',
                  title: course['title'] ?? 'No Title',
                  catagory: course['catagory'] ?? 'Uncategorized',
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class AdminDashCoursessDisplayCard extends StatelessWidget {
  final int course_id;
  final String description;
  final String image;
  final String title;
  final String catagory;
  final Map<String, dynamic> what_will;

  const AdminDashCoursessDisplayCard({
    required this.course_id,
    required this.image,
    required this.title,
    required this.catagory,
    required this.description,
    required this.what_will,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppPallete.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            // Image
            Container(
              height: 95,
              width: 95,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(width: 20),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppPallete.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          catagory.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.lightgrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
