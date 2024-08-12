import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/shared/forgot_password/data/dataSources/email_service.dart';
import 'package:eduapp/features/shared/forgot_password/presentation/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CheckEmail extends StatefulWidget {
  const CheckEmail({Key? key}) : super(key: key);

  @override
  _CheckEmailState createState() => _CheckEmailState();
}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  } else if (!value.contains('@')) {
    return 'Please enter a valid email';
  }
  return null;
}

class _CheckEmailState extends State<CheckEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  Future<void> _sendEmailVerification() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      try {
        Map<String, dynamic> response =
            await EmailService.instance.checkEmail(email);

        // Check if the response contains the expected success message
        if (response['messege'] == 'Email found') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(email: email),
            ),
          );
        } else {
          // Handle the case where the message is different from expected
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Email verification failed: ${response['messege']}')),
          );
        }
      } catch (e) {
        // Catch any exceptions that occur during the request
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: AppPallete.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: AppPallete.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Enter the email address associated with your account',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: AppPallete.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(10)),
                            Container(
                              child: TextFormField(
                                controller: emailController,
                                validator: _validateEmail,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: AppPallete.lightgrey),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      AppPallete.lightgrey,
                                      BlendMode.srcIn,
                                    ),
                                    child: Icon(Iconsax.message),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppPallete.lightgrey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                await _sendEmailVerification();
                              },
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(100.0),
                                side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(
                                    width: MediaQuery.of(context).size.width,
                                    color: AppPallete.darkblue,
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(25.0),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppPallete.darkblue),
                              ),
                              child: Text(
                                'SEND',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppPallete.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
