import 'package:flutter/material.dart';

class UserData {
  static String userId = ''; // Initialize with empty string
  static List<String> roadmapList = []; // Initialize with empty list
  static String startDate = ''; // Initialize with empty string
  static String topic = ''; // Initialize with empty string

  // Function to update userId
  static void updateUserId(String newUserId) {
    userId = newUserId;
  }

  // Function to update roadmapList
  static void updateRoadmapList(List<String> newList) {
    roadmapList = newList;
  }

  // Function to update start_date
  static void updateStartDate(String newStartDate) {
    startDate = newStartDate;
  }

  // Function to update topic
  static void updateTopic(String newTopic) {
    topic = newTopic;
  }
}
