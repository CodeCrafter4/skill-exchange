import 'package:flutter/material.dart';

import '../my_skill/home_screen.dart';
import '../report/report.dart';




class StatusBanner extends StatelessWidget
{
  bool? status;
  String? contractID;
  String? unit;
  String? employerName;
  String? email;
  String? contractStatus;
  String? contractDate;
  String? employerUID;
  String? contractByUser;


  StatusBanner( {this.status, this.contractStatus,this.contractID,this.unit,this.employerName,this.email,this.contractDate,this.employerUID,this.contractByUser});





  @override
  Widget build(BuildContext context)
  {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "UnSuccessful";

    return Container(
      decoration: const BoxDecoration(
          color: Colors.indigo
      ),
      height: 80,


      child: SizedBox(
        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            GestureDetector(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(width: 60,),

            Text(
              contractStatus == "ended"
                  ? "contract closed $message"
                  : contractStatus == "Assigned"
                  ? "contract Assigned $message"
                  : contractStatus == "normal"
                  ? "contract sent $message"
                  : "",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(width: 10,),

            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.green,
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 50,),
            GestureDetector(
              onTap: ()async
              {
                await  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    report( contractID.toString(),
                      unit.toString(),
                      employerName.toString(),
                      email.toString(),
                      contractStatus.toString(),
                      contractDate.toString(),
                      employerUID.toString(),
                      contractByUser.toString(),
                    )));
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.report,
                  color: Colors.white,
                  size: 28,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
