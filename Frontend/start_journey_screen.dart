import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_data.dart';

class StartJourneyScreen extends StatefulWidget {
  @override
  _StartJourneyScreenState createState() => _StartJourneyScreenState();
}

class _StartJourneyScreenState extends State<StartJourneyScreen> {
  List<Map<String, dynamic>> journeys = []; // List to store journey data

  @override
  void initState() {
    super.initState();
    fetchJourneys(); // Fetch journeys when the screen initializes
  }

  // Fetch journeys from the server
  Future<void> fetchJourneys() async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/getText/' + UserData.userId)
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        journeys = data.map<Map<String, dynamic>>((text) => text).toList();
      });
    } else {
      throw Exception('Failed to load journeys');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Journeys",
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold, // Bold
            fontSize: 30, // Increased font size
          ),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/'); // Navigate to the login screen
          },
        ),
      ),
      backgroundColor: Colors.greenAccent, // Green accent background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          SizedBox(height: 20),
          journeys.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome To JourneyMan',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: journeys.map((journey) {
                return ElevatedButton(
                  onPressed: () {
                    //Navigate to the daily task page and pass the journey as a parameter
                    String? journeyString = journey['journey'];
                    if (journeyString != null) {
                      List<String> roadmapList = journeyString
                          .split("Day ")
                          .map((day) => day.trim())
                          .toList();

                      DateTime today = DateTime.now();

                      String formattedTodayDate =
                          "${today.year}-${today.month}-${today.day}";

                      String startDateString = journey['start_date'];

                      DateTime x = DateTime.parse(startDateString);

                      DateTime startDate =
                      DateTime.parse(startDateString);
                      int adjustedDifferenceInDays =
                          today.difference(startDate).inDays + 1;

                      print(roadmapList[adjustedDifferenceInDays]);

                      // Set the topic in UserData
                      UserData.updateTopic(journey['topic']);

                      Navigator.pushNamed(context, '/dailyTask',
                          arguments: roadmapList[adjustedDifferenceInDays].substring(2));
                    } else {
                      print(
                          "Error: journey data is not in the correct format");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        journey['topic'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25, // Increased font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(
            height: 100, // Increased height
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/home'); // Navigate to the home screen
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: Text(
                    'Start a New Journey',
                    style: TextStyle(
                      fontSize: 24, // Increased font size
                      fontWeight: FontWeight.bold, // Bold
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
