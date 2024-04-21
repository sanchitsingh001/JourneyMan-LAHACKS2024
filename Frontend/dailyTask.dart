import 'package:flutter/material.dart';
import 'user_data.dart';
import 'start_journey_screen.dart';

class DailyTaskPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    String? roadmapString =
    ModalRoute.of(context)?.settings.arguments as String?;

    int index = 0; // Initialize index to 0

    if (roadmapString == null) {
      String startDateString = UserData.startDate;
      DateTime x = DateTime.parse(startDateString);
      DateTime today = DateTime.now();

      // Calculate the index based on the difference between today's date and the start date
      index = today.difference(x).inDays;

      if (index >= 0 && index < UserData.roadmapList.length) {
        roadmapString = UserData.roadmapList[index];
      } else {
        roadmapString = "No task for today";
      }
    }

    roadmapString = roadmapString?.trim(); // Remove leading whitespace
    List<String> roadmapList = [];
    if (roadmapString != null) {
      roadmapList = roadmapString.split('- ');
      roadmapList = roadmapList.sublist(1);
    }
    print('Roadmap list:');
    print(roadmapList);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Task Checklist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24, // Increased font size
            color: Colors.white, // White color
          ),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StartJourneyScreen()),
            );
          },
        ),
      ),
      backgroundColor: Colors.greenAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Center( // Center the day number text horizontally
              child: Text(
                'Day ${index + 1}', // Display the calculated index
                style: TextStyle(
                  fontSize: 60, // Increased font size to 24
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Teal color
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              itemCount: roadmapList.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskItem(
                  title: roadmapList[index],
                  isChecked: false, // Set isChecked to false for all sample tasks
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

class TaskItem extends StatefulWidget {
  final String title;
  final bool isChecked;

  TaskItem({required this.title, required this.isChecked});

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(
          decoration: _isChecked ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      leading: Checkbox(
        value: _isChecked,
        onChanged: (newValue) {
          setState(() {
            _isChecked = newValue!;
          });
        },
      ),
    );
  }
}
