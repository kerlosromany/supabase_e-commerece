import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../admin/widgets/loading_container.dart';
import 'login_screen.dart';
import '../widgets/address_field.dart';
import '../widgets/location_handler.dart';
import '../widgets/name_field.dart';
import '../widgets/phone_field.dart';
import '../../../core/consts/app_calculates.dart';
import '../../../core/helpers/functions.dart';
import '../../../core/helpers/temporary_vars.dart';

import '../../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  double? userLat = 0.0;
  double? userLong = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errMGS = "";

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  bool _loading = true;

  /// Called once a user id is received
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });
    log("${TemporaryVars.lat}");
    log("${TemporaryVars.lng}");

    try {
      final userId = supabase.auth.currentSession!.user.id;
      log("userId =====================> $userId");
      final data =
          await supabase.from('users').select().eq('userId', userId).single();
      _nameController.text = (data['name'] ?? '') as String;
      _addressController.text = (data['address'] ?? '') as String;
      _phoneController.text = (data['phoneNumber'] ?? '') as String;
      userLat = data["lat"];
      userLong = data["long"];
    } on PostgrestException catch (_) {
      if (mounted) {
        setState(() {
          errMGS = "حدث خطأ ما حاول مرة اخري فى وقت لاحق";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("حدث خطأ ما حاول مرة اخري فى وقت لاحق")));
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errMGS = "حدث خطأ ما حاول مرة اخري فى وقت لاحق";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("حدث خطأ ما حاول مرة اخري فى وقت لاحق")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps Update button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    final user = supabase.auth.currentUser;
    log("=====================> ${user?.id}");
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("لم يتم العثور على المستخدم")));
      }
      return;
    }

    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            "phoneNumber": _phoneController.text,
            "name": _nameController.text,
            "address": _addressController.text,
          },
        ),
      );
      await supabase.from('users').update({
        "name": _nameController.text,
        "address": _addressController.text,
        "phoneNumber": _phoneController.text,
        "lat" : TemporaryVars.lat ?? userLat,
        "long" : TemporaryVars.lng?? userLong,
      }).eq("userId", user.id);

      if (mounted) {
        AppFunctions.successShowToast(msg: "تم تعديل البيانات بنجاح");
      }
    } on PostgrestException catch (_) {
      AppFunctions.errorShowToast(msg: "حدث خطأ ما حاول مرة اخري فى وقت لاحق");
    } catch (error) {
      AppFunctions.errorShowToast(msg: "حدث خطأ ما حاول مرة اخري فى وقت لاحق");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          actions: errMGS != ""
              ? null
              : [
                  TextButton(
                    onPressed: () async {
                      if (!_loading) {
                        // Show the confirmation dialog
                        bool confirmSignOut =
                            await showSigningOutDialog(context);

                        // If user confirms, call sign out function
                        if (confirmSignOut == true) {
                          await _signOut();
                        }
                      }
                    },
                    child: const Text(
                      "تسجيل\nخروج",
                      style: TextStyle(color: Colors.red),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
        ),
        body: errMGS != ""
            ? Center(
                child: Text(
                  errMGS,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          NameTextField(controller: _nameController),
                          SizedBox(height: SizeHelper.h15),
                          AddressTextField(controller: _addressController),
                          SizedBox(height: SizeHelper.h15),
                          PhoneTextField(controller: _phoneController),
                          SizedBox(height: SizeHelper.h15),
                          if (userLat == null) const LocationHandlerWidget(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _updateProfile,
                              child: const Text('تعديل البيانات'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _loading ? const LoadingContainer() : const SizedBox.shrink()
                ],
              ),
      ),
    );
  }

  Future<dynamic> showSigningOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    try {
      setState(() {
        _loading = true;
      });
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false);
      }
    } on AuthException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("فشل في تسجيل الخروج")));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("فشل في تسجيل الخروج")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
