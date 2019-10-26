import 'package:firebase_database/firebase_database.dart';

//needs lots of work

class Calendar {
  String key;
  String day;
  String hour;
  bool completed;
  bool repeatdaily;
  String userId;


  Calendar(this.day, this.hour, this.userId, this.completed, this.repeatdaily);

  Calendar.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    day = snapshot.value["day"],
    hour = snapshot.value["hour"],
    completed = snapshot.value["completed"],
    repeatdaily = snapshot.value["repeatdaily"];

  toJson() {
    return {
      "userId": userId,
      "day": day,
      "hour": hour,
      "completed": completed,
      "repeatdaily": repeatdaily,

    };
  }

  
}
