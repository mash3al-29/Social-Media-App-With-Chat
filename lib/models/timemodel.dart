class TimeModel{
  String datetime;

  TimeModel({
    this.datetime,
  });

  TimeModel.fromJson(Map<String,dynamic> json){
    datetime = json['datetime'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'datetime' : datetime,
    };
  }
}