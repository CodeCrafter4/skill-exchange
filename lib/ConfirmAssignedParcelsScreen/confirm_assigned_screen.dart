import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/assistantMethods/bookmark_methods.dart';
import 'package:flutter/material.dart';
import '../apllicationScreen/contract_card.dart';
import '../global/global.dart';



class ConfirmAssignedScreen extends StatefulWidget
{
  @override
  State<ConfirmAssignedScreen> createState() => _ConfirmAssignedScreen();
}



class _ConfirmAssignedScreen extends State<ConfirmAssignedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.lightBlue
          ),
        ),
        title: const Text(
          "Confirm Assigned Job Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("contracts")
            .where("status", isEqualTo: "ConfirmAssigned")
            .where("employerUID", isEqualTo: sharedPreferences!.getString("uid"))
            .orderBy("contractTime", descending: true)
            .snapshots(),
        builder: (c, AsyncSnapshot dataSnapShot)
        {
          if(dataSnapShot.hasData)
          {
            return ListView.builder(
              itemCount: dataSnapShot.data.docs.length,
              itemBuilder: (c, index)
              {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("jobsItems")
                      .where("itemID", whereIn: BookmarkMethods().separateOrderItemIDs((dataSnapShot.data.docs[index].data() as Map<String, dynamic>)["productIDs"]))
                      .where("employerUID", whereIn: (dataSnapShot.data.docs[index].data() as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDate", descending: true)
                      .get(),
                  builder: (c, AsyncSnapshot snapshot)
                  {
                    if(snapshot.hasData)
                    {
                      return OrderCard(
                        itemCount: snapshot.data.docs.length,
                        data: snapshot.data.docs,
                        orderId: dataSnapShot.data.docs[index].id,
                        seperateQuantitiesList: BookmarkMethods().separateOrderItemsQuantities((dataSnapShot.data.docs[index].data() as Map<String, dynamic>)["productIDs"]),
                      );
                    }
                    else
                    {
                      return const Center(
                        child: Text(
                          "No data exists.",
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text(
                "No data exists.",
              ),
            );
          }
        },
      ),
    );
  }
}
