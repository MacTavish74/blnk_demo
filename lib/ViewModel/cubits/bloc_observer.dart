import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:go_router/go_router.dart';
//
// import '../view_model/database/local/cache_helper.dart';
// import 'color.dart';
// this class used to show states
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // ignore: avoid_print
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
// void getChekLogin({required String message,required BuildContext context}){
//   if(message=='Unauthorized'){
//     userToken = null;
//     CacheHelper.removeData(key: 'accessToken');
//     context.go('/');
//   }
// }