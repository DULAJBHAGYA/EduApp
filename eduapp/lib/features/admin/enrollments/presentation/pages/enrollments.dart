import 'package:eduapp/core/shared/widgets/nav_drawer.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/enrollments/presentation/bloc/enrollments_bloc.dart';
import 'package:eduapp/features/admin/enrollments/presentation/bloc/enrollments_event.dart';
import 'package:eduapp/features/admin/enrollments/presentation/bloc/enrollments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class Enrollments extends StatelessWidget {
  const Enrollments({
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
      create: (context) => EnrollmentsBloc()..add(FetchEnrollments()),
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
                    'Enrollments',
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
                child: BlocBuilder<EnrollmentsBloc, EnrollmentsState>(
                  builder: (context, state) {
                    if (state is EnrollmentsLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is EnrollmentsLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: state.enrollments.map((enrollment) {
                            return EnrollmentCard(
                              course_id: enrollment['course_id'] ?? 0,
                              user_id: enrollment['user_id'] ?? 0,
                              title: enrollment['title'] ?? '',
                              first_name: enrollment['first_name'] ?? '',
                              last_name: enrollment['last_name'] ?? '',
                              image: enrollment['image'] ?? '',
                              onRemove: (userId, courseId) {
                                context.read<EnrollmentsBloc>().add(
                                      AcceptEnrollRequest(userId, courseId),
                                    );
                              },
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is EnrollmentsError) {
                      return Center(child: Text(state.error));
                    }
                    return Container();
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

class EnrollmentCard extends StatelessWidget {
  final int course_id;
  final String title;
  final String first_name;
  final String last_name;
  final String image;
  final int user_id;
  final Function(int, int) onRemove;

  const EnrollmentCard({
    required this.course_id,
    required this.image,
    required this.title,
    required this.first_name,
    required this.last_name,
    required this.user_id,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  Future<void> _acceptEnrollRequest(BuildContext context) async {
    context
        .read<EnrollmentsBloc>()
        .add(AcceptEnrollRequest(user_id, course_id));
  }

  Future<void> _declineEnrollRequest(BuildContext context) async {
    context
        .read<EnrollmentsBloc>()
        .add(DeclineEnrollRequest(user_id, course_id));
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  first_name + ' ' + last_name,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black),
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: AppPallete.black),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _acceptEnrollRequest(context);
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
                        _declineEnrollRequest(context);
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
          ),
        ],
      ),
    );
  }
}
