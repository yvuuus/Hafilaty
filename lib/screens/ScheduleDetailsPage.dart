import 'package:flutter/material.dart';

class ScheduleDetailsPage extends StatelessWidget {
  final Map schedule;

  const ScheduleDetailsPage({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schedule['schedule_name'] ?? 'Schedule Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Schedule Name: ${schedule['schedule_name'] ?? 'N/A'}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Depart: ${schedule['depart'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Depart Time: ${schedule['depart_time'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("Destination: ${schedule['destination'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Destination Time: ${schedule['destination_time'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("Depart Address: ${schedule['depart_address'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Destination Address: ${schedule['destination_address'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("Price: ${schedule['price'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("Notifications: ${schedule['notification'] == "1" ? "On" : "Off"}", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
