import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/shared/auth/presentation/pages/login_page.dart';
import 'package:eduapp/features/shared/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:eduapp/features/shared/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:eduapp/features/shared/forgot_password/presentation/bloc/forgot_password_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } else if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Reset Password',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: AppPallete.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Enter a new password for your account',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: AppPallete.black,
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
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
                                child: const Icon(Iconsax.lock),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash,
                                  color: AppPallete.lightgrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              labelText: 'New Password',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppPallete.lightgrey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
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
                                child: const Icon(Iconsax.lock),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash,
                                  color: AppPallete.lightgrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppPallete.lightgrey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          OutlinedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ForgotPasswordBloc>().add(
                                      ResetPasswordEvent(
                                        email: widget.email,
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                      ),
                                    );
                              }
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
                                const EdgeInsets.all(25.0),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppPallete.darkblue),
                            ),
                            child: Text(
                              'RESET',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: AppPallete.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
