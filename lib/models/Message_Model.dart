class MessageModel{
  String senderid;
  String recieverid;
  String datetime;
  String text;
  String image;

  MessageModel({
    this.senderid,
    this.recieverid,
    this.datetime,
    this.text,
    this.image,
  });

  MessageModel.fromJson(Map<String,dynamic> json){
    senderid = json['senderid'];
    recieverid = json['recieverid'];
    datetime = json['datetime'];
    text = json['text'];
    image = json['image'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'senderid' : senderid,
      'recieverid' : recieverid,
      'datetime' : datetime,
      'text' : text,
      'image' : image,
    };
  }
}