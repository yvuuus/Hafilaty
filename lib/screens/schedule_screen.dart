import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ScheduleDetailsPage.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> list = [];
  List<String> Data = [];

  Future<void> GetData() async {
    try {
      var url = "http://192.168.56.1/project/crud/readSchedule.php";
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        var red = jsonDecode(res.body) as List;
        setState(() {
          list = red.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        print("Error fetching data: ${res.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  Future<void> Suggestion() async {
    try {
      var url = 'http://192.168.56.1/project/crud/suggestions.php';
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body) as List;
        setState(() {
          Data = data.map((item) => item['schedule_name'].toString()).toList();
        });
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GetData();
      await Suggestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchUsers(data: Data),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: list.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleDetailsPage(schedule: list[i]),
                        ),
                      );
                    },
                    child: Container(
                      color: const Color.fromARGB(255, 234, 194, 207),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${list[i]["depart"]}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "${list[i]["depart_time"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const Expanded(
                              child: Center(
                                child: Icon(Icons.arrow_forward),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${list[i]["destination"]}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "${list[i]["destination_time"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class SearchUsers extends SearchDelegate {
  final List<String> data;
  SearchUsers({required this.data});

  Future<Map<String, dynamic>?> GetScheduleData(String scheduleName) async {
    try {
      var url = 'http://192.168.56.1/project/crud/search.php';
      var res = await http.post(Uri.parse(url), body: {'query': scheduleName});

      if (res.statusCode == 200) {
        var scheduleData = jsonDecode(res.body) as List;
        return scheduleData.isNotEmpty ? scheduleData[0] as Map<String, dynamic> : null;
      }
    } catch (e) {
      print("Error fetching schedule data: $e");
    }
    return null;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: GetScheduleData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("No results found"));
        }

        var schedule = snapshot.data as Map<String, dynamic>;
        return ListTile(
          title: Text(schedule['schedule_name']),
          subtitle: Text('${schedule['depart']} to ${schedule['destination']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleDetailsPage(schedule: schedule),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = query.isEmpty
        ? data
        : data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            var selected = suggestions[index];
            var schedule = await GetScheduleData(selected);

            if (schedule != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduleDetailsPage(schedule: schedule),
                ),
              );
            }
          },
          leading: const Icon(Icons.bus_alert_outlined),
          title: Text(suggestions[index]),
        );
      },
    );
  }
}
