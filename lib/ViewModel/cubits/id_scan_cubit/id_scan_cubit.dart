import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


part 'id_scan_state.dart';

class IdScanCubit extends Cubit<IdScanState> {
  IdScanCubit() : super(IdScanInitial());

  static IdScanCubit get(context) => BlocProvider.of<IdScanCubit>(context);

  // Create a reference to the Firebase Storage bucket
  final storageRef = FirebaseStorage.instance.ref();

  String frontImagePath = 'imagePath';
  String backImagePath = 'imagePath';


  bool frontIdScanned = false, backIdScanned = false, isFilesUploaded = false, isFrontEditShown = false, isBackEditShown = false;

  Future<bool> scanID({required bool isFront}) async{
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted = await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      // return;

      debugPrint("cannot grant camera access");

      if(isFront){
        frontIdScanned = false;
      }else{
        backIdScanned = false;
      }
      emit(IdScanError());

      return false;
    }

    // Generate filepath for saving
    if(isFront) {
      frontImagePath = join((await getApplicationSupportDirectory()).path,
          "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
    }else{
      backImagePath = join((await getApplicationSupportDirectory()).path,
          "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
    }

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(isFront ? frontImagePath : backImagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
    } catch (e) {
      debugPrint(e.toString());

      if(isFront){
        frontIdScanned = false;
      }else{
        backIdScanned = false;
      }
      return false;
    }

    if(isFront){
      frontIdScanned = true;
    }else{
      backIdScanned = true;
    }
    emit(IdScanSuccess());

    return true;

  }

 /* void uploadImages()async {

    File file;

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Upload file and metadata to the path 'images/mountains.jpg'
    try {

      file = File(frontImagePath);

      UploadTask frontRef = storageRef
          .child('front_idddd.jpg')
          .putFile(file, metadata);

      String frontUrl = await (await frontRef).ref.getDownloadURL();

      file = File(backImagePath);
      UploadTask backRef = storageRef
          .child('back_idddd.jpg')
          .putFile(file, metadata);

      String backUrl = await (await backRef).ref.getDownloadURL();
print(frontUrl);
print(backUrl);
      // UPLOAD DATA TO FIRESTORE
      FirebaseFirestore.instance.collection("Users").doc("wAFdPPvfinPHmjUhDWxX").set({
        "front_id": frontUrl,
        "back_id": backUrl,
      }, SetOptions(merge: true)).then((value) {

        print("front and back id added");
      }).catchError((e) {
        print(e.toString());
      });

      isFilesUploaded = true;

      emit(UploadIDSuccess());
    }catch(e){
      isFilesUploaded = false;

      emit(UploadIDError());
    }
  }*/

  void showFrontEditButton(){
    isFrontEditShown = !isFrontEditShown;

    emit(ShowFrontEditButton());
  }

  void showBackEditButton(){
    isBackEditShown = !isBackEditShown;

    emit(ShowBackEditButton());
  }
}