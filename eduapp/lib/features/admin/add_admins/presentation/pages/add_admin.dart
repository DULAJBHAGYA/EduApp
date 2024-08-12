import 'package:eduapp/core/shared/widgets/nav_drawer.dart';
import 'package:eduapp/core/shared/widgets/search_bar.dart';
import 'package:eduapp/core/theme/appPallete.dart';
import 'package:eduapp/features/admin/add_admins/data/dataSources/admin_service.dart';
import 'package:eduapp/features/admin/add_admins/data/dataSources/user_service.dart';
import 'package:eduapp/features/admin/add_admins/presentation/bloc/add_admin_bloc.dart';
import 'package:eduapp/features/admin/add_admins/presentation/bloc/add_admin_state.dart';
import 'package:eduapp/features/admin/new_admin/presentation/pages/new_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../bloc/add_admin_event.dart';

class Admins extends StatefulWidget {
  const Admins({
    Key? key,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  final String username;
  final String accessToken;
  final String refreshToken;

  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> with SingleTickerProviderStateMixin {
  late AddAdminBloc _addAdminBloc;
  List<dynamic> _admins = [];
  List<dynamic> _filteredAdmins = [];
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _filterAdmins() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAdmins = _admins.where((admin) {
        final firstName = admin['first_name'].toLowerCase();
        final lastName = admin['last_name'].toLowerCase();
        return firstName.contains(query) || lastName.contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _addAdminBloc = BlocProvider.of<AddAdminBloc>(context);
    _addAdminBloc.add(FetchAdmins());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      key: _scaffoldKey,
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
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: BlocListener<AddAdminBloc, AddAdminState>(
        listener: (context, state) {
          if (state is AdminsLoaded) {
            setState(() {
              _admins = state.admins;
              _filterAdmins(); // Update the filtered list when admins are loaded
            });
          }
        },
        child: BlocBuilder<AddAdminBloc, AddAdminState>(
          builder: (context, state) {
            if (state is AdminsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AdminsError) {
              return Center(child: Text(state.message));
            } else {
              return _buildAdminList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdminList() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
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
              ),
              SizedBox(width: 10),
              Text(
                'Admins',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAdmin()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppPallete.darkblue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.all(10.0),
                      ),
                    ),
                    child: Text(
                      'ADD NEW ADMIN',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomSearchBar(
                  controller: _searchController,
                  onChanged: (value) => _filterAdmins(),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _filteredAdmins.isEmpty
                          ? [Center(child: Text('No admins found'))]
                          : _filteredAdmins.map((admin) {
                              return AdminDisplayCard(
                                user_id: admin['user_id'],
                                picture: admin['picture'] ?? '',
                                user_name: admin['user_name'],
                                first_name: admin['first_name'],
                                last_name: admin['last_name'],
                                email: admin['email'],
                                onUpdate: () => _addAdminBloc.add(
                                    FetchAdmins()), // Ensure data is refreshed
                              );
                            }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDisplayCard extends StatefulWidget {
  final String user_name;
  final String first_name;
  final String last_name;
  final String email;
  final String picture;
  final int user_id;
  final VoidCallback onUpdate;

  const AdminDisplayCard({
    required this.user_name,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.picture,
    required this.user_id,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  _AdminDisplayCardState createState() => _AdminDisplayCardState();
}

class _AdminDisplayCardState extends State<AdminDisplayCard> {
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditAdminForm(
          user_name: widget.user_name,
          fullName: widget.first_name + ' ' + widget.last_name,
          email: widget.email,
          onUpdate: widget.onUpdate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPallete.background,
      height: 200,
      child: Card(
        color: AppPallete.white,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.picture),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        widget.first_name + ' ' + widget.last_name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user_name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            widget.email,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete this user?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await UserService.instance
                                        .deleteUser(widget.user_id);
                                    // Optionally, you can show a success message or perform any other action after deletion
                                  } catch (e) {
                                    // Handle error if deletion fails
                                    print('Error deleting user: $e');
                                  }
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppPallete.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'DELETE ADMIN',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//edit admin form widget
class EditAdminForm extends StatefulWidget {
  final String user_name;
  final String fullName;
  final String email;
  final VoidCallback onUpdate;

  const EditAdminForm({
    required this.user_name,
    required this.fullName,
    required this.email,
    required this.onUpdate,
  });

  @override
  _EditAdminFormState createState() => _EditAdminFormState();
}

class _EditAdminFormState extends State<EditAdminForm> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _userNameController = TextEditingController(text: widget.user_name);
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

//update admin Method
  Future<void> _updateAdmin() async {
    try {
      await AdminService.instance.updateAdmin(
        _emailController.text,
        _fullNameController.text,
        _passwordController.text,
        _userNameController.text,
      );

      widget.onUpdate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Admin updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error updating admin: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update admin. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Admin'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _updateAdmin,
          child: Text('Save'),
        ),
      ],
    );
  }
}
