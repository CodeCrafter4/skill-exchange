import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../models/proposal.dart';
import '../ratingScreen/rate_freelancer_screen.dart';
import '../splashScreen/my_splash_screen.dart';
import 'package:http/http.dart 'as http;


class ProposalDesign extends StatelessWidget
{
  Proposal? model;
  String? orderStatus;
  String? orderId;
  String?  employerUID;
  String?  userUID;
  String? orderByUser;
  String? totalAmount;

  ProposalDesign({
    this.model,
    this.orderStatus,
    this.orderId,
    this.employerUID,
    this.userUID,
    this.orderByUser,
    this.totalAmount,
  });

  sendNotificationToUser(userUID, orderId)async {
    String userDeviceToken = "";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userUID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["userDeviceToken"] != null) {
        userDeviceToken = snapshot.data()!["userDeviceToken"].toString();


      }
    });

    notificationFormat(
      userDeviceToken,
      orderId,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(userDeviceToken, orderId, employerName) {
    

    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };

    Map bodyNotification = {
      'body':
      "Dear user, your Contract (# $orderId) has assigned Successfully from user $employerName. \nPlease Check Now",
      'title': "Assigned Contract",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userContractId": orderId,
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': userDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }




  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [

        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Applications Proposal:',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ),

        const SizedBox(
          height: 6.0,
        ),





        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.UserProposal.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
                color: Colors.black,
            ),
          ),
        ),

        GestureDetector(
          onTap: ()
          {
            if(orderStatus == "normal")
            {
               //update earnings
              FirebaseFirestore.instance
                  .collection("employers")
                  .doc(sharedPreferences!.getString("uid"))
                  .update(
                  {
                    "unit": (double.parse(previousUnit)) - (double.parse(totalAmount!)),
                  }).whenComplete(()
              {
                //change order status to assigned
                FirebaseFirestore.instance
                    .collection("contracts")
                    .doc(orderId)
                    .update(
                    {
                      "status": "Assigned",
                    }).whenComplete(()
                {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(orderByUser)
                      .collection("contracts")
                      .doc(orderId)
                      .update(
                      {
                        "status": "Assigned",
                      }).whenComplete(()
                  {
                    //send notification to user - order shifted
                    sendNotificationToUser(orderByUser, orderId);


                    Fluttertoast.showToast(msg: "contract Confirmed Successfully.");

                    Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
                  });
                });
              });
            }
            else if(orderStatus == "Assigned")
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
            }
            else if(orderStatus == "ended")
            {

              Navigator.push(context, MaterialPageRoute(builder: (context) => RateFreelancerScreen(
                employerId:userUID,
              )));
            }
            else
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Container(
              decoration: const BoxDecoration(
                 color: Colors.lightBlue
              ),
              width: MediaQuery.of(context).size.width - 40,
              height: orderStatus == "ended" ? 60 : MediaQuery.of(context).size.height * .10,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Rate this freelancer"
                      : orderStatus == "Assigned"
                      ? "contract Assigned please wait"
                      : orderStatus == "normal"
                      ? "Do you want to start the \n contract \n click to confirm"
                      : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
