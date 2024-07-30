import 'package:carousel_slider/carousel_slider.dart';
import 'package:eduapp/core/shared/widgets/bottom_navbar.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/student/home/data/dataSources/catagory_service.dart';
import 'package:eduapp/features/student/home/data/dataSources/count_service.dart';
import 'package:eduapp/features/student/home/data/dataSources/course_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppPallete.background,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Container(
            child: Column(
              children: [
                //user info
                UserInfo(),

                SizedBox(height: 10),

                //count details
                UserStats(),
                SizedBox(height: 0),

                //image slider
                ImageSlider(),
                SizedBox(height: 5),

                // SizedBox(height: 10),
                //topcategories
                Topcategories(
                    username: widget.username,
                    accessToken: widget.accessToken,
                    refreshToken: widget.refreshToken),
                SizedBox(height: 30),

                //course filter
                HorizontalListview(),

                SizedBox(height: 10),

                CourseList(
                    username: widget.username,
                    accessToken: widget.accessToken,
                    refreshToken: widget.refreshToken),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //user profile photo
        // SizedBox(
        //   width: 60,
        //   height: 60,
        //   child: CircleAvatar(
        //     radius: 48,
        //     backgroundImage: AssetImage('/images/user1.jpg'),
        //   ),
        // ),

        SizedBox(width: 10),

        //user name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Find Your ',
                style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Best',
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: AppPallete.blue,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  'Online Course',
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black),
                ),
                SizedBox(
                  width: 10,
                ),
                Image.asset('/images/fireemoji.png', width: 40, height: 40)
              ],
            ),
          ],
        ),

        // Spacer to push notification icon to the right
        Spacer(),

        //notification icon
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppPallete.white,
            ),
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
                          '10',
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
        )
      ],
    );
  }
}

class UserStats extends StatefulWidget {
  const UserStats({Key? key}) : super(key: key);

  @override
  _UserStatsState createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  int courseCount = 0;
  int ongoingCourseCount = 0;
  int completedCourseCount = 0;

  @override
  void initState() {
    super.initState();
    fetchCourseCount();
    fetchOngoingCourseCount();
    fetchCompletedCourseCount();
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

  Future<void> fetchOngoingCourseCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        final response =
            await CountService.instance.getOngoingCourseCountByUserId(userId);

        if (response != null) {
          if (response is int) {
            setState(() {
              ongoingCourseCount = response;
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

  Future<void> fetchCompletedCourseCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        final response =
            await CountService.instance.getCompletedCourseCountByUserId(userId);

        if (response != null) {
          if (response is int) {
            setState(() {
              completedCourseCount = response;
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppPallete.darkblue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(clipBehavior: Clip.none, children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            courseCount.toString(),
                            style: GoogleFonts.openSans(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: AppPallete.white),
                          ),
                          Text(
                            'All \nCourses',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.white),
                          ),
                        ],
                      ),
                    ]),
                  )),
              SizedBox(width: 10),
              Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppPallete.darkblue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          completedCourseCount.toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppPallete.white),
                        ),
                        Text(
                          'Completed \nCourses',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppPallete.white),
                        ),
                      ],
                    ),
                  )),
              SizedBox(width: 10),
              Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppPallete.darkblue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ongoingCourseCount.toString(),
                          style: GoogleFonts.openSans(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppPallete.white),
                        ),
                        Text(
                          'Ongoing \nCourses',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppPallete.white),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      )),
    );
  }
}

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        //1st Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage('/images/goCourse.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //2nd Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage("/images/belnderCourse.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //3rd Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage("/images/psCourse.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //4th Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage("/images/reactCourse.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //5th Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage("/images/awsCourse.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 25 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 1200),
        viewportFraction: 0.8,
      ),
    );
  }
}

class Topcategories extends StatefulWidget {
  const Topcategories({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _TopcategoriesState createState() => _TopcategoriesState();
}

class _TopcategoriesState extends State<Topcategories> {
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final categoryData = await CategoryServices.instance.fetchAllCategories();
      final List<Map<String, dynamic>> categoriesJson =
          List<Map<String, dynamic>>.from(categoryData ?? []);
      final List<String> categories = categoriesJson
          .map((category) => category['catagory'].toString())
          .toList();

      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Top Categories',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.black),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _categories.map((category) {
                  return CategoryCard(
                    category: category,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPallete.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppPallete.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalListview extends StatelessWidget {
  const HorizontalListview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recommended Courses',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.black),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => StdAllCourses(
                  //             username: '',
                  //             refreshToken: '',
                  //             accessToken: '')));
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppPallete.darkblue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CourseList extends StatefulWidget {
  const CourseList({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _courses.take(3).map((course) {
            return CourseListCard(
              what_will: course['what_will'] ?? {},
              description: course['description'] ?? 'No Description',
              course_id: course['course_id'] ?? 0,
              image: course['image'] ?? '',
              title: course['title'] ?? 'No Title',
              catagory: course['catagory'] ?? 'Uncategorized',
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CourseListCard extends StatelessWidget {
  final int course_id;
  final String description;
  final String image;
  final String title;
  final String catagory;
  final Map<String, dynamic> what_will;

  const CourseListCard({
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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            // image
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.lightgrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
