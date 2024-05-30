import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Center(
            child: Text(
              "Events Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Event Reminder 1'),
                  subtitle: Text('Details about event reminder 1'),
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Event Reminder 2'),
                  subtitle: Text('Details about event reminder 2'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
