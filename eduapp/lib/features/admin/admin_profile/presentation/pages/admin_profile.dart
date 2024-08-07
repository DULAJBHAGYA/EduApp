import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:eduapp/features/admin/admin_profile/presentation/bloc/admin_profile_event.dart';
import 'package:eduapp/features/admin/home/presentation/pages/admin_home.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:eduapp/features/student/profile/presentation/bloc/profile_bloc.dart';
import 'package:eduapp/features/student/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProfileBloc()..add(FetchAdminById()),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppPallete.background,
          drawer: NavDrawer(),
          appBar: AppBar(
            backgroundColor: AppPallete.background,
            elevation: 0,
            leading: IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Icon(Iconsax.menu_1, size: 30, color: AppPallete.black),
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.error.isNotEmpty) {
                  return Center(child: Text(state.error));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'My Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppPallete.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              radius: 120,
                              backgroundImage: NetworkImage(state.picture),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.userName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: AppPallete.black,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  state.email,
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: AppPallete.lightgrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.firstName,
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              color: AppPallete.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            state.lastName,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              color: AppPallete.lightgrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: AppPallete.black,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getInt('user_id');

                          if (userId != null) {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => EditProfile(
                            //       username: username,
                            //       accessToken: accessToken,
                            //       refreshToken: refreshToken,
                            //       userId: userId,
                            //     ),
                            //   ),
                            // );
                          } else {
                            print('User ID not found in SharedPreferences');
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppPallete.background,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppPallete.background2,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Iconsax.user,
                                        color: AppPallete.black,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Manage Profile',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppPallete.black),
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppPallete.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Align(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Iconsax.arrow_right_3,
                                            size: 20,
                                            color: AppPallete.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Settings',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: AppPallete.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppPallete.background,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppPallete
                                                          .background2,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Iconsax
                                                          .notification_status4,
                                                      color: AppPallete.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Notifications',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppPallete.black),
                                              ),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppPallete.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Align(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Iconsax.arrow_right_3,
                                                      size: 20,
                                                      color: AppPallete.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final user_id = prefs.getInt('user_id');

                                    if (user_id != null) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         Studentchangepassword(
                                      //       username: widget.username,
                                      //       accessToken: widget.accessToken,
                                      //       refreshToken: widget.refreshToken,
                                      //       user_id: user_id,
                                      //     ),
                                      //   ),
                                      // );
                                    } else {
                                      // Handle the case where user_id is null
                                      print(
                                          'User ID not found in SharedPreferences');
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppPallete.background,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: AppPallete
                                                          .background2,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Iconsax.password_check,
                                                      color: AppPallete.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Change Password',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppPallete.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppPallete.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Align(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Iconsax.arrow_right_3,
                                                      size: 20,
                                                      color: AppPallete.black,
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await clearAccessToken();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppPallete.darkblue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 10, left: 10),
                              child: Text(
                                'SIGN OUT',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppPallete.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
