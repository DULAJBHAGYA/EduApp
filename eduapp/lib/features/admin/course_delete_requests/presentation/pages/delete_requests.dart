import 'package:eduapp/core/shared/widgets/nav_drawer.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/course_delete_requests/data/dataSources/course_service.dart';
import 'package:eduapp/features/admin/course_delete_requests/presentation/bloc/delete_requests_bloc.dart';
import 'package:eduapp/features/admin/course_delete_requests/presentation/bloc/delete_requests_event.dart';
import 'package:eduapp/features/admin/course_delete_requests/presentation/bloc/delete_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class DeleteRequests extends StatelessWidget {
  const DeleteRequests({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeleteRequestsBloc()..add(FetchDeleteRequests()),
      child: DeleteRequestsView(),
    );
  }
}

class DeleteRequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: AppPallete.background,
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: AppPallete.background,
        elevation: 0,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Icon(Iconsax.arrow_left_2, size: 30, color: AppPallete.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  'Delete Requests',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<DeleteRequestsBloc, DeleteRequestsState>(
                builder: (context, state) {
                  if (state is DeleteRequestsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DeleteRequestsLoaded) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: state.deleteRequests.map((delrequests) {
                          return DeleteRequestCard(
                            course_id: delrequests['course_id'] ?? 0,
                            request_id: delrequests['request_id'] ?? 0,
                            user_name: delrequests['user_name'] ?? '',
                            first_name: delrequests['first_name'] ?? '',
                            last_name: delrequests['last_name'] ?? '',
                          );
                        }).toList(),
                      ),
                    );
                  } else if (state is DeleteRequestsError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteRequestCard extends StatefulWidget {
  final int course_id;
  final String user_name;
  final String first_name;
  final String last_name;
  final int request_id;

  const DeleteRequestCard({
    required this.course_id,
    required this.user_name,
    required this.first_name,
    required this.last_name,
    required this.request_id,
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteRequestCard> createState() => _DeleteRequestCardState();
}

class _DeleteRequestCardState extends State<DeleteRequestCard> {
  String? courseTitle;

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    try {
      final details =
          await CourseService.instance.fetchCourseById(widget.course_id);
      setState(() {
        courseTitle = details['title'];
      });
    } catch (e) {
      print('Error fetching course details: $e');
      setState(() {
        courseTitle = 'Unknown Course';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPallete.white,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (courseTitle != null)
            Text(
              '${widget.user_name} asks to delete $courseTitle?',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppPallete.black),
            )
          else
            CircularProgressIndicator(),
          Row(
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<DeleteRequestsBloc>().add(
                        ConfirmDeleteRequest(widget.request_id),
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: AppPallete.darkblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('ACCEPT',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.white)),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<DeleteRequestsBloc>().add(
                        ConfirmDeleteRequest(widget.request_id),
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: AppPallete.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('DECLINE',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
