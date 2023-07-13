import 'dart:io';
import 'package:blnk_assignment/View/screens/id_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/page_route.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/custom_text.dart';
import '/color_const.dart';
import '../../ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';
import '../components/core/id_container.dart';


class BackIDScan extends StatelessWidget {
  const BackIDScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IdScanCubit idCubit = BlocProvider.of<IdScanCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: 1.sh - 0.04.sh,
          padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              CustomText(
                text: "National ID Scan",
                size: 25.sp,
                weight: FontWeight.w600,
                color: Colors.white,),
              SizedBox(height: 25.h),
              idCubit.backIdScanned
                  ? IDContainer(imagePath: idCubit.backImagePath)
                  : IDContainer(
                imageHolder: 'assets/id_scan.svg',
                hintText: 'back',
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Image.asset('assets/check.png'),
                  Expanded(
                    child: Opacity(
                        opacity: 0.7,
                        child: CustomText(
                            text: ' Make sure your surroundings are well-lit.',
                            weight: FontWeight.w500,
                            size: 13.sp,
                            color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/check.png'),
                  Expanded(
                    child: Opacity(
                        opacity: 0.7,
                        child: CustomText(
                            text:
                            ' Make sure the photo is inside the frame and details are easy to read.',
                            weight: FontWeight.w500,
                            size: 13.sp,
                            color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              PrimaryButton(
                  text: 'Confirm',
                  onTap: () {
                    if (idCubit.backIdScanned) {
                      AppNavigator.customNavigator(
                          context: context,
                          screen: const IDConfirmation(),
                          finish: true);

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Pick an image or skip')));
                    }
                  }),
              SizedBox(height: 16.h),
              BlocConsumer<IdScanCubit, IdScanState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return SecondaryButton(
                    text: 'Take a new pic',
                    onTap: () async {
                      await idCubit.scanID(isFront: false);
                    },
                  );
                },
              ),
              SizedBox(height: 16.h),

            ],
          ),
        ),
      ),
    );
  }
}
