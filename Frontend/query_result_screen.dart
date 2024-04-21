import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_data.dart';

class QueryResultScreen extends StatefulWidget {
  @override
  _QueryResultScreenState createState() => _QueryResultScreenState();
}

class _QueryResultScreenState extends State<QueryResultScreen> {
  List<Map<String, dynamic>> journeys = []; // List to store journey data

  @override
  void initState() {
    super.initState();
    fetchJourneys(); // Fetch journeys when the screen initializes
  }

  // Fetch journeys from the server
  Future<void> fetchJourneys() async {
    final response =
    await http.get(Uri.parse('http://localhost:3000/getText/' + UserData.userId));
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
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null || args.isEmpty || args['topic'] == null) {
      // Handle if arguments are null or empty or if topic is null
      return Scaffold(
        body: Center(
          child: Text('No arguments passed or topic is null'),
        ),
      );
    }

    final String queryText = args['queryText'];
    final String topic = args['topic'];

    List<String> roadmapList =
    queryText.split("Day ").map((day) => day.trim()).toList();
    roadmapList = roadmapList.sublist(1);

    return Scaffold(
      appBar: AppBar(
        title: Text("Here's Your RoadMap"),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < roadmapList.length; i++)
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: i % 2 == 0 ? Colors.grey[300] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day ${i + 1}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          roadmapList[i],
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Call the function to register roadmap
                      registerRoadMap(queryText, roadmapList, topic, context);
                      print(queryText);
                    },
                    child: Text("Implement"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to register roadmap
  // Function to register roadmap
  void registerRoadMap(String queryText, List<String> roadmapList, String topic,
      BuildContext context) async {
    try {
      // Calculate start date (today's date)
      DateTime startDate = DateTime.now();
      String formattedStartDate =
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";

      // Calculate end date (today's date + length of roadmapList)
      DateTime endDate = startDate.add(Duration(days: roadmapList.length));
      String formattedEndDate =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      // Update the UserData
      UserData.updateRoadmapList(roadmapList);

      // Make a POST request to your backend API
      final response = await http.post(
        Uri.parse('http://localhost:3000/createText'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': UserData.userId,
          'topic': topic,
          'journey': queryText,
          'start_date': formattedStartDate,
          'end_date': formattedEndDate,
          'completed_tasks':["wassup"]
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful
        UserData.updateTopic(topic);
        print('Roadmap registered successfully');
        UserData.updateStartDate(formattedStartDate);
        // Show a snackbar with congratulations message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congratulations! Roadmap registered successfully.'),
          ),
        );

        // Delay navigation to daily task page
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/dailyTask');
        });
      } else {
        // Registration failed
        print('Failed to register roadmap');
        // You can show an error message here
      }
    } catch (error) {
      print('Error: $error');
      // Handle any error that might occur
    }
  }

}
