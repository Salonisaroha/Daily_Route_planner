import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:daily_planner/constants/colors.dart';
import 'package:daily_planner/model/todo.dart';
import 'package:daily_planner/widgets/todo_item.dart';
import 'package:daily_planner/screens/dashboard.dart';
import 'package:daily_planner/screens/contacts.dart';
import 'package:daily_planner/screens/events.dart';
import 'package:daily_planner/screens/notes.dart';
import 'package:daily_planner/screens/settings.dart';
import 'package:daily_planner/screens/notifications.dart';
import 'package:daily_planner/screens/privacy_policy.dart';
import 'package:daily_planner/screens/send_feedback.dart';
import 'package:daily_planner/screens/my_header_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  var currentPage = DrawerSections.master_home;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget container;
    if (currentPage == DrawerSections.master_home && _currentIndex == 0) {
      container = const MasterHome();
    } else if (currentPage == DrawerSections.dashboard) {
      container = DashboardPage();
    } else if (currentPage == DrawerSections.contacts) {
      container = ContactsPage();
    } else if (currentPage == DrawerSections.events) {
      container = EventsPage();
    } else if (currentPage == DrawerSections.notes) {
      container = NotesPage();
    } else if (currentPage == DrawerSections.settings) {
      container = SettingsPage();
    } else if (currentPage == DrawerSections.notifications) {
      container = NotificationsPage();
    } else if (currentPage == DrawerSections.privacy_policy) {
      container = PrivacyPolicyPage();
    } else if (currentPage == DrawerSections.send_feedback) {
      container = SendFeedbackPage();
    } else if (_currentIndex == 0) {
      container = const MasterHome();
    } else if (_currentIndex == 1) {
      container = CalendarPage();
    } else if (_currentIndex == 2) {
      container = MinePage();
    } else {
      container = const MasterHome();
    }

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 157, 129, 234),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/avatar.jpeg'),
              ),
            ),
          ],
        ),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
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
            label: 'Mine',
          ),
        ],
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(
            1,
            "Home",
            Icons.home_outlined,
            currentPage == DrawerSections.master_home ? true : false,
          ),
          menuItem(
            2,
            "Dashboard",
            Icons.dashboard_outlined,
            currentPage == DrawerSections.dashboard ? true : false,
          ),
          menuItem(
            3,
            "Contacts",
            Icons.people_alt_outlined,
            currentPage == DrawerSections.contacts ? true : false,
          ),
          menuItem(
            4,
            "Events",
            Icons.event,
            currentPage == DrawerSections.events ? true : false,
          ),
          menuItem(
            5,
            "Notes",
            Icons.notes,
            currentPage == DrawerSections.notes ? true : false,
          ),
          Divider(),
          menuItem(
            6,
            "Settings",
            Icons.settings_outlined,
            currentPage == DrawerSections.settings ? true : false,
          ),
          menuItem(
            7,
            "Notifications",
            Icons.notifications_outlined,
            currentPage == DrawerSections.notifications ? true : false,
          ),
          Divider(),
          menuItem(
            8,
            "Privacy policy",
            Icons.privacy_tip_outlined,
            currentPage == DrawerSections.privacy_policy ? true : false,
          ),
          menuItem(
            9,
            "Send feedback",
            Icons.feedback_outlined,
            currentPage == DrawerSections.send_feedback ? true : false,
          ),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentPage = DrawerSections.values[id - 1];
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  master_home,
  dashboard,
  contacts,
  events,
  notes,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
}

class MasterHome extends StatefulWidget {
  const MasterHome({super.key});

  @override
  State<MasterHome> createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHome> {
  final TextEditingController _todoController = TextEditingController();
  List<ToDo> todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  void _addTodoItem(String todoText) {
    setState(() {
      todosList.add(
        ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoText: todoText,
          isDone: false,
        ),
      );
    });
    _todoController.clear();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((element) => element.id == id);
    });
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((element) => element.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  Widget _buildAPPbar() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Daily Route Planner',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    letterSpacing: 2.0,
                    
                    decorationColor:
                        Colors.deepPurpleAccent, 
                    decorationThickness: 1.5, 
                    
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              searchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 15,
                        bottom: 20,
                      ),
                      child: const Text(
                        'All ToDo\'s',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    for (ToDo todo in _foundToDo.reversed)
                      ToDoItem(
                        todo: todo,
                        onToDoChanged: _handleToDoChange,
                        onDeleteItem: _deleteToDoItem,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add a new todo item'),
                    content: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Enter todo',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _addTodoItem(_todoController.text);
                        },
                        child: Text('Add'),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Color.fromARGB(255, 157, 129, 234),
              foregroundColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}

class MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            // Navigate to Profile Page
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            // Navigate to Settings Page
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // Perform Logout
          },
        ),
      ],
    );
  }
}
