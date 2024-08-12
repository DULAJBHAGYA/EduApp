import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/shared/password_change/presentation/bloc/password_change_bloc.dart';
import 'package:eduapp/features/shared/password_change/presentation/bloc/password_change_event.dart';
import 'package:eduapp/features/shared/password_change/presentation/bloc/password_change_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.user_id,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;
  final int user_id;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController currentpasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    currentpasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordChangeBloc(),
      child: Scaffold(
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
          padding: const EdgeInsets.all(20),
          child: BlocListener<PasswordChangeBloc, PasswordChangeState>(
            listener: (context, state) {
              if (state is PasswordChangeSuccess) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Password Change Successful'),
                      content:
                          Text('You have successfully changed your password.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is PasswordChangeFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Password Change Unsuccessful'),
                      content: Text(state.error),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // UI Code
                  SizedBox(height: 40),
                  TextFormField(
                    controller: currentpasswordController,
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppPallete.lightgrey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppPallete.lightgrey,
                          BlendMode.srcIn,
                        ),
                        child: Icon(Iconsax.password_check),
                      ),
                      labelText: 'Current Password',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppPallete.lightgrey,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            AppPallete.lightgrey,
                            BlendMode.srcIn,
                          ),
                          child: Icon(
                            _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppPallete.lightgrey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppPallete.lightgrey,
                          BlendMode.srcIn,
                        ),
                        child: Icon(Iconsax.password_check),
                      ),
                      labelText: 'New Password',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppPallete.lightgrey,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            AppPallete.lightgrey,
                            BlendMode.srcIn,
                          ),
                          child: Icon(
                            _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: AppPallete.lightgrey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          AppPallete.lightgrey,
                          BlendMode.srcIn,
                        ),
                        child: Icon(Iconsax.password_check),
                      ),
                      labelText: 'Confirm Password',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppPallete.lightgrey,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            AppPallete.lightgrey,
                            BlendMode.srcIn,
                          ),
                          child: Icon(
                            _obscureConfirmPassword
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<PasswordChangeBloc>(context).add(
                            SubmitPasswordChange(
                              userId: widget.user_id,
                              currentPassword: currentpasswordController.text,
                              newPassword: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(100.0),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(width: 0.0, color: AppPallete.darkblue),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(25.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppPallete.darkblue),
                      ),
                      child: Text(
                        'CHANGE PASSWORD',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppPallete.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
