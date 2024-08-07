import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/add_courses/data/dataSources/course_service.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_bloc.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_event.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_state.dart';
import 'package:eduapp/features/admin/edit_course/presentation/pages/edit_course.dart';
import 'package:eduapp/features/admin/home/presentation/pages/admin_home.dart';
import 'package:eduapp/features/admin/new_course/presentation/pages/new_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class AddCourses extends StatefulWidget {
  const AddCourses({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _AddCoursesState createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<AddCoursesBloc>().add(FetchCoursesById());
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
            padding: const EdgeInsets.all(10.0),
            child: Icon(Iconsax.menu_1, size: 30, color: AppPallete.black),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      '/logos/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Add Courses',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewCourse(
                            username: widget.username,
                            accessToken: widget.accessToken,
                            refreshToken: widget.refreshToken,
                          )));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppPallete.darkblue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'ADD NEW COURSE',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocBuilder<AddCoursesBloc, AddCoursesState>(
              builder: (context, state) {
                if (state is AddCoursesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is AddCoursesLoaded) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: state.addedCourses.map((addedcourse) {
                        return AdminAddedCourseViewCard(
                          what_will: addedcourse['what_will'] ?? {},
                          description:
                              addedcourse['description'] ?? 'No Description',
                          course_id: addedcourse['course_id'] ?? 0,
                          image: addedcourse['image'] ?? '',
                          title: addedcourse['title'] ?? 'No Title',
                          catagory: addedcourse['catagory'] ?? 'Uncategorized',
                        );
                      }).toList(),
                    ),
                  );
                } else if (state is AddCoursesError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class AdminAddedCourseViewCard extends StatelessWidget {
  final int course_id;
  final String description;
  final String image;
  final String title;
  final String catagory;
  final Map<String, dynamic> what_will;

  const AdminAddedCourseViewCard({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppPallete.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Image
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppPallete.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                catagory.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppPallete.lightgrey,
                                ),
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppPallete.white,
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) async {
                              switch (value) {
                                case 'EDIT COURSE':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditCourse(
                                        username: '',
                                        accessToken: '',
                                        refreshToken: '',
                                        course_id: course_id,
                                      ),
                                    ),
                                  );
                                  break;
                                case 'DELETE COURSE':
                                  bool confirmed = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Confirm Deletion',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppPallete.black)),
                                        content: Text(
                                          'Are you sure you want to delete this course?',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: AppPallete.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text(
                                              'No',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: AppPallete.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                              'Yes',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: AppPallete.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmed) {
                                    try {
                                      await CourseService.instance
                                          .deleteCourseById(course_id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                          'Course deleted successfully',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: AppPallete.white,
                                              fontWeight: FontWeight.w400),
                                        )),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                          'Failed to delete course: $e',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: AppPallete.white,
                                              fontWeight: FontWeight.w400),
                                        )),
                                      );
                                    }
                                  }
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {
                                'EDIT COURSE',
                                'DELETE COURSE',
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: AppPallete.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ));
                              }).toList();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.black,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AddMaterial(
                          //         username: '',
                          //         accessToken: '',
                          //         refreshToken: '',
                          //         course_id: course_id,
                          //         title: title),
                          //   ),
                          // );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppPallete.darkblue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Add Materials'.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppPallete.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
