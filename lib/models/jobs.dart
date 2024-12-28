import 'package:cloud_firestore/cloud_firestore.dart';

class jobs
{
  String? jobID;
  String? jobInfo;
  String? jobTitle;
  Timestamp? publishedDate;
  String? employerUID;
  String? status;
  String? thumbnailUrl;

  jobs({
    this.jobID,
    this.jobInfo,
    this.jobTitle,
    this.publishedDate,
    this.employerUID,
    this.status,
    this.thumbnailUrl,
  });

  jobs.fromJson(Map<String, dynamic> json)
  {
    jobID = json["jobID"];
    jobInfo = json["jobInfo"];
    jobTitle = json["jobTitle"];
    publishedDate = json["publishedDate"];
    employerUID = json["employerUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}