import 'package:eduapp/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:eduapp/features/student/courses/presentation/bloc/course_bloc.dart';
import 'package:eduapp/features/student/courses/presentation/bloc/course_event.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:eduapp/features/student/my_courses/presentation/bloc/my_courses_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          create: (context) {
            final myCoursesBloc = MyCoursesBloc();
            // Fetch ongoing courses first
            myCoursesBloc.add(FetchOngoingCourses());
            return myCoursesBloc;
          },
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
