
import 'package:blnk_assignment/View/screens/google_drive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../ViewModel/api/users_sheet_api.dart';
import '../../utils/page_route.dart';
import '/View/screens/back_ID_scan_screen.dart';
import '/View/screens/front_ID_scan_screen.dart';

import '../../ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';
import '../../color_const.dart';
import '../components/core/custom_text.dart';

import '../components/core/buttons.dart';
import '../components/core/id_container.dart';

class IDConfirmation extends StatelessWidget {
  const IDConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IdScanCubit idCubit = BlocProvider.of<IdScanCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: 1.sh - 0.04.sh,
          padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              CustomText(
                text: "ID Confirmation",
                size: 25.sp,
                weight: FontWeight.w600,
                color: Colors.white,),
              SizedBox(height: 25.h),
              InkResponse(
                  onTap: () {
                    idCubit.showFrontEditButton();
                  },
                  child: Stack(
                    children: [
                      IDContainer(
                        hintText: '',
                        imagePath: idCubit.frontImagePath,
                      ),

                      if (idCubit.isFrontEditShown)
                        Container(
                          height: 220.h,
                          width: 342.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                            border: Border.all(color: Colors.white, width: 2.sp),
                            color: Colors.black.withOpacity(0.7),
                          ),
                          child: Center(
                            child: InkResponse(
                              onTap: (){
                                idCubit.showFrontEditButton();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const FrontIDScan()));
                              },
                              child: Container(
                                width: 65.sp,
                                height: 65.sp,
                                padding: EdgeInsets.all(20.0.sp),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle),
                                child: SvgPicture.asset(
                                  'assets/edit.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
              SizedBox(height: 16.h),
              InkResponse(
                onTap: () {
                  idCubit.showBackEditButton();
                },
                child: Stack(
                  children: [
                    IDContainer(
                      hintText: '',
                      imagePath: idCubit.backImagePath,
                    ),
                    if (idCubit.isBackEditShown)
                      Container(
                        height: 220.h,
                        width: 342.w,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.sp)),
                          border: Border.all(color: Colors.white, width: 2.sp),
                          color: Colors.black.withOpacity(0.7),
                        ),
                        child: Center(
                          child: InkResponse(
                            onTap: () {
                              idCubit.showBackEditButton();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const BackIDScan()));
                            },
                            child: Container(
                              width: 65.sp,
                              height: 65.sp,
                              padding: EdgeInsets.all(20.0.sp),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: SvgPicture.asset(
                                'assets/edit.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(height: 2.h),
              PrimaryButton(
                  text: 'Upload',
                  onTap: ()async {

                    AppNavigator.customNavigator(context: context, screen:  GoogleDriveUpload(), finish: true);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}