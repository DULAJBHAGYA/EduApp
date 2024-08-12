import 'package:eduapp/core/shared/widgets/nav_drawer.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/submissions/presentation/bloc/submissions_bloc.dart';
import 'package:eduapp/features/admin/submissions/presentation/bloc/submissions_event.dart';
import 'package:eduapp/features/admin/submissions/presentation/bloc/submissions_state.dart';
import 'package:eduapp/features/admin/submissions/presentation/pages/add_marks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class Submissions extends StatelessWidget {
  const Submissions({
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
      create: (_) => SubmissionsBloc()..add(FetchSubmissions()),
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
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
              Scaffold.of(context).openDrawer();
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
                    'Submissions',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<SubmissionsBloc, SubmissionsState>(
                  builder: (context, state) {
                    if (state is SubmissionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SubmissionsLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: state.submissions.map((submission) {
                            return AdminSubmissionView(
                              submission_id: submission['submission_id'] ?? {},
                              assignment_id: submission['assignment_id'] ?? 0,
                              grade: submission['grade'] ?? 0,
                              resource: submission['resource'] ?? '',
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is SubmissionsError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No submissions found.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminSubmissionView extends StatelessWidget {
  final int submission_id;
  final int assignment_id;
  final int grade;
  final String resource;

  const AdminSubmissionView({
    required this.submission_id,
    required this.assignment_id,
    required this.grade,
    required this.resource,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMarks(
                      username: '',
                      accessToken: '',
                      refreshToken: '',
                      grade: grade,
                      resource: resource,
                    )));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppPallete.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submission ID : $submission_id',
                  style: GoogleFonts.poppins(
                      color: AppPallete.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Course Name',
                  style: GoogleFonts.poppins(
                      color: AppPallete.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Assignment ID : $assignment_id',
                  style: GoogleFonts.poppins(
                      color: AppPallete.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
