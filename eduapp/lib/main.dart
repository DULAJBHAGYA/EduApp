<<<<<<< Updated upstream
import 'package:eduapp/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

=======
import 'package:eduapp/features/admin/add_admins/presentation/bloc/add_admin_bloc.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_bloc.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_event.dart';
import 'package:eduapp/features/admin/add_material/presentation/bloc/add_materials_bloc.dart';
import 'package:eduapp/features/admin/add_material/presentation/bloc/add_materials_event.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_event.dart';
import 'package:eduapp/features/admin/course_delete_requests/presentation/bloc/delete_requests_bloc.dart';
import 'package:eduapp/features/admin/course_delete_requests/presentation/bloc/delete_requests_event.dart';
import 'package:eduapp/features/admin/enrollments/presentation/bloc/enrollments_bloc.dart';
import 'package:eduapp/features/admin/enrollments/presentation/bloc/enrollments_event.dart';
import 'package:eduapp/features/admin/new_admin/presentation/bloc/new_admin_bloc.dart';
import 'package:eduapp/features/admin/submissions/presentation/bloc/submissions_bloc.dart';
import 'package:eduapp/features/admin/submissions/presentation/bloc/submissions_event.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:eduapp/features/shared/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:eduapp/features/shared/password_change/presentation/bloc/password_change_bloc.dart';
import 'package:eduapp/features/student/profile/presentation/bloc/profile_bloc.dart';
import 'package:eduapp/features/student/profile/presentation/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eduapp/features/admin/courses/presentation/bloc/courses_bloc.dart';
import 'package:eduapp/features/admin/courses/presentation/bloc/courses_event.dart';
import 'package:eduapp/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:eduapp/features/student/courses/presentation/bloc/course_bloc.dart';
import 'package:eduapp/features/student/courses/presentation/bloc/course_event.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_event.dart';
import 'package:eduapp/features/admin/new_course/presentation/bloc/new_course_bloc.dart';

>>>>>>> Stashed changes
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(debugShowCheckedModeBanner: false,
=======
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
        BlocProvider(
          create: (_) => CourseBloc()..add(FetchCourses()),
        ),
        BlocProvider(
          create: (_) => AdminCourseBloc()..add(FetchAllCourses()),
        ),
        BlocProvider(
          create: (context) {
            final myCoursesBloc = MyCoursesBloc();
            myCoursesBloc.add(FetchOngoingCourses());
            myCoursesBloc.add(FetchCompletedCourses());
            return myCoursesBloc;
          },
        ),
        BlocProvider(
          create: (_) => ProfileBloc()..add(FetchUserById()),
        ),
        BlocProvider(
          create: (_) => AdminProfileBloc()..add(FetchAdminById()),
        ),
        BlocProvider(
          create: (_) => AddCoursesBloc()..add(FetchCoursesById()),
        ),
        BlocProvider(
          create: (_) =>
              AddMaterialsBloc()..add(FetchMaterialsByCourseId(course_id: 0)),
        ),
        BlocProvider(
          create: (_) => NewCourseBloc(),
        ),
        BlocProvider(
          create: (_) => AddAdminBloc(),
        ),
        BlocProvider(
          create: (_) => NewAdminBloc(),
        ),
        BlocProvider(
          create: (_) => PasswordChangeBloc(),
        ),
        BlocProvider(
          create: (_) => ForgotPasswordBloc(),
        ),
        BlocProvider(
          create: (_) => EnrollmentsBloc()..add(FetchEnrollments()),
        ),
        BlocProvider(
          create: (_) => SubmissionsBloc()..add(FetchSubmissions()),
        ),
        BlocProvider(
          create: (_) => DeleteRequestsBloc()..add(FetchDeleteRequests()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
>>>>>>> Stashed changes
        title: 'EduApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login(),
      ),
    );
  }
}
