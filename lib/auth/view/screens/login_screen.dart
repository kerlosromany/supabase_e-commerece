import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../admin/widgets/loading_container.dart';
import 'sign_up_screen.dart';
import '../widgets/auth_text.dart';
import '../widgets/email_field.dart';
import '../widgets/logo_show.dart';
import '../widgets/password_field.dart';
import '../../../core/consts/app_calculates.dart';
import '../../../core/helpers/functions.dart';
import '../../../home/screens/main_dashboard_screen.dart';
import '../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to perform login
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Attempt to sign in with Supabase
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        AppFunctions.errorShowToast(msg: "فشل تسجيل الدخول");
      } else {
        AppFunctions.successShowToast(msg: "تم تسجيل الدخول بنجاح");
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
              (route) => false);
        }
      }
    } on AuthException catch (e) {
      log(e.toString());
      AppFunctions.errorShowToast(msg: "فشل تسجيل الدخول");
    } catch (e) {
      log(e.toString());
      AppFunctions.errorShowToast(msg: "فشل تسجيل الدخول");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeHelper.h40),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: AuthText(txt: "تسجيل الدخول"),
                      ),
                      SizedBox(height: SizeHelper.h20),
                      const LogoShow(),
                      SizedBox(height: SizeHelper.h40),
                      EmailTextField(controller: _emailController),
                      SizedBox(height: SizeHelper.h20),
                      PasswordTextField(controller: _passwordController),
                      SizedBox(height: SizeHelper.h20),
                      SizedBox(height: SizeHelper.h20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _loginUser,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              "تسجيل الدخول",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeHelper.h15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: const Text(
                              'انشاء حساب',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const Text(
                            "ليس لديك حساب؟",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _isLoading ? const LoadingContainer() : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
