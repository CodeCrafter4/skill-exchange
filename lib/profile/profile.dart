import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/borrow/borrow.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import '../widgets/button_widget.dart';
import '../withdraw/witdraw.dart';



class profile extends StatefulWidget
{
  @override
  State<profile> createState() => _profileState();
}



class _profileState extends State<profile>
{
  String totalSellerEarnings = "";
  String about = "";
  String img = "";
  var skill=(sharedPreferences!.getString("skill"));





  readImg() async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        img = snap.data()!["photoUrl"].toString();
      });
    });
  }


  readTotalEarnings() async
  {
    await FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        totalSellerEarnings = snap.data()!["unit"].toString();
      });
    });
  }
  readabout() async
  {
    await FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        about = snap.data()!["about"].toString();
      });
    });
  }

  @override
  void initState()
  {
    super.initState();

    readTotalEarnings();

    readImg();

    readabout();
  }

  @override
  Widget build(BuildContext context)
  {


    return Scaffold(


      appBar:  AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Profile"),

        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(

            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user profile image
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      img,
                    ),
                  ),
                ),

                const SizedBox(height: 12,),

                //user name
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12,),
                Text(
                  sharedPreferences!.getString("email")!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12,),

              ],
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Center(child: borrowButton()),
                    const SizedBox(width: 38),
                    Center(child: withdrawButton()),


                  ]),
            ),
          ),

          builds(context),
          const SizedBox(height: 48),
            buildAbout(),
        ],
      ),
    );

  }



  Widget borrowButton() => ButtonWidget(

    text: 'Borrow',
    onClicked: () {
      Navigator.push(context, MaterialPageRoute(builder: (c)=> borrow()));

    },
  );
  Widget withdrawButton() => ButtonWidget(

    text: 'Withdraw',
    onClicked: () {
      Navigator.push(context, MaterialPageRoute(builder: (c)=> witdraw()));

    },
  );





  Widget buildAbout() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
        ),
        SizedBox(height: 16),
        Text(
          about,
          style: TextStyle(fontSize: 16, height: 1.4,),
        ),
      ],
    ),
  );

  Widget builds(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(context, 'units',totalSellerEarnings),
      buildDivider(),


    ],
  );
  Widget buildDivider() => Container(
    height: 44,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {

        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
