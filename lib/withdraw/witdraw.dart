import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/models/jobs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:employer_app/global/global.dart';
import 'package:employer_app/widgets/progressbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../widgets/loading_dialog.dart';


class witdraw extends StatefulWidget
{
  jobs? model;

  witdraw({this.model,});

  @override
  State<witdraw> createState() => _witdrawState();
}




class _witdrawState extends State<witdraw>
{


  TextEditingController witdrawAmountTextEditingController = TextEditingController();



  bool uploading = false;
  String downloadUrlImage = "";
  String borrowUniqueId = DateTime.now().millisecondsSinceEpoch.toString();


  saveBorrowInfo()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("withdraw")
        .doc(borrowUniqueId)
        .set(
        {
          "withdrawID": borrowUniqueId,
          "withdrawUID": sharedPreferences!.getString("uid"),
          "withdrawName": sharedPreferences!.getString("name"),
          "withdrawAmount": witdrawAmountTextEditingController.text.trim(),
          "publishedDate": DateTime.now(),

        }).then((value)
    {
      FirebaseFirestore.instance
          .collection("withdraw")
          .doc(borrowUniqueId)
          .set(
          {
            "withdrawID": borrowUniqueId,
            "employerUID": sharedPreferences!.getString("uid"),
            "employerName": sharedPreferences!.getString("name"),
            "withdrawAmount": witdrawAmountTextEditingController.text.trim(),
            "publishedDate": DateTime.now(),

          });
    });

    setState(() {
      uploading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    Fluttertoast.showToast(msg: "send successfully.");
  }

  validateUploadForm() async
  {

      if(witdrawAmountTextEditingController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });
        showDialog(
            context: context,
            builder: (c)
            {
              return LoadingDialogWidget(
                message: "sending",
              );
            }
        );
        //1. upload image to storage - get downloadUrl


        //2. save job info to firestore database
        saveBorrowInfo();

      }
      else
      {
        Fluttertoast.showToast(msg: "Please complete form.");
      }

  }

  uploadFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

          },
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.indigo
          ),
        ),
        title: const Text(
            "Withdraw"
        ),
        centerTitle: true,
      ),
      body: ListView(

        children: [
          const SizedBox(height: 20,),
          Container(
            width: 300,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              minLines: 1,
              maxLines: 7,
              maxLength: 4,
              controller: witdrawAmountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "withdraw unit",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),


              ),
            ),
          ),



          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: ()
              {

                uploading == true ? null : validateUploadForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                fixedSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Withdraw",style: TextStyle(fontSize: 18,),
              )
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
