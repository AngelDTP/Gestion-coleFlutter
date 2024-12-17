import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalendarProvider with ChangeNotifier {
  final Uri _url = Uri.parse('https://us-central1-cegep-al.cloudfunctions.net/calendrier');
  Map<String, dynamic> _calendar = {};

  Future<Map<String, dynamic>> loadSchoolCalendar() async {
    try {
      var response = await http.get(_url);
      if (response.statusCode == 200) {
        var jsonPayload = json.decode(utf8.decode(response.bodyBytes));
        _calendar = jsonPayload as Map<String, dynamic>;
        notifyListeners();
        
        return _calendar;
      } else {
        print('Failed to load calendar: HTTP ${response.statusCode}');
        throw Exception('Failed to load calendar');
      }
    } catch (error) {
      print('Error loading calendar: $error');
      throw Exception('Error loading calendar: $error');
    }
  }

  Map<String, dynamic> get getCalendar => _calendar;

  Map<String, dynamic> getCalendarSchoolDays() {
    Map<String, dynamic> schoolDays = {};

    _calendar.forEach((key, value) {
      if (value['special'] == "") {
        schoolDays[key] = value;
      }
    });

    return schoolDays;
  }
}
