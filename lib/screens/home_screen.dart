import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task.dart';
import 'tasks_screen.dart';  // Import the new screens
import 'calendar_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _taskController;
  List<Task> _tasks = [];
  List<bool> _tasksDone = [];
  int _selectedIndex = 0;  // Index to manage selected bottom navigation bar item

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

  // Define the list of screens to display
  final List<Widget> _screens = [
    TasksScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],  // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) => Padding(
            padding: MediaQuery.of(context).viewInsets, // Adjust the padding for the keyboard
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: 250,
                color: Colors.blue[200],
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make sure the column takes the minimum space required
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
                        children: [
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
        ),
      ),
    );
  }
}
