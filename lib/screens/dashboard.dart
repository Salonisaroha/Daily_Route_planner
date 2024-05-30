import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500, 
            height: 250, 
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dashboard.png'),
                fit: BoxFit.cover, 
              ),
            ),
          ),
          SizedBox(height: 16.0), 
          Expanded(
            child: ListView(
              children: [
                SectionTitle(title: "Today's Tasks"),
                ExpandedWidget(child: TodayTasksWidget()),
                SectionTitle(title: "Upcoming Tasks"),
                ExpandedWidget(child: UpcomingTasksWidget()),
                SectionTitle(title: "Overdue Tasks"),
                ExpandedWidget(child: OverdueTasksWidget()),
                SectionTitle(title: "Task Categories"),
                ExpandedWidget(child: TaskCategoriesWidget()),
                SectionTitle(title: "Quick Add Task"),
                ExpandedWidget(child: QuickAddTaskWidget()),
                SectionTitle(title: "Statistics/Progress"),
                ExpandedWidget(child: StatisticsProgressWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ExpandedWidget extends StatelessWidget {
  final Widget child;

  ExpandedWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}


class TodayTasksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Today\'s Tasks Content');
  }
}

class UpcomingTasksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Upcoming Tasks Content');
  }
}

class OverdueTasksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Overdue Tasks Content');
  }
}

class TaskCategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Task Categories Content');
  }
}

class QuickAddTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Quick Add Task Content');
  }
}

class StatisticsProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Statistics/Progress Content');
  }
}
