// To parse this JSON data, do
//
//     final FMSFile = FMSFileFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FMSFile FMSFileFromMap(String str) => FMSFile.fromMap(json.decode(str));

String FMSFileToMap(FMSFile data) => json.encode(data.toMap());

class FMSFile {
  FMSFile({
    required this.status,
    required this.message,
    required this.data,
  });

  int status;
  String message;
  List<Datum>? data;

  factory FMSFile.fromMap(Map<String, dynamic> json) => FMSFile(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    required this.fmtsFileId,
    required this.fmtsFileNo,
    required this.fmtsFileBarcode,
    required this.fmtsFileTitle,
    required this.fmtsFileDesc,
    required this.createdBy,
    required this.createdDate,
  });

  String fmtsFileId;
  String fmtsFileNo;
  String fmtsFileBarcode;
  String fmtsFileTitle;
  String fmtsFileDesc;
  String createdBy;
  String createdDate;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        fmtsFileId: json["FMTSFileID"] == null ? "null" : json["FMTSFileID"],
        fmtsFileNo: json["FMTSFileNo"] == null ? "null" : json["FMTSFileNo"],
        fmtsFileBarcode:
            json["FMTSFileBarcode"] == null ? "null" : json["FMTSFileBarcode"],
        fmtsFileTitle:
            json["FMTSFileTitle"] == null ? "null" : json["FMTSFileTitle"],
        fmtsFileDesc:
            json["FMTSFileDesc"] == null ? "null" : json["FMTSFileDesc"],
        createdBy: json["CreatedBy"] == null ? "null" : json["CreatedBy"],
        createdDate: json["createdDate"] == null ? "null" : json["createdDate"],
      );

  Map<String, dynamic> toMap() => {
        "FMTSFileID": fmtsFileId == null ? null : fmtsFileId,
        "FMTSFileNo": fmtsFileNo == null ? null : fmtsFileNo,
        "FMTSFileBarcode": fmtsFileBarcode == null ? null : fmtsFileBarcode,
        "FMTSFileTitle": fmtsFileTitle == null ? null : fmtsFileTitle,
        "FMTSFileDesc": fmtsFileDesc == null ? null : fmtsFileDesc,
        "CreatedBy": createdBy == null ? null : createdBy,
        "createdDate": createdDate == null ? null : createdDate,
      };
}
