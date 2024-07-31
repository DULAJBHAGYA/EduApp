import 'package:dio/dio.dart';
import 'package:eduapp/core/shared/widgets/bottom_navbar.dart';
import 'package:eduapp/features/student/my_courses/data/dataSources/enroll_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_event.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_state.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyCoursesBloc()
        ..add(FetchOngoingCourses())
        ..add(FetchCompletedCourses()),
      child: BlocBuilder<MyCoursesBloc, MyCoursesState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppPallete.background,
            body: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Courses',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TabBar(
                      tabs: [
                        Tab(
                          child: Row(
                            children: [
                              Text(
                                'Ongoing',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppPallete.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppPallete.black,
                                ),
                                child: Center(
                                  child: BlocBuilder<MyCoursesBloc,
                                      MyCoursesState>(
                                    builder: (context, state) {
                                      if (state is OngoingCoursesFetched) {
                                        return Text(
                                          state.count.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: AppPallete.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            children: [
                              Text(
                                'Completed',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppPallete.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppPallete.black,
                                ),
                                child: Center(
                                  child: BlocBuilder<MyCoursesBloc,
                                      MyCoursesState>(
                                    builder: (context, state) {
                                      if (state is CompletedCoursesFetched) {
                                        return Text(
                                          state.count.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: AppPallete.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppPallete.darkblue,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          OnGoingCourses(
                            username: '',
                            accessToken: '',
                            refreshToken: '',
                          ),
                          CompletedCourses(
                            username: '',
                            accessToken: '',
                            refreshToken: '',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavBar(),
          );
        },
      ),
    );
  }
}

class OnGoingCourses extends StatefulWidget {
  const OnGoingCourses({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _OnGoingCoursesState createState() => _OnGoingCoursesState();
}

class _OnGoingCoursesState extends State<OnGoingCourses> {
  List<dynamic> _ongoingcourses = [];

  @override
  void initState() {
    super.initState();
    fetchOngoingCourses();
  }

  Future<void> fetchOngoingCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');

      if (user_id == null) {
        throw Exception('User ID not found in shared preferences');
      }

      final ongoingCourseData =
          await EnrollService.instance.fetchOngoingCourses(user_id);

      setState(() {
        _ongoingcourses = ongoingCourseData ?? [];
      });
    } on DioError catch (dioError) {
      if (dioError.response?.statusCode == 404) {
        print('Resource not found: ${dioError.response?.statusMessage}');
      } else {
        print('Dio error: ${dioError.message}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _ongoingcourses.map((ongoingcourse) {
          return OnGoingCourseCard(
              image: ongoingcourse['image'] ?? '',
              title: ongoingcourse['title'] ?? 'No title',
              catagory: ongoingcourse['catagory'] ?? 'No category',
              progress: ongoingcourse['progress'] ?? 0,
              course_id: ongoingcourse['course_id'] ?? 0);
        }).toList(),
      ),
    );
  }
}

class OnGoingCourseCard extends StatelessWidget {
  final String image;
  final String title;
  final String catagory;
  final int progress;
  final int course_id;

  const OnGoingCourseCard({
    required this.image,
    required this.title,
    required this.catagory,
    required this.progress,
    required this.course_id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CourseContent(
        //       course_id: course_id,
        //       progress: progress,
        //     ),
        //   ),
        // );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppPallete.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: [
            // Image
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            SizedBox(width: 20),

            // Course Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppPallete.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppPallete.lightgrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      catagory.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),

            SizedBox(width: 10),

            // Progress Indicator
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              progressColor: AppPallete.darkblue,
              animation: true,
              percent: progress / 100,
              center: Text(
                '${progress.toString()}%',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  fontSize: 15.0,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CompletedCourses extends StatefulWidget {
  const CompletedCourses({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _CompletedCoursesState createState() => _CompletedCoursesState();
}

class _CompletedCoursesState extends State<CompletedCourses> {
  List<dynamic> _completedcourses = [];

  @override
  void initState() {
    super.initState();
    fetchCompletedCourses();
  }

  Future<void> fetchCompletedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');

      if (user_id == null) {
        throw Exception('User ID not found in shared preferences');
      }

      final completedCourseData =
          await EnrollService.instance.fetchCompletedCourses(user_id);

      setState(() {
        _completedcourses = completedCourseData ?? [];
      });
    } on DioError catch (dioError) {
      if (dioError.response?.statusCode == 404) {
        print('Resource not found: ${dioError.response?.statusMessage}');
      } else {
        print('Dio error: ${dioError.message}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _completedcourses.map((completedcourse) {
          return CompletedCourseCard(
              image: completedcourse['image'] ?? '',
              title: completedcourse['title'] ?? 'No title',
              catagory: completedcourse['catagory'] ?? 'No category',
              progress: completedcourse['progress'] ?? 0,
              course_id: completedcourse['course_id'] ?? 0);
        }).toList(),
      ),
    );
  }
}

class CompletedCourseCard extends StatelessWidget {
  final String image;
  final String title;
  final String catagory;
  final int progress;
  final int course_id;

  const CompletedCourseCard({
    required this.image,
    required this.title,
    required this.catagory,
    required this.progress,
    required this.course_id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            // Image
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppPallete.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppPallete.background,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            catagory.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppPallete.lightgrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => CourseContent(
                            //       course_id: course_id,
                            //       progress: progress,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppPallete.darkblue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'REVIEW COURSE',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
