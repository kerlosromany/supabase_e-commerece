import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../admin/widgets/loading_container.dart';
import '../widgets/address_field.dart';
import '../widgets/area_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text.dart';
import '../widgets/email_field.dart';
import '../widgets/location_handler.dart';
import '../widgets/logo_show.dart';
import '../widgets/name_field.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_field.dart';
import '../widgets/switch_registeration.dart';
import '../../view_model/auth_cubit.dart';
import '../../view_model/auth_states.dart';
import '../../../core/consts/app_calculates.dart';
import '../../../core/helpers/functions.dart';
import '../../../home/screens/main_dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthenticatinState>(
        listener: (context, state) {
          if (state is ValidateInputsError) {
            AppFunctions.errorShowToast(msg: state.msgError);
          }
          if (state is RegisterationSuccess) {
            AppFunctions.successShowToast(msg: state.msgSuccess);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
                (route) => false);
          }
          if (state is RegisterationFailed) {
            AppFunctions.errorShowToast(msg: state.msgError);
          }
        },
        builder: (context, state) {
          AuthCubit authCubit = context.read<AuthCubit>();

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const LocationHandlerWidget(),
                            SizedBox(height: SizeHelper.h40),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: AuthText(txt: 'قم بانشاء حساب'),
                            ),
                            SizedBox(height: SizeHelper.h20),
                            const LogoShow(),
                            SizedBox(height: SizeHelper.h40),
                            NameTextField(controller: authCubit.nameController),
                            SizedBox(height: SizeHelper.h20),
                            EmailTextField(
                                controller: authCubit.emailController),
                            SizedBox(height: SizeHelper.h20),
                            PasswordTextField(
                                controller: authCubit.passwordController),
                            SizedBox(height: SizeHelper.h20),
                            AddressTextField(
                                controller: authCubit.addressController),
                            SizedBox(height: SizeHelper.h20),
                            PhoneTextField(
                                controller: authCubit.phoneController),
                            SizedBox(height: SizeHelper.h20),
                            // Dropdown for Area Selection
                            DropdownButtonFormField<String>(
                              value: authCubit.selectedArea,
                              hint: const Text('اختر المنطقة'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'shoubra',
                                  child: Text('شبرا'),
                                ),
                                DropdownMenuItem(
                                  value: 'wst_el_balad',
                                  child: Text('وسط البلد'),
                                ),
                                DropdownMenuItem(
                                  value: 'banha',
                                  child: Text('بنها'),
                                ),
                                DropdownMenuItem(
                                  value: 'other',
                                  child: Text('أخرى'),
                                ),
                              ],
                              onChanged: (value) {
                                authCubit.changeArea(value!);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يجب اختيار المنطقة';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: SizeHelper.h20),

                            if (authCubit.isOtherAreaVisible)
                              AreaFormField(
                                controller: authCubit.areaController,
                                isVisible: authCubit.isOtherAreaVisible,
                              ),
                            SizedBox(height: SizeHelper.h30),
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: AuthButton(
                                      buttonText: "تسجيل دخول",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          authCubit.registerUser();
                                        }
                                      },
                                    ),
                                  ),
                            SizedBox(height: SizeHelper.h25),
                            const SwitchRegisteration(),
                            SizedBox(height: SizeHelper.h30),
                          ],
                        ),
                      ),
                      state is AuthLoading
                          ? const LoadingContainer()
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
