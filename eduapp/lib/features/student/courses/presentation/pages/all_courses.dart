import 'package:eduapp/core/shared/widgets/bottom_navbar.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/student/courses/data/dataSources/catagory_service.dart';
import 'package:eduapp/features/student/courses/data/dataSources/count_service.dart';
import 'package:eduapp/features/student/courses/data/dataSources/course_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class StdAllCourses extends StatefulWidget {
  const StdAllCourses({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _StdAllCoursesState createState() => _StdAllCoursesState();
}

class _StdAllCoursesState extends State<StdAllCourses> {
  List<dynamic> _courses = [];
  List<dynamic> _filteredCourses = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'ALL COURSES';

  @override
  void initState() {
    super.initState();
    fetchCourses();
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCourses() async {
    try {
      final courseData = await CourseService.instance.fetchAllCourses();
      setState(() {
        _courses = courseData ?? [];
        _filterCourses();
      });
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _courses.where((course) {
        final title = course['title'].toLowerCase();
        final category = course['catagory'].toLowerCase();
        return title.contains(query) &&
            (_selectedCategory == 'ALL COURSES' ||
                category == _selectedCategory.toLowerCase());
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppPallete.background,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'All Courses',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // CustomSearchBar(
              //   controller: _searchController,
              //   onChanged: (value) => _filterCourses(),
              // ),
              SizedBox(height: 20),
              HorizontalListview(
                username: widget.username,
                accessToken: widget.accessToken,
                refreshToken: widget.refreshToken,
                selectedCategory: _selectedCategory,
                onSelectCategory: _selectCategory,
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: _filteredCourses.map((course) {
                      return CourseViewCard(
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class CourseViewCard extends StatefulWidget {
  final int course_id;
  final String description;
  final String image;
  final String title;
  final String catagory;
  final Map<String, dynamic> what_will;

  const CourseViewCard({
    required this.course_id,
    required this.image,
    required this.title,
    required this.catagory,
    required this.description,
    required this.what_will,
    Key? key,
  }) : super(key: key);

  @override
  State<CourseViewCard> createState() => _CourseViewCardState();
}

class _CourseViewCardState extends State<CourseViewCard> {
  int materialCount = 0;

  @override
  void initState() {
    super.initState();
    fetchMaterialCountByCourseId();
  }

  Future<void> fetchMaterialCountByCourseId() async {
    try {
      final response = await CountService.instance
          .getMaterialCountByCourseId(widget.course_id);

      if (response != null) {
        if (response is int) {
          setState(() {
            materialCount = response;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPallete.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: widget.image.isNotEmpty
                      ? NetworkImage(widget.image)
                      : AssetImage('/logos/logo.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
                top: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppPallete.background2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.catagory.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppPallete.lightgrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.video_play,
                              size: 15, color: AppPallete.darkblue),
                          SizedBox(width: 5),
                          Text(
                            '${materialCount.toString()} lessons',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppPallete.lightgrey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(Iconsax.document,
                              size: 15, color: AppPallete.darkblue),
                          SizedBox(width: 5),
                          Text(
                            'Certificate',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppPallete.lightgrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => CourseDescription(
                            //       course_id: widget.course_id,
                            //       image: widget.image,
                            //       title: widget.title,
                            //       catagory: widget.catagory,
                            //       description: widget.description,
                            //       what_will: widget.what_will,
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
                              'View Course'.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.white,
                              ),
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
  }
}

class HorizontalListview extends StatefulWidget {
  const HorizontalListview({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.selectedCategory,
    required this.onSelectCategory,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  @override
  _HorizontalListviewState createState() => _HorizontalListviewState();
}

class _HorizontalListviewState extends State<HorizontalListview> {
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
        _categories = ['ALL COURSES', ...categories];
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _categories = ['ALL COURSES'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == widget.selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () => widget.onSelectCategory(category),
                    child: CategoryChip(
                      label: category,
                      isSelected: isSelected,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryChip({
    Key? key,
    required this.label,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? AppPallete.blue : AppPallete.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppPallete.blue, width: 2),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isSelected ? AppPallete.white : AppPallete.blue,
        ),
      ),
    );
  }
}
