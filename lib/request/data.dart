
import 'package:logger/logger.dart';

abstract class Data {
  String datatoJson(Data data);

  Map<String, dynamic> toJson();
}




class Format  {
  

  
  String? message;

  
  bool? success;
  dynamic D;
  var logger = Logger();

  Format.fromFields(this.message, this.success, this.D);
  Format.fromJson(Map<dynamic, dynamic> d) {
    message = d["message"];
    success = d['success'];
    D = d["D"];

    // initializeFromJson(json) ;
  }

  // static Format fromJson(String str) {

  // }
}
