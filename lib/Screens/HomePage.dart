import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:thepetnest/Screens/HomeScreen.dart';
import 'package:thepetnest/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedUserName = 'Select User';
  String selectedEmail = 'No Email Selected';

  final List<Widget> _pages = [
    // Add placeholder widgets or the actual screens here
    Homepage(),  // Placeholder for Pickupdelivery screen           // Placeholder for Mywallet screen
    Homescreen(),          // Placeholder for ProfileScreen
  ];

    Future<List<Map<String, dynamic>>> fetchUsers1() async {
    final response = await http.get(Uri.parse('http://192.168.9.135:8082/apis/user/allUsers'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => {
        'user_name': user['user_name'],
        'email': user['email'],
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
  void _showUserDialog() async {
    List<Map<String, dynamic>> users = await fetchUsers1();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a User'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    setState(() {
                      selectedUserName = users[index]['user_name'];
                      selectedEmail = users[index]['email'];
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '${users[index]['user_name']} - ${users[index]['email']}',
                    style: GoogleFonts.nunito(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  List<JourneyData> getJourneysForSelectedDate(int userId, DateTime selectedDate, List<JourneyData> journeys) {
    String formattedDate = "${selectedDate.toLocal()}".split(' ')[0]; // Format the date to YYYY-MM-DD

    // Filter journeys based on userId and selected date
    return journeys.where((journey) => journey.userId == userId && journey.journeyDate == formattedDate).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey[300], toolbarHeight: 5,),
      drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 2,
                        child: SizedBox(
                          height: 50, 
                          width: 140,
                          child: Image.asset(
                            'assets/images/workstatus2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 0,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person, 
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 12),
                          Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: selectedUserName.isNotEmpty ? selectedUserName : "Default Name\n",
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n${selectedEmail}'.isNotEmpty ? '\n${selectedEmail}' : "default@example.com",
                                    style: GoogleFonts.nunito(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(Icons.timer, 'Timer', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.book, 'Attendance', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),

                _buildDrawerItem(Icons.local_activity, 'Activity', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.timelapse, 'Timesheet', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.report, 'Report', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.web, 'Jobsite', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.group, 'Team', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.offline_bolt, 'Time off', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.schedule_send_sharp, 'Schedules', () {
                  Navigator.pop(context);
                }),
                SizedBox(height: 10,),
                _buildDrawerItem(Icons.request_quote, 'Request to join Organization', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.password_outlined, 'Change Password', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.logout, 'Logout', () {
                  Navigator.pop(context);
                }),
                SizedBox(height: 10,),
                _buildDrawerItem(Icons.query_builder, 'FAQ & Help', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.privacy_tip, 'Privacy Policy', () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.verified_user_outlined, 'Version:2. 10(1)', () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ),
      body: Column(
        children: [
          _buildHeader(),
          Container(
        height: 70,
        width: double.infinity,
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              IconButton(
                icon: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/group.png',
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              SizedBox(width: 2),
              Text(
                "All Members",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10),
              child: Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedUserName,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          height: 1.0, // Adjust the height for tighter spacing
                        ),
                      ),
                      TextButton(
                        onPressed: _showUserDialog,
                        child: Text(
                          'Change',
                          style: GoogleFonts.nunito(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('assets/images/mobilelocation.jpg'),
                  fit: BoxFit.cover,  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDrawerItem(IconData? icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title,
        style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildHeader() {
    return Container(
  height: 60,
  width: double.infinity,
  color: Colors.blue,
  child: Align(
  alignment: Alignment.centerLeft,
  child: Builder(
    builder: (BuildContext context) {
      return Row(
        children: [
          IconButton(
          icon: Image.asset(
            'assets/images/menu.png',
            height: 24,
            width: 24,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        Text("ATTENDANCE",
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        ],
      );
    },
  ),
)
);
}
}