import 'package:blnk_assignment/Model/user_model.dart';
import 'package:blnk_assignment/View/screens/back_ID_scan_screen.dart';
import 'package:blnk_assignment/ViewModel/api/users_sheet_api.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/core/buttons.dart';
import '../components/core/drop_down_menu.dart';
import '../../color_const.dart';
import '../../utils/page_route.dart';
import '../components/core/custom_text.dart';
import '../components/core/text_field.dart';
import 'front_ID_scan_screen.dart';

class BasicInfoSignUp extends StatefulWidget {
  const BasicInfoSignUp({Key? key,}) : super(key: key);

  @override
  State<BasicInfoSignUp> createState() => _BasicInfoSignUpState();
}

class _BasicInfoSignUpState extends State<BasicInfoSignUp> {
  static GlobalKey<FormState> firstnameKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> lastnameKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> mobileKey = new GlobalKey<FormState>();
  static  GlobalKey<FormState> landlineKey = new GlobalKey<FormState>();
  static GlobalKey<FormState> addressKey = new GlobalKey<FormState>();
  static  GlobalKey<FormState> areaKey = new GlobalKey<FormState>();

  String? selectedArea;
  List<String> listOfAreas = <String>[
    "15 Mayu",
    "Abidin"
    , "Eldarb Elahmar", "Duqqi", "Ahram", "Ajuzah", "Amiriah", "Azbakiyah", "Badrashyn", "Basatin", "Jamaliyah", "Giza", "Khalifah"
    , "Khankah", "Khusus", "Maadi", "Marj"
    , "Maasarah", "Matariyah", "Muqattam", "Muski", "New Cairo", "El Ubur", "Wayli", "Nuzhah", "Sharabiyah", "Shaykh Zayid", "Elshrouk", "Sahil"
    , "Salam", "Sayyidah Zaynab", "Talbiah", "Tibbin", "Elzaher", "Zamalek", "Elzawiyah Elhamra", "Zaytun", "Bab Shaariyah"
    , "Boulaq Eldakrur", "Dar Elsalam"
    , "Hadaaiq Elqubba"
    , "Helwan", "Embabah", "Kirdasah", "Nasr City", "10th of Ramadan", "6th of October", "Heliopolis", "Old Cairo"
    , "Manshiyat Naser", "Qalyub"
    , "Qasr Elnile", "Rud Elfaraj", "Shubra", "Shubra el-Kheima", "Turah", "ElRehab", "Madinaty"];


  initUser(){}
  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController landlineController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: primary,
          body: SingleChildScrollView(
            child: Container(
                height: 1.sh - 0.04.sh,
                padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),
                      CustomText(
                        text: "Main Information",
                        size: 25.sp,
                        weight: FontWeight.w600,
                        color: Colors.white,),
                      SizedBox(height: 25.h),

                      DefaultTextField(
                          hintText: "Enter your first name",
                          formKey: firstnameKey,
                          controller: firstnameController,
                          onchange: (val) {
                            print(val);
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First name is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),

                      DefaultTextField(
                          hintText: "Enter your last name",
                          formKey: lastnameKey,
                          controller: lastnameController,
                          onchange: (val) {
                            print(val);
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Last name is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),
                      DefaultDropDownMenu(
                          formKey: areaKey,
                          list: listOfAreas,
                          hintText: Text(
                            'Select your Area',
                            style: TextStyle(color: Colors.grey),
                          ),
                          value: selectedArea,
                          onchange: (String? newValue) {
                            selectedArea = newValue;
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Area is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),

                      DefaultTextField(
                          hintText: "Enter your Address",
                          formKey: addressKey,
                          controller: addressController,
                          onchange: (val) {
                            print(val);
                          },
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address is required';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(height: 15.h),



                      DefaultTextField(
                        keyboardTypeIsNumber: true,
                        hintText: "Enter your Landline Number",
                        formKey: landlineKey,
                        controller: landlineController,
                        onchange: (val) {
                          print(val);
                        },
                        validate: (landlineNumber) {
                          if (landlineNumber == null ||
                              landlineNumber.isEmpty) {
                            return 'LandLine Number is required';
                          } else if (landlineNumber!.length < 10 ||
                              landlineNumber!.length > 10 ||
                              landlineNumber[0] != '0') {
                            return "LandLine Number is not Valid";
                          } else {
                            return null;
                          }
                        }
                      ),
                      SizedBox(height: 15.h),

                      DefaultTextField(
                        keyboardTypeIsNumber: true,
                        hintText: "Enter your Mobile Number",
                        formKey: mobileKey,
                        controller: mobileController,
                        onchange: (val) {
                          print(val);
                        },
                          validate: (mobileNumber) {
                            if (mobileNumber == null ||
                                mobileNumber.isEmpty) {
                              return 'LandLine Number is required';
                            } else if (mobileNumber!.length < 11 ||
                                mobileNumber!.length > 12 ||
                                mobileNumber[0] != '0') {
                              return "Mobile Number is not Valid";
                            } else {
                              return null;
                            }
                          }
                      ),

                      SizedBox(height: 80.h),
                      Center(
                          child: PrimaryButton(
                                  text: 'Continue',
                                  onTap: () async {
                                    if (firstnameKey.currentState!.validate() &&
                                        lastnameKey.currentState!.validate() &&
                                        areaKey.currentState!.validate() &&
                                        addressKey.currentState!.validate() &&
                                        landlineKey.currentState!.validate()&&
                                         mobileKey.currentState!.validate() )
                                    {
                                      final id = await UsersSheetAPI.getRowCount()+1;
                                      final user= User(id: id,
                    firstName: firstnameController.text, lastName: lastnameController.text,
                 address: addressController.text, area: selectedArea, landline: landlineController.text,
                       mobile: mobileController.text,frontID: "",backID: "");
                              await UsersSheetAPI.insert([user.toJson()]);

                                      AppNavigator.customNavigator(
                                          context: context,
                                           screen: const FrontIDScan(),
                                          finish: true);
                                    }
                                  },
                          ))
    ])

          ),
        )

    );
}
  }
