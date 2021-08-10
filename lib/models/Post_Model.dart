class PostModel{
  String name;
  String uID;
  String profileimage;
  String datetime;
  String text;
  String postimage;

  PostModel({
    this.uID,
    this.name,
    this.profileimage,
    this.datetime,
    this.text,
    this.postimage,
  });

  PostModel.fromJson(Map<String,dynamic> json){
    uID = json['uID'];
    name = json['name'];
    profileimage = json['profileimage'];
    datetime = json['datetime'];
    text = json['text'];
    postimage = json['postimage'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'name' : name,
      'uID' : uID,
      'profileimage' : profileimage,
      'datetime' : datetime,
      'text' : text,
      'postimage' : postimage,
    };
  }
}