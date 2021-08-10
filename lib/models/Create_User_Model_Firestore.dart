class CreateUserModelFirestore{
  String name;
  String email;
  String phone;
  String uID;
  String Pass;
  String Bio;
  String image;
  String cover;

  CreateUserModelFirestore({
   this.email,
    this.uID,
    this.name,
    this.phone,
    this.Pass,
    this.Bio,
    this.image,
    this.cover,
});

  CreateUserModelFirestore.fromJson(Map<String,dynamic> json){
    email = json['email'];
    uID = json['uID'];
    name = json['name'];
    phone = json['phone'];
    Pass = json['Pass'];
    Bio = json['Bio'];
    image = json['image'];
    cover = json['cover'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'uID' : uID,
      'Pass' : Pass,
      'image' : image,
      'Bio' : Bio,
      'cover' : cover,

    };
  }
}