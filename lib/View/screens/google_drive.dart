

import 'dart:io';
import 'dart:typed_data';

import 'package:blnk_assignment/View/screens/basic_information.dart';
import 'package:blnk_assignment/color_const.dart';
import 'package:blnk_assignment/utils/page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../ViewModel/api/users_sheet_api.dart';
import '../../ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';

class GoogleDriveUpload extends StatefulWidget {

  @override
  _GoogleDriveUpload createState() => _GoogleDriveUpload();
}

class _GoogleDriveUpload extends State<GoogleDriveUpload> {
  bool _loginStatus = false;
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  @override
  void initState() {
    _loginStatus = googleSignIn.currentUser != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Container(
            height: 1.sh - 0.04.sh,
            padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25.h),
                CustomText(
                  text: "Upload to google drive",
                  size: 23.sp,
                  weight: FontWeight.w600,
                  color: Colors.white,),
                SizedBox(height: 150.h),

                Center(
                    child: PrimaryButton(
                      /// sign in with this gmail account
                      /// email : blnkassignmnet@gmail.com
                      /// password : Mnbvcxz9@
                        text: 'Upload images to drive',
                        onTap: ()  {
                          _uploadToNormal();
                        }

                    )),
                SizedBox(height: 75.h),

                Center(
                    child: PrimaryButton(
                        text: 'Done',
                        onTap: ()  {
                          //_signOut();
                         /* Fluttertoast.showToast(msg: "Signed out Successfully",toastLength: Toast.LENGTH_LONG
                          ,textColor: secondary,);*/
                         // AppNavigator.customNavigator(context: context, screen: const BasicInfoSignUp(), finish: true);
                          SystemNavigator.pop();


                        }

                    )),


            ],)


          /*_createBody(context)*/),
      ),
    );
  }



  Future<void> _signIn() async {
    final googleUser = await googleSignIn.signIn();

    try {
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential loginUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

        assert(loginUser.user?.uid == FirebaseAuth.instance.currentUser?.uid);
        print("Sign in");
        setState(() {
          _loginStatus = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    setState(() {
      _loginStatus = false;
    });
    print("Sign out");
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }



  Future<String?> _getFrontFolderId(drive.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "Front_IDs";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }

      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = new drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      // I/flutter ( 6132): DetailedApiRequestError(status: 403, message: The granted scopes do not give access to all of the requested spaces.)
      return null;
    }
  }


  Future<String?> _getBackFolderId(drive.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "Back_IDs";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }

      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = new drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      // I/flutter ( 6132): DetailedApiRequestError(status: 403, message: The granted scopes do not give access to all of the requested spaces.)
      return null;
    }
  }


  Future<void> _uploadToNormal() async {
    IdScanCubit idCubit = BlocProvider.of<IdScanCubit>(context, listen: false);

    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }

      // Not allow a user to do something else
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(seconds: 2),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: CircularProgressIndicator(color: secondary,),
        ),
      );

      final frontFolderId = await _getFrontFolderId(driveApi);
      final backFolderId = await _getBackFolderId(driveApi);

      if (frontFolderId == null) {
        return;
      }else  if (backFolderId == null) {
        return;
      }

      final frontFile = File(idCubit.frontImagePath);
      final backFile = File(idCubit.backImagePath);


      var frontMedia = drive.Media(frontFile.openRead(), frontFile.lengthSync(),contentType:"image/jpeg" );
      var backMedia = drive.Media(backFile.openRead(), backFile.lengthSync(),contentType:"image/jpeg" );

      // Set up File info
      var frontDriveFile =  drive.File();
      final frontTimestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      frontDriveFile.name = "FrontID-$frontTimestamp.png";
      frontDriveFile.mimeType="image/png";
      frontDriveFile.modifiedTime = DateTime.now().toUtc();
      frontDriveFile.parents = [frontFolderId];

      // Set up File info
      var backDriveFile =  drive.File();
      final backTimestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      backDriveFile.name = "BackID-$backTimestamp.png";
      backDriveFile.mimeType="image/png";
      backDriveFile.modifiedTime = DateTime.now().toUtc();
      backDriveFile.parents = [backFolderId];

      // Upload
      final frontResponse =
      await driveApi.files.create(frontDriveFile, uploadMedia: frontMedia);
      print("response: $frontResponse");

      // Upload
      final backResponse =
      await driveApi.files.create(backDriveFile, uploadMedia: backMedia);
      print("response: $backResponse");
      Fluttertoast.showToast(msg: "Data Updated Successfully",toastLength: Toast.LENGTH_LONG
        ,textColor: secondary,);
      final id = await UsersSheetAPI.getRowCount();
      UsersSheetAPI.updateCell(id: id, key: "Front of the ID", value: "FrontID-$frontTimestamp.png");
      UsersSheetAPI.updateCell(id: id, key: "Back of the ID", value: "BackID-$backTimestamp.png");

      // simulate a slow process
      await Future.delayed(Duration(seconds: 2));
    } finally {
      // Remove a dialog
      Navigator.pop(context);
    }
  }
}






class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = new http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

