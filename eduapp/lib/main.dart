import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_bloc.dart';
import 'package:eduapp/features/admin/add_courses/presentation/bloc/add_courses_event.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_event.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
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
import 'package:eduapp/features/student/course_desc/presentation/bloc/course_desc_bloc.dart';
import 'package:eduapp/features/admin/new_course/presentation/bloc/new_course_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          create: (_) => CourseDescriptionBloc(),
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
          create: (_) => NewCourseBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
