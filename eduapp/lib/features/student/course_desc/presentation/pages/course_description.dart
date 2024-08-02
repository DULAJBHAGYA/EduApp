import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/student/course_desc/presentation/bloc/course_desc_bloc.dart';
import 'package:eduapp/features/student/course_desc/presentation/bloc/course_desc_event.dart';
import 'package:eduapp/features/student/course_desc/presentation/bloc/course_desc_state.dart';
import 'package:eduapp/features/student/my_courses/presentation/pages/my_courses.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CourseDescription extends StatefulWidget {
  final int course_id;
  final String description;
  final String image;
  final String title;
  final String catagory;
  final Map<String, dynamic> what_will;

  const CourseDescription({
    Key? key,
    required this.course_id,
    required this.description,
    required this.image,
    required this.title,
    required this.catagory,
    required this.what_will,
  }) : super(key: key);

  @override
  _CourseDescriptionState createState() => _CourseDescriptionState();
}

class _CourseDescriptionState extends State<CourseDescription>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<CourseDescriptionBloc>().add(
          FetchCourseDetails(widget.course_id),
        );
    context.read<CourseDescriptionBloc>().add(
          FetchUserById(),
        );
    context.read<CourseDescriptionBloc>().add(
          FetchMaterialCountByCourseId(widget.course_id),
        );
    context.read<CourseDescriptionBloc>().add(
          FetchStudentCountByCourseId(widget.course_id),
        );
    context.read<CourseDescriptionBloc>().add(
          GetMaterialByCourseId(
            widget.course_id,
          ),
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDescriptionBloc, CourseDescriptionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppPallete.background,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<Lesson> lessons = state.addedMaterials
            .map((material) => Lesson(
                  id: material['id'],
                  title: material['title'],
                  orderNumber: material['order_number'],
                  materialFile: material['material_file'],
                ))
            .toList();

        return Scaffold(
          backgroundColor: AppPallete.background,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 15,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppPallete.background,
                              ),
                              child: Center(
                                child: Icon(
                                  Iconsax.arrow_left_2,
                                  color: AppPallete.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 15,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => MyCourses()),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppPallete.background,
                              ),
                              child: Center(
                                child: Icon(
                                  Iconsax.menu_1,
                                  color: AppPallete.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.lato(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.description,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppPallete.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              color: AppPallete.darkblue,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${state.progress}% completed',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: AppPallete.darkblue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Iconsax.folder_open,
                              color: AppPallete.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${state.materialCount} materials',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: AppPallete.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Iconsax.people,
                              color: AppPallete.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${state.subCount} students',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: AppPallete.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppPallete.black,
                    unselectedLabelColor: AppPallete.grey,
                    tabs: [
                      Tab(text: "About Course"),
                      Tab(text: "Lessons"),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AboutCourse(
                          title: widget.title,
                          description: widget.description,
                          what_will: widget.what_will,
                        ),
                        Lessons(lessons: lessons),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Define the Lesson class
class Lesson {
  final int id;
  final String title;
  final int orderNumber;
  final String materialFile;

  Lesson({
    required this.id,
    required this.title,
    required this.orderNumber,
    required this.materialFile,
  });
}

class Lessons extends StatelessWidget {
  final List<Lesson> lessons;

  const Lessons({
    required this.lessons,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 80,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppPallete.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppPallete.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Order: ${lesson.orderNumber}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppPallete.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AboutCourse extends StatelessWidget {
  final String title;
  final String description;
  final Map<String, dynamic> what_will;

  const AboutCourse({
    required this.title,
    required this.description,
    required this.what_will,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you will learn:',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPallete.black,
            ),
          ),
          SizedBox(height: 10),
          ...what_will.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppPallete.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
