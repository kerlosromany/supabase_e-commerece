import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'auth_states.dart';
import '../../core/helpers/temporary_vars.dart';

import '../../main.dart';

class AuthCubit extends Cubit<AuthenticatinState> {

  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  // This is where you dispose of any resources
  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    phoneController.dispose();

    return super.close();
  }

  ////////////////////////////////////// variables //////////////////////////////////////
  // final _picker = ImagePicker();
  // XFile? image;

  // /// Function to pick image with gallery
  // Future<void> pickImageWithGallery() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     image = pickedFile;
  //     emit(PickImageSuccess());
  //   } catch (e) {
  //     log("pickImageWithGallery ===> \t\t ${e.toString()}");
  //     emit(PickImageError(msgError: e.toString()));
  //   }
  // }

  // /// Function to pick image with camera
  // Future<void> pickImageWithCamera() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //     image = pickedFile;
  //     emit(PickImageSuccess());
  //   } catch (e) {
  //     log("pickImageWithCamera ===> \t\t ${e.toString()}");
  //     emit(PickImageError(msgError: e.toString()));
  //   }
  // }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final areaController = TextEditingController();

  /// Function to validate form inputs
  bool validateInputs() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty) {
      emit(ValidateInputsError(msgError: 'قم بادخال جميع البيانات المطلوبة'));
      return false;
    }
    return true;
  }

  /// Function to sign up the user using Supabase Authentication
  Future<AuthResponse?> signUpUser() async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          "name": nameController.text,
          "address": addressController.text,
          "phoneNumber": phoneController.text,
        },
      );

      if (authResponse.user == null) {
        emit(RegisterationFailed(msgError: 'فشل انشاء حسابك'));
        return null;
      }
      return authResponse;
    } on PostgrestException catch (e) {
      emit(RegisterationFailed(msgError: 'فشل انشاء حسابك'));
      log("signUpUser PostgrestException ===> \t\t ${e.toString()}");
      return null;
    } catch (e) {
      emit(RegisterationFailed(msgError: 'فشل انشاء حسابك'));
      log("signUpUser catch ===> \t\t ${e.toString()}");
      return null;
    }
  }

  /// Function to save user data to Supabase 'users' table
  Future<void> saveUserToDatabase(UserModel user) async {
    try {
      await supabase.from('users').insert(user.toJson());
      emit(RegisterationSuccess(msgSuccess: 'تم انشاء حسابك بنجاح'));
    } on PostgrestException catch (e) {
      emit(RegisterationFailed(msgError: 'فشل انشاء حسابك'));
      log("saveUserToDatabase PostgrestException ===> \t\t ${e.toString()}");
    } catch (e) {
      emit(RegisterationFailed(msgError: 'فشل انشاء حسابك'));
      log("saveUserToDatabase catch ===> \t\t ${e.toString()}");
    }
  }

  /// Main function to register the user
  Future<void> registerUser() async {
    emit(AuthLoading());

    if (!validateInputs()) return;

    final authResponse = await signUpUser();
    if (authResponse == null) return;

    final newUser = UserModel(
      name: nameController.text,
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      phoneNumber: phoneController.text,
      userId: authResponse.user!.id,
      area: isOtherAreaVisible ? areaController.text : selectedArea,
      lat: TemporaryVars.lat,
      long: TemporaryVars.lng,
    );
    log("${TemporaryVars.lat}");
    log("${TemporaryVars.lng}");

    await saveUserToDatabase(newUser);
  }

  String? selectedArea;
  bool isOtherAreaVisible = false;

  void changeArea(String value) {
    selectedArea = value;
    if (value == 'other') {
      isOtherAreaVisible = true;
    } else {
      isOtherAreaVisible = false;
    }
    emit(AreaChangedState());
  }
}
