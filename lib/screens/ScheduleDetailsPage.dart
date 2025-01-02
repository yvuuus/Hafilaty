import 'package:flutter/material.dart';

class ScheduleDetailsPage extends StatefulWidget {
  final Map schedule;

  const ScheduleDetailsPage({Key? key, required this.schedule}) : super(key: key);

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  // A local state to track notification status
  final ValueNotifier<bool> _isNotified = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule['schedule_name'] ?? 'Schedule Details'),
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
                  "TRIP DETAILS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Departure: ${widget.schedule['depart'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Stop: ${widget.schedule['depart_address'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Leaves at: ${widget.schedule['depart_time'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),

                Text("Destination: ${widget.schedule['destination'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Destination Address: ${widget.schedule['destination_address'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                Text("Arrives at: ${widget.schedule['destination_time'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),

                Center(
                  child: Text("Price: ${widget.schedule['price'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),

                // Notify Me Button
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isNotified,
                    builder: (context, isNotified, child) {
                      return TextButton.icon(
                        onPressed: () {
                          _isNotified.value = !_isNotified.value; // Toggle the state
                        },
                        icon: Icon(
                          isNotified ? Icons.notifications_active : Icons.notifications_off,
                          color: isNotified ? const Color.fromARGB(255, 198, 151, 240) : Colors.grey,
                        ),
                        label: Text(
                          isNotified ? "Notified" : "Notify Me",
                          style: TextStyle(color: isNotified ?const Color.fromARGB(255, 198, 151, 240) : Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isNotified.dispose(); // Dispose the ValueNotifier when the widget is removed
    super.dispose();
  }
}
