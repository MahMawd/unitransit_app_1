import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: const NotificationList(),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }/* else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }*/ else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No notifications available'));
        } else {
          return FutureBuilder<List<String>>(
            future: _fetchSubscribedTrips(), // Fetch subscribed trips
            builder: (context, tripsSnapshot) {
              if (tripsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }/* else if (tripsSnapshot.hasError) {
                return Center(child: Text('Error: ${tripsSnapshot.error}'));
              } */else {
                List<String> subscribedTrips = tripsSnapshot.data ?? [];
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    var notification = snapshot.data!.docs[index];
                    // Check if the notification's trip is in the user's subscribed trips
                    if (subscribedTrips.contains(notification['voyageId'])) {
                      return NotificationListItem(
                        message: notification['message'],
                        time: notification['time'],
                        title: notification['title'],
                      );
                    } else {
                      print("herelalal");
                      // Return an empty container if the user is not subscribed to this trip
                      return Container();
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Future<List<String>> _fetchSubscribedTrips() async {
    // Fetch subscribed trips from the 'etudiant' collection
    String userId = FirebaseAuth.instance.currentUser!.uid; // Replace 'user_id' with the actual user ID
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('etudiant').doc(userId).get();
    List<dynamic> voyages = userSnapshot.data()?['voyages'] ?? [];
    List<String> subscribedTrips = voyages.map((voyage) => voyage['voyageId'] as String).toList();
    return subscribedTrips;
  }
}

class NotificationListItem extends StatelessWidget {
  final String message;
  final String title;
  final String time;

  const NotificationListItem({
    super.key, 
    required this.message,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: const Icon(Icons.notifications, size: 25, color: Colors.black),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

