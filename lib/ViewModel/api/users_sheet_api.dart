

import 'package:blnk_assignment/Model/user_model.dart';
import 'package:gsheets/gsheets.dart';

class UsersSheetAPI{
  static const _credentials=r'''
  {
  "type": "service_account",
  "project_id": "blnkassignment",
  "private_key_id": "740a2d30bc98fcbcc49c874bd995051f2a3da39e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC866Ziu8qXCZnw\nFN8/ZhBPFVEFmUAmZzmecC9mdV6eiLK0oGeP33zCwtUyN0mRX8FL2avANanF/BOh\nWH13BXuj+gg8NVIxzb4+R+oPjvgjav95rq0sUF/MhOAqm+cvM8pv/Mf9b4Kbi2GM\nSqRykgFZZbHKhfNADSb6cVN2ZBLyha5ZXZk96jPVjB4tVPUq28tyrIXZSGil/ttg\nKiw3g72raN7bwuevs/rf3QiroPuSI2teR2Mblj31bwPGvFvdn+txGOhR3k/CYLZs\nlU6Xej6WXt0LbvTQUvZaAW6oSVszVvTVVRvkWMMaNUPpAKSC6p0YGlCcfP2SKH9a\nO9Pn5s9ZAgMBAAECggEAKpnvHsOfJxkErBVg1GCVG+hAKYWJ6D8NyLMelTmxWQmV\nVtL3F4P7k8Wwos7B2bTgl1Sh/Ml9G8bAvHkCbeUAIRWAZudVPiLZnBzGZLTGMuJt\ncsiXh28mcy2hiSo34zaIF2HGzVkoeB/houuwEp/nCvw6L+Ot20s792y3t/JQLXzh\ne6ZSbB7GjxHmVFJQXZiYILPb/VyRnt0DdCmrb3lDk7Qv7bxhpVKez5jqZ+tjPF64\nGU1aSWLmALkH35hNWEk+8EnVKL5Z8OyBlpiR6fHM0g7uwB6ickreaAqJmtIQJ776\nnllPxLBFsPt2tPB/3B/EZ5ZoOtlfY7zRgLQcYVMOIwKBgQDjTytK/8K6mMliZ8Uc\nfhXhI/iDI6W/C3cJuHw0/aSy2Q/cG1Bw5Pw7XDUTB40VX+QTUBa0+rshukxb5EP0\nnTqMQPwIt1X4T58ere8KLRlmYB3C/ufJv7EH6AfnCFOQ1nILHVdfdh7XU7FvJRod\nHMIczLN5QkZPQODVpshuaCiQ/wKBgQDUxA+tQescQMe7lgSWfvkkf0IcsHsf0mtM\n+q2Qy72BTtBMsapq6e2glwTIKeW2/yxFwP5Sfz4nQ2gBLgTqX1UTfzGb/iUtC/ls\nPwpzl8+4l5xeUxNiPP+iQzjtbnDiYj6X/FRYqW8Io5BwR4Eb/2YvmbGgHYOQAou1\nxASKOUbHpwKBgFpyHPrZq8UNmEwUmETPEquj4XVk0MWkrTfr9VgseMVFQ19EawyQ\nwKBp/yBUR9nybtEUdASNI7q24z1JJZUGns5B6UcalBWasOjHMq8s5MdshUsanGYV\nZT6NH9/Y209tVLGBekuct4bcYWSlMa/VypMlDGC6czmDyjKZC3WK8mFHAoGBALFy\neyiiq3U6ydm3OkhRyXQY9oh635UgpwDiqNL0OS6ZDryICHt2cgrXKNPPrZg7pS7f\n0Lv5B1szqpAhU1QtAgVqtXNGOLcjH3iZ8xuI52Mqfu1kF+x8ty8bJWVQELGeAlo7\nxhTT6pin4ZTi7djt3smgQzYop0r59I851hd5wYBNAoGAd+O7Oc2IRpXsLa87OV3s\niWOWckY/8tFp4HdUTEs5uWjhWLEwvQ68NeB91iJ1uEe9N0/euzkSqUjN99uDjmXO\niDANN3XDFHZt9cJo0X0DgCWlfGXUVUQkvWbPkdkqqxMY7gRNAB5CTO3mvq4UAtEX\nw+Td9gmGUTE1AJ5K6uRc/FE=\n-----END PRIVATE KEY-----\n",
  "client_email": "blnkassignment@blnkassignment.iam.gserviceaccount.com",
  "client_id": "100789401097016770922",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/blnkassignment%40blnkassignment.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
      ''';
  static final _sheetId="1w1pALopPa2F23mdcFjkSpELbmua--4tcY2RGI8tIbZo";
  static final _gSheets =GSheets(_credentials);
static Worksheet ? _userSheet;
  static Future init() async{
    try {
      final spreadSheet = await _gSheets.spreadsheet(_sheetId);
      _userSheet = await _getWorkSheet(spreadSheet, title: 'Users');
      final firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    }catch(e)
    {
      print("error");

    }

  }

  static Future _getWorkSheet(Spreadsheet spreadsheet,{required String title})async {
   try{
     return await spreadsheet.addWorksheet(title);
   }catch(e)
    {
      return spreadsheet.worksheetByTitle(title);
    }
  }
  static Future<int> getRowCount()async {
    if (_userSheet==null)return 0;
    final lastRow = await _userSheet!.values.lastRow();
return lastRow==null?0: int.tryParse(lastRow.first)??0;

  }
  static Future<bool> updateCell({
    required int id,
    required String key,
    required dynamic value


})async {
    if (_userSheet==null)return false;
    return _userSheet!.values.insertValueByKeys(value, columnKey: key, rowKey: id);



  }

  static Future insert(List<Map<String,dynamic>> rowList)async {
    if (_userSheet==null)return;
   _userSheet!.values.map.appendRows(rowList);


  }


}