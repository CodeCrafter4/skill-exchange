import 'package:cloud_firestore/cloud_firestore.dart';

class JobsItems
{
  String? jobID;
  String? itemID;
  String? itemTitle;
  String? longDescription;
  String? unit;
  DateTime? dueDate;
  DateTime? publishedDate;
  String? employerName;
  String? employerUID;
  String? status;
  String? thumbnailUrl;

  JobsItems({
    this.jobID,
    this.itemID,

    this.itemTitle,
    this.longDescription,
    this.unit,
    this. dueDate,
    this.publishedDate,
    this.employerName,
    this.employerUID,
    this.status,
    this.thumbnailUrl,
  });

  JobsItems.fromJson(Map<String, dynamic> json)
  {
    jobID = json["jobID"];
    itemID = json["itemID"];

    itemTitle = json["itemTitle"];
    longDescription = json["longDescription"];
    unit = json["unit"];
    dueDate = json["DueDate"].toDate();
    publishedDate = json["publishedDate"].toDate();
    employerName = json["employerName"];
    employerUID = json["employerUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}