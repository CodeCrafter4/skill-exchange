
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../global/global.dart';
import '../my_skill/home_screen.dart';
import '../widgets/loading_dialog.dart';


class report extends StatefulWidget
{

  String? contractId;
  String unit;
  String? employerName;
  String? email;
  String? contractStatus;
  String? contractDate;
  String? employerUID;
  String? contractByUser;




  report(   this.contractId,this.unit,this.employerName,this.email,this.contractStatus,this.contractDate,this.employerUID,this.contractByUser, );



  @override
  State<report> createState() => _reportState();
}


class _reportState extends State<report>
{

  String? contractId1;
  String? unit;
  String? employerName;
  String? email;
  String? contractStatus;
  String? contractDate;
  String? contractBy;
  String? employerId;
  String? userName;

  TextEditingController complainTextEditingController = TextEditingController();

  String complainUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
  readUserName() async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        userName = snap.data()!["name"].toString();
      });
    });
  }

  void initState() {

    readUserName();
    super.initState();



  }

  saveBorrowInfo()
  {

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("reports")
        .doc(complainUniqueId)
        .set(
        {
          "contractID": contractId1,
          "contractStatus": contractStatus,
          "unit": unit,
          "reportStatus":"normal",
          "contractDate":  contractDate,
          "contractBy": contractBy,
          "employerId": employerId,
          "employerName": employerName,
          "email": email,
          "complainID": complainUniqueId,
          "userID": sharedPreferences!.getString("uid"),
          "userName": sharedPreferences!.getString("name"),
          "complain": complainTextEditingController.text.trim(),
          "complainDate": DateTime.now(),

        }).then((value)
    {
      FirebaseFirestore.instance
          .collection("reports")
          .doc(complainUniqueId)
          .set(
          {
            "contractID": contractId1,
            "contractStatus": contractStatus,
            "unit": unit,
            "reportStatus":"normal",
            "contractDate":  contractDate,
            "contractBy": contractBy,
            "employerId": employerId,
            "employerName": employerName,
            "email": email,
            "complainID": complainUniqueId,
            "userID": sharedPreferences!.getString("uid"),
            "userName": sharedPreferences!.getString("name"),
            "complain": complainTextEditingController.text.trim(),
            "complainDate": DateTime.now(),
          });
    });


    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    Fluttertoast.showToast(msg: "complain sent successfully.");
  }

  validateUploadForm() async
  {

    if(complainTextEditingController.text.isNotEmpty)
    {

      showDialog(
          context: context,
          builder: (c)
          {
            return LoadingDialogWidget(
              message: "sending complain",
            );
          }
      );

      saveBorrowInfo();

    }
    else
    {
      Fluttertoast.showToast(msg: "Please write complain first.");
    }

  }

  uploadFormScreen()
  {
    contractId1=widget.contractId;
    unit=widget.unit;
    employerName=widget.employerName;
    email=widget.email;
    contractDate=widget.contractDate;
    contractBy=widget.contractByUser;
    employerId=widget.employerUID;
    contractStatus=widget.contractStatus;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(



        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.indigo
          ),
        ),
        title: const Text(
            "Report"
        ),
        centerTitle: true,
      ),
      body: ListView(

        children: [

          //image



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "unit: ${unit!}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "contract ID:  ${contractId1!}",
                style: const TextStyle(
                  color: Colors.black,

                  fontSize: 16,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "contract at = ${DateFormat(" dd MMMM, yyyy - hh:mm aa")
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(contractDate!)))}",


                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "employer name: "+employerName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "contract status: ${contractStatus!}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "contract By: $userName",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),



          const SizedBox(height: 16,),


          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: complainTextEditingController,
                  minLines: 8,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText: 'write your complain and send to admin',
                      hintStyle: TextStyle(
                          color: Colors.grey
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )
                  ),
                ),
              ),


            ],
          ),




          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: ()
                {

                  validateUploadForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  fixedSize: const Size(210, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "send",style: TextStyle(fontSize: 18,),
                )
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return  uploadFormScreen();
  }
}
