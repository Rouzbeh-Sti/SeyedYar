import 'dart:core';
import 'dart:ffi';
import 'dart:typed_data';

class Student {
    var students = <Student>{};
    var name;
    String? password;
    late Int studentID;
    Int courseCount = 0 as Int; // dars ha
    Int signedUnits = 0 as Int; //vahed ha
    private double totalAverage=0;
    private int currentAverage=0;
}