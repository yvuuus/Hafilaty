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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GetData();
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
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
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 219, 194, 234),
                        borderRadius: BorderRadius.circular(15), // rounded corners
                      ),
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

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String departQuery = "";
  String destinationQuery = "";
  List<Map<String, dynamic>> searchResults = [];

  Future<void> fetchSearchResults() async {
    try {
      var url = 'http://192.168.56.1/project/crud/search.php';
      var res = await http.post(Uri.parse(url), body: {
        'depart': departQuery,
        'destination': destinationQuery,
      });

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body) as List;
        setState(() {
          searchResults = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        print("Error fetching search results: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching search results: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Schedules'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                departQuery = value;
              },
              decoration: InputDecoration(
                labelText: "Depart",
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                destinationQuery = value;
              },
              decoration: InputDecoration(
                labelText: "Destination",
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: fetchSearchResults,
            child: const Text("Search"),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? const Center(child: Text("No results found"))
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var schedule = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScheduleDetailsPage(schedule: schedule),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 219, 194, 234),
                              borderRadius: BorderRadius.circular(15), // rounded corners
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${schedule["depart"]}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "${schedule["depart_time"]}",
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
                                        "${schedule["destination"]}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "${schedule["destination_time"]}",
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
          ),
        ],
      ),
    );
  }
}
