import 'package:employer_app/authScreens/registration_tab_page.dart';
import 'package:flutter/material.dart';
import 'login_tab_page.dart';

class AuthScreen extends StatefulWidget
{
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}



class _AuthScreenState extends State<AuthScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 35,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
               color: Colors.indigoAccent
            ),
          ),

          title: const Text(
            "Skill exchange",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Signatra',
              color: Colors.white,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,

          bottom: const TabBar(
            indicatorColor: Colors.brown,

            indicatorWeight: 3,

            tabs: [

              Tab(
                  child:  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )


              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white

          ),
          child: TabBarView(
            children: [
              LoginTabPage(),
             // RegistrationTabPage(),
            ],
          ),
        ),
      ),
    );
  }
}
