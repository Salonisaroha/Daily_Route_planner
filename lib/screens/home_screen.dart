import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _taskController;
  List<Task> _tasks = [];
  List<bool> _tasksDone = [];

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _getTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    list.add(json.encode(t.getMap()));
    prefs.setString('task', json.encode(list));
    _taskController.text = '';
    Navigator.of(context).pop();
    _getTasks();
  }

  void _getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    _tasks = list.map((task) => Task.fromMap(json.decode(task))).toList();
    _tasksDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  void updatePendingTasksList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i = 0; i < _tasks.length; i++) {
      if (!_tasksDone[i]) {
        pendingList.add(_tasks[i]);
      }
    }
    var pendingListEncoded = pendingList.map((task) => json.encode(task.getMap())).toList();
    prefs.setString('task', json.encode(pendingListEncoded));
    _getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: updatePendingTasksList,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('task', json.encode([]));
              _getTasks();
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text('No Tasks added yet!'),
            )
          : Column(
              children: _tasks.map((task) {
                int index = _tasks.indexOf(task);
                return Container(
                  height: 70.0,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  padding: const EdgeInsets.only(left: 10.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.task,
                        style: GoogleFonts.montserrat(),
                      ),
                      Checkbox(
                        value: _tasksDone[index],
                        onChanged: (val) {
                          setState(() {
                            _tasksDone[index] = val!;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(10.0),
            height: 250,
            color: Colors.blue[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add task',
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20.0),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(thickness: 1.2),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter task',
                    hintStyle: GoogleFonts.montserrat(),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children:  [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: Text('RESET', style: GoogleFonts.montserrat()),
                          onPressed: () => _taskController.text = '',
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: Text('ADD', style: GoogleFonts.montserrat()),
                          onPressed: saveData,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
