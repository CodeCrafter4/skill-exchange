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


class borrow extends StatefulWidget
{
  jobs? model;

  borrow({this.model,});

  @override
  State<borrow> createState() => _borrowState();
}




class _borrowState extends State<borrow>
{
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController borrowAmountTextEditingController = TextEditingController();



  bool uploading = false;
  String downloadUrlImage = "";
  String borrowUniqueId = DateTime.now().millisecondsSinceEpoch.toString();


  saveBorrowInfo()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("borrow")
        .doc(borrowUniqueId)
        .set(
        {
          "borrowID": borrowUniqueId,
          "borrowStatus": "borrow",
          "employerUID": sharedPreferences!.getString("uid"),
          "employerName": sharedPreferences!.getString("name"),
          "borrowAmount": borrowAmountTextEditingController.text.trim(),
          "publishedDate": DateTime.now(),
          "thumbnailUrl": downloadUrlImage,
        }).then((value)
    {
      FirebaseFirestore.instance
          .collection("borrow")
          .doc(borrowUniqueId)
          .set(
          {
            "borrowID": borrowUniqueId,
            "borrowStatus": "borrow",
            "employerUID": sharedPreferences!.getString("uid"),
            "employerName": sharedPreferences!.getString("name"),
            "borrowAmount": borrowAmountTextEditingController.text.trim(),
            "publishedDate": DateTime.now(),
            "thumbnailUrl": downloadUrlImage,
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
    if(imgXFile != null)
    {
      if(borrowAmountTextEditingController.text.isNotEmpty)
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
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("employerBorrowReceiptImages").child(fileName);

        fStorage.UploadTask uploadImageTask = storageRef.putFile(File(imgXFile!.path));

        fStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((urlImage)
        {
          downloadUrlImage = urlImage;
        });

        //2. save job info to firestore database
        saveBorrowInfo();

      }
      else
      {
        Fluttertoast.showToast(msg: "Please complete form.");
      }
    }
    else
    {
      Fluttertoast.showToast(msg: "Please choose image.");
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
            "Borrow"
        ),
        centerTitle: true,
      ),
      body: ListView(

        children: [

          //image
          const Divider(
            color: Colors.indigo,
            thickness: 1,
          ),

          GestureDetector(
            onTap: ()
            {
              obtainImageDialogBox();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imgXFile == null
                  ? null
                  : FileImage(
                  File(imgXFile!.path)
              ),
              child: imgXFile == null
                  ? Icon(
                Icons.receipt,
                color: Colors.black54,
                size: MediaQuery.of(context).size.width * 0.20,
              ) : null,
            ),
          ),


          const Center(
            child: Text(
              "select photo for your receipt",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
                //fontFamily: 'Signatra',
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),

            ),
          ),
          const SizedBox(height: 16,),


           Container(
             width: 300,
             child: TextField(
              style: const TextStyle(color: Colors.black),
              minLines: 1,
              maxLines: 7,
              maxLength: 4,
              controller: borrowAmountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "job unit",
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
                "send",style: TextStyle(fontSize: 18,),
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

  obtainImageDialogBox()
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            title: const Text(
              "borrow receipt image",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImagewithPhoneCamera();
                },
                child: const Text(
                  "Capture image with Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  getImageFromGallery();
                },
                child: const Text(
                  "Select image from Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  getImageFromGallery() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

  captureImagewithPhoneCamera() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgXFile;
    });
  }
}
