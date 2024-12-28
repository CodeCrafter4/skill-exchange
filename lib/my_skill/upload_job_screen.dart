import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:employer_app/global/global.dart';
import '../widgets/loading_dialog.dart';


class UploadJobsScreen extends StatefulWidget
{
  @override
  State<UploadJobsScreen> createState() => _UploadJobsScreenState();
}




class _UploadJobsScreenState extends State<UploadJobsScreen>
{

  TextEditingController jobInfoTextEditingController = TextEditingController();
  TextEditingController jobTitleTextEditingController = TextEditingController();

  bool uploading = false;
  String jobUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  get c => null;


  saveJobInfo()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("jobs")
        .doc(jobUniqueId)
        .set(
        {
          "jobID": jobUniqueId,
          "employerUID": sharedPreferences!.getString("uid"),
          "jobInfo": jobInfoTextEditingController.text.trim(),
          "jobTitle": jobTitleTextEditingController.text.trim(),
          "publishedDate": DateTime.now(),
          "status": "available",
        });

    setState(() {
      uploading = false;
      jobUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    Fluttertoast.showToast(msg: "uploaded successfully");
  }

  validateUploadForm() async
  {

      if(jobInfoTextEditingController.text.isNotEmpty
          && jobTitleTextEditingController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //2. save jobs info to firestore database
        saveJobInfo();
      }
      else
      {
        Fluttertoast.showToast(msg: "Please write job type info and job type title.");
      }

  }

  uploadFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: ()
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return LoadingDialogWidget(
                        message: "Uploading",
                      );
                    }
                );
                //validate upload form
                uploading == true ? null : validateUploadForm();
              },
              icon: const Icon(
                Icons.cloud_upload,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.lightBlue
          ),
        ),
        title: const Text(
            "Upload New job type"
        ),
        centerTitle: true,

      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: jobTitleTextEditingController,
              minLines: 2,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  hintText: 'write your job category title',
                  hintStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: jobInfoTextEditingController,
              minLines: 2,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  hintText: 'write your job category title',
                  hintStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )
              ),
            ),
          ),
          ElevatedButton(
              onPressed: ()
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return LoadingDialogWidget(
                        message: "Uploading",
                      );
                    }
                );
                uploading == true ? null : validateUploadForm();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigoAccent,
                fixedSize: const Size(290, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Upload",
              )
          ),

        ],
      ),


    );

  }

  @override
  Widget build(BuildContext context)
  {
    return

      uploadFormScreen() ;
  }

}

