import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';


class RateFreelancerScreen extends StatefulWidget
{
  String? employerId;

  RateFreelancerScreen({this.employerId,});

  @override
  State<RateFreelancerScreen> createState() => _RateFreelancerScreenState();
}



class _RateFreelancerScreenState extends State<RateFreelancerScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Dialog(
        backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 22,),

              const Text(
                "Rate this Freelancer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22,),

              const Divider(
                height: 4,
                thickness: 4,
              ),

              const SizedBox(height: 22,),

              SmoothStarRating(
                rating: countStarsRating,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.yellow,
                borderColor: Colors.white,
                size: 46,
                onRatingChanged: (valueOfStarsChoosed)
                {
                  countStarsRating = valueOfStarsChoosed;

                  if(countStarsRating == 1)
                  {
                    setState(() {
                      titleStarsRating = "Very Bad";
                    });
                  }
                  if(countStarsRating == 2)
                  {
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }
                  if(countStarsRating == 3)
                  {
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }
                  if(countStarsRating == 4)
                  {
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }
                  if(countStarsRating == 5)
                  {
                    setState(() {
                      titleStarsRating = "Excellent";
                    });
                  }
                },
              ),

              const SizedBox(height: 12,),

              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(height: 18,),

              ElevatedButton(
                onPressed: ()
                {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.employerId)
                      .get()
                      .then((snap)
                  {
                    //seller not yet received rating from any user
                    if(snap.data()!["ratings"] == null)
                    {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.employerId)
                          .update(
                          {
                            "ratings": countStarsRating.toString(),
                          });
                    }
                    //seller has already received rating from any user
                    else
                    {
                      double pastRatings = double.parse(snap.data()!["ratings"].toString());
                      double newRatings = (pastRatings + countStarsRating) / 2;

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.employerId)
                          .update(
                          {
                            "ratings": newRatings.toString(),
                          });
                    }

                    Fluttertoast.showToast(msg: "Rated Successfully.");

                    setState(() {
                      countStarsRating = 0.0;
                      titleStarsRating = "";
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 74),
                ),
                child: const Text(
                    "SUBMIT"
                ),
              ),

              const SizedBox(height: 12,),

            ],
          ),
        ),
      ),
    );
  }
}
