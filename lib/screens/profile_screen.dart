import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture and Details
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with actual image URL
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Edit Profile screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 20),
            // Settings and Privacy Sections
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.account_circle, color: Colors.blueAccent),
                    title: Text('Account'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Account Settings
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Colors.blueAccent),
                    title: Text('Notifications'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Notifications Settings
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip, color: Colors.blueAccent),
                    title: Text('Privacy'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Privacy Settings
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.blueAccent),
                    title: Text('Help & Support'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Support
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.red),
                    onTap: () {
                      // Implement Logout functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

