import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/my_skill/upload_job_screen.dart';
import 'package:employer_app/push_notifications/push_notifications_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:employer_app/my_skill/jobs_ui_design_widget.dart';
import 'package:employer_app/global/global.dart';
import 'package:employer_app/models/jobs.dart';
import '../assistantMethods/bookmark_methods.dart';
import '../functions/functions.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/my_drawer.dart';


class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>
{
  restrictBlockedEmployersFromUsingUsersApp() async
  {
    await FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snapshot)
    {
      if(snapshot.data()!["status"] != "approved")
      {
        showReusableSnackBar(context, "you are blocked by admin.");
        showReusableSnackBar(context, "contact admin: ssswar@gmail.com");

        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
      }

    });
  }

  getEmployerUnitFromDatabase()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((dataSnapShot)
    {
      previousUnit = dataSnapShot.data()!["unit"].toString();
    });
  }
  @override
  void initState()
  {
    super.initState();
    PushNotificationsSystem pushNotificationsSystem =PushNotificationsSystem();
    pushNotificationsSystem.whenNotificationReceived(context);
    pushNotificationsSystem.generateDeviceRecognitionToken();

    getEmployerUnitFromDatabase();
  }
  DateTime? _currentBackPressTime;




  @override
  Widget build(BuildContext context)
  {
    return  WillPopScope(
          onWillPop: () async {
        DateTime now = DateTime.now();

        if (_currentBackPressTime == null ||
            now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
          _currentBackPressTime = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back button again to exit'),
            ),
          );

          return false;
        }
        return true;
      },


        child:Scaffold(

        backgroundColor: Colors.white,
        drawer: const MyDrawer(),
        appBar: AppBar(

          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.indigo
            ),
          ),
          title: const Text(
            "MY JOBS CATEGORY",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [

                // IconButton(
                //    icon: const Icon(Icons.notifications_none),
                //       onPressed: () {},
                //       ),
            IconButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadJobsScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],

        ),
        body: CustomScrollView(




            slivers: [

              // SliverPersistentHeader(
              //   pinned: true,
              //   delegate: TextDelegateHeaderWidget(title: "My jobs type"),
              // ),

              //1. write query
              //2  model
              //3. ui design widget

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("employers")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("jobs")
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot dataSnapshot)
                {
                  if(dataSnapshot.hasData) //if jobs exists
                      {
                    //display jobs
                    return SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                      itemBuilder: (context, index)
                      {
                        jobs jobsModel = jobs.fromJson(
                          dataSnapshot.data.docs[index].data() as Map<String, dynamic>,
                        );

                        return jobsUiDesignWidget(
                          model: jobsModel,
                          context: context,
                        );
                      },
                      itemCount: dataSnapshot.data.docs.length,
                    );
                  }
                  else //if jobs NOT exists
                      {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "No job exists",
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),

      );

  }
}
