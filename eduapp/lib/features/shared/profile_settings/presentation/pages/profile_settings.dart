import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/shared/profile_settings/data/dataSources/profile_picture_service.dart';
import 'package:eduapp/features/shared/profile_settings/data/dataSources/user_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;
  final int userId;

  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late int user_id;
  late String first_name = '';
  late String last_name = '';
  late String email = '';
  late String user_name = '';
  late String picture = '';

  Uint8List? _selectedImageBytes;
  File? _selectedImage;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserById();
    _submitForm();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        if (kIsWeb) {
          Uint8List bytes = await result.files.first.bytes!;
          setState(() {
            _selectedImageBytes = bytes;
          });
        } else {
          PlatformFile file = result.files.first;
          setState(() {
            _selectedImage = File(file.path!);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected image: ${result.files.first.name}'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  FormData _buildFormData() {
    return FormData.fromMap({
      'user_id': widget.userId,
      'image': _selectedImageBytes != null
          ? MultipartFile.fromBytes(_selectedImageBytes!, filename: 'image.jpg')
          : null,
    });
  }

  Future<void> _handleProfilePictureAction(String action) async {
    switch (action) {
      case 'upload':
        await _pickFile();
        await ProfilePicService.instance.postProfilePicture(_buildFormData());
        break;
      case 'update':
        await _pickFile();
        await ProfilePicService.instance.updateProfilePicture(_buildFormData());
        break;
      case 'delete':
        await ProfilePicService.instance.deleteProfilePicture(widget.userId);
        break;
    }
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  Future<void> fetchUserById() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');
      final accessToken = prefs.getString('access_token');

      if (user_id != null && accessToken != null) {
        final response =
            await UserService.instance.fetchUsersById(user_id, accessToken);

        setState(() {
          first_name = response['GetUserIDRow']['first_name'];
          last_name = response['GetUserIDRow']['last_name'];
          user_name = response['GetUserIDRow']['user_name'];
          email = response['GetUserIDRow']['email'];
          picture = response['GetUserIDRow']['picture'];

          firstNameController.text = first_name;
          lastNameController.text = last_name;
          userNameController.text = user_name;
          emailController.text = email;
        });
      } else {
        print('User ID or Access Token not found in SharedPreferences');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await UserService.instance.updateUser(
          user_id: widget.userId,
          first_name: firstNameController.text,
          last_name: lastNameController.text,
          user_name: userNameController.text,
          email: emailController.text,
        );

        if (response != null && response['statusCode'] == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Successful'),
                content: Text('Your profile has been updated successfully.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Failed'),
                content: Text(
                  'An error occurred during profile update. Please try again later.',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Failed'),
              content: Text(
                'An error occurred during profile update. Please try again later.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print('Update failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                          'Manage Profile',
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
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: Column(children: [
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 80,
                                      backgroundImage: NetworkImage(picture)
                                          as ImageProvider,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          showMenu(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            color: AppPallete.white,
                                            context: context,
                                            position: RelativeRect.fromLTRB(
                                                100, 100, 0, 0),
                                            items: [
                                              PopupMenuItem(
                                                value: 'upload',
                                                child: Text('Upload picture',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppPallete.black)),
                                              ),
                                              PopupMenuItem(
                                                value: 'update',
                                                child: Text('Update picture',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppPallete.black)),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete picture',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppPallete.black)),
                                              ),
                                            ],
                                          ).then((value) {
                                            if (value != null) {
                                              _handleProfilePictureAction(
                                                  value);
                                            }
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppPallete.white,
                                          radius: 25,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: AppPallete.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                TextFormField(
                                  controller: firstNameController,
                                  validator: _validateFirstName,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppPallete.lightgrey),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        AppPallete.lightgrey,
                                        BlendMode.srcIn,
                                      ),
                                      child: Icon(Iconsax.user),
                                    ),
                                    iconColor: AppPallete.lightgrey,
                                    labelText: 'First Name',
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppPallete.lightgrey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: lastNameController,
                                  validator: _validateLastName,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppPallete.lightgrey),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        AppPallete.lightgrey,
                                        BlendMode.srcIn,
                                      ),
                                      child: Icon(Iconsax.user),
                                    ),
                                    iconColor: AppPallete.lightgrey,
                                    labelText: 'Last Name',
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppPallete.lightgrey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: userNameController,
                                  validator: _validateUserName,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppPallete.lightgrey),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        AppPallete.lightgrey,
                                        BlendMode.srcIn,
                                      ),
                                      child: Icon(Iconsax.direct_right),
                                    ),
                                    iconColor: AppPallete.lightgrey,
                                    labelText: 'User Name',
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppPallete.lightgrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  validator: _validateEmail,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: AppPallete.lightgrey),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        AppPallete.lightgrey,
                                        BlendMode.srcIn,
                                      ),
                                      child: Icon(Iconsax.sms),
                                    ),
                                    labelText: 'Email',
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppPallete.lightgrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _submitForm();
                                    }
                                  },
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(
                                            100.0),
                                    side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(
                                        width: 0.0,
                                        color: AppPallete.darkblue,
                                      ),
                                    ),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.all(25.0),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppPallete.darkblue),
                                  ),
                                  child: Text(
                                    'SUBMIT',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: AppPallete.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ]),
              )
            ],
          ),
        ),
      )),
    );
  }
}
