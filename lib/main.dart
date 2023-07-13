

import 'package:blnk_assignment/View/screens/basic_information.dart';
import 'package:blnk_assignment/View/screens/google_drive.dart';
import 'package:blnk_assignment/ViewModel/api/users_sheet_api.dart';
import 'package:blnk_assignment/ViewModel/cubits/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';


bool shouldUseFirebaseEmulator = false;
late final FirebaseApp app;
late final FirebaseAuth auth;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
await UsersSheetAPI.init();
  app = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: app);
  if (shouldUseFirebaseEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
  }

  runApp(const MyApp());

  BlocOverrides.runZoned(
        () {
      // Use cubits...
      runApp(MultiBlocProvider(
        providers: [

          BlocProvider<IdScanCubit>(create: (context) => IdScanCubit()),


        ],
        child: const MyApp(),
      ));
    },
    blocObserver: MyBlocObserver()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BlnkAssignment',
            home: BlocProvider(
              create: (context) => IdScanCubit(),
              child: const BasicInfoSignUp(),
            )
        );
      },
    );
  }
}

