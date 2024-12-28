class Freelancers {
  String? name;
  String? uid;
  String? photoUrl;
  String? email;
  String? ratings;
  String? skill;

  Freelancers({
    this.name,
    this.uid,
    this.photoUrl,
    this.email,
    this.ratings,
    this.skill,
  });
  Freelancers.fromJson(Map<String, dynamic> json)
  {
    name = json["name"];
    uid = json["uid"];
    photoUrl = json["photoUrl"];
    email = json["email"];
    ratings = json["ratings"];
    skill = json["skill"];
  }

}