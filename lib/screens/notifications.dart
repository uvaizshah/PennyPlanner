import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationItem(
            title: notifications[index]["title"]!,
            message: notifications[index]["message"]!,
            time: notifications[index]["time"]!,
          );
        },
      ),
    );
  }
}

// Notification Item Widget
class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const NotificationItem({super.key, required this.title, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 5),
            Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        leading: const Icon(Icons.notifications, color: Color(0xFFE91E63)),
      ),
    );
  }
}

// Dummy Notification Data
final List<Map<String, String>> notifications = [
  {"title": "Budget Alert", "message": "You've spent 80% of your food budget!", "time": "10 mins ago"},
  {"title": "Payment Reminder", "message": "Your rent is due tomorrow.", "time": "2 hours ago"},
  {"title": "Savings Update", "message": "Your monthly savings target is on track!", "time": "Yesterday"},
];
