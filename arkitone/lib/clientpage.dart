import 'package:flutter/material.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  bool showCompletedTasks = false;

  final List<Map<String, String>> incompleteTasks = [
    {'name': 'Aditya Avi', 'location': 'Lucknow', 'phone': '9336063710'},
    {'name': 'Yuva Yashvin', 'location': 'Trichy', 'phone': '8778044994'},
    {'name': 'Yuvraj', 'location': 'Delhi', 'phone': '9818378372'},
    {'name': 'Chinamy', 'location': 'Bengaluru', 'phone': '9563148521'},
    {'name': 'Abiram', 'location': 'Chennai', 'phone': '9564771875'},
  ];

  final List<Map<String, String>> completedTasks = [
    {'name': 'Aditya Avi', 'location': 'Lucknow', 'phone': '9336063710'},
    {'name': 'Yuvraj', 'location': 'Delhi', 'phone': '9818378372'},
    {'name': 'Yuva Yashvin', 'location': 'Trichy', 'phone': '8778044994'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Ram !!'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showCompletedTasks ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        showCompletedTasks = false;
                      });
                    },
                    child: Text('Your Tasks'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCompletedTasks ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        showCompletedTasks = true;
                      });
                    },
                    child: Text('Completed Tasks'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: showCompletedTasks
                  ? completedTasks.length
                  : incompleteTasks.length,
              itemBuilder: (context, index) {
                final task = showCompletedTasks
                    ? completedTasks[index]
                    : incompleteTasks[index];
                return Card(
                  color: showCompletedTasks ? Colors.green[100] : Colors.amber,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Client Name: ${task['name']}'),
                        Text('Location: ${task['location']}'),
                        Text('Phone: ${task['phone']}'),
                      ],
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