import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/apllicationScreen/contract_screen.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../AssignedParcelsScreen/assigned_screen.dart';
import '../global/global.dart';
import '../historyScreen/history_screen.dart';
import '../my_skill/freelancers_home.dart';
import '../profile/profile.dart';
import '../splashScreen/my_splash_screen.dart';


class MyDrawer extends StatefulWidget
{
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}



class _MyDrawerState extends State<MyDrawer>
{
  String name = "";
  String img = "";
  readName() async
  {
    await FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        name = snap.data()!["name"].toString();
      });
    });
  }
  readImg() async
  {
    await FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        img = snap.data()!["photoUrl"].toString();
      });
    });
  }
  void initState()
  {
    super.initState();

    readName();
    readImg();

  }



  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      backgroundColor:  const Color(0xff314e97),
      child: ListView(
        children: [

          //header
          Container(
            color: const Color(0xff314e97),
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user profile image
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      sharedPreferences!.getString("photoUrl")!,
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

              ],
            ),
          ),

          //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            color: Colors.white,
            child: Column(
              children: [

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //home
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.lightBlue,),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

                ListTile(
                  leading: const Icon(Icons.person, color: Colors.lightBlue,),
                  title: const Text(
                    "My profile",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> profile()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

                ListTile(
                  leading: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.lightBlue,),
                  title: const Text(
                    "Freelancers",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> Freelancers_home()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),


                //my orders
                ListTile(
                  leading: const Icon(Icons.keyboard_double_arrow_up_outlined, color: Colors.lightBlue,),
                  title: const Text(
                    "Application",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>  OrdersScreen()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

                //not yet received orders

                ListTile(
                  leading: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.lightBlue,),
                  title: const Text(
                    "Contracts",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> AssignedScreen()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

                //history
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.lightBlue,),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

                //search


                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

                //logout
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.lightBlue,),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    showDialog(
                        context: context,
                        builder: (context)
                        {
                          return SimpleDialog(
                            title: const Text(
                              "Are you sure you want to Sign out?",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              SimpleDialogOption(
                                onPressed: ()
                                {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
                                },

                                child: const Text(
                                  "Sign out",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2,),
                              SimpleDialogOption(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    );




                  },
                ),
                const SizedBox(height: 182,),
                const Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                ),

              ],

            ),

          ),

        ],

      ),

    );

  }
}
