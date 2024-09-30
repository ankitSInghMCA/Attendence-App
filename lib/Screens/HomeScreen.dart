import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thepetnest/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Map<int, DateTime?> selectedDates = {};
  late Future<List<User>> futureUsers;
  late Future<List<JourneyData>> futureJourneys;

   String selectedUserName = 'Select User';
  String selectedEmail = 'No Email Selected';
  String selectedImage = '';

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
  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
    futureJourneys = fetchJourneys();
  }

  List<JourneyData> getJourneysForSelectedDate(int userId, DateTime selectedDate, List<JourneyData> journeys) {
    String formattedDate = "${selectedDate.toLocal()}".split(' ')[0]; // Format the date to YYYY-MM-DD

    // Filter journeys based on userId and selected date
    return journeys.where((journey) => journey.userId == userId && journey.journeyDate == formattedDate).toList();
  }

  Future<void> openGoogleMap(List<String> waypoints, String destination) async {
    String waypointsQuery = waypoints.map((waypoint) => Uri.encodeComponent(waypoint)).join('|');
    String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$waypointsQuery&destination=${Uri.encodeComponent(destination)}&waypoints=$waypointsQuery';
    final Uri url = Uri.parse(googleMapsUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.9.135:8082/apis/user/allUsers'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<JourneyData>> fetchJourneys() async {
    final response = await http.get(Uri.parse('http://192.168.9.135:8082/apis/user/journeys'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((journey) => JourneyData.fromJson(journey)).toList();
    } else {
      throw Exception('Failed to load journeys');
    }
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
      body: SingleChildScrollView(
      child: Column(
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
      SingleChildScrollView(
      child: Column(
      children: [
        FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final users = snapshot.data!;
              return FutureBuilder<List<JourneyData>>(
                future: futureJourneys,
                builder: (context, journeySnapshot) {
                  if (journeySnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (journeySnapshot.hasError) {
                    return Center(child: Text('Error: ${journeySnapshot.error}'));
                  } else {
                    final journeys = journeySnapshot.data!;
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.7, // Set a fixed height
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final selectedDate = selectedDates[user.userId];
                          
                          // Get journeys for the selected date, if available
                          final userJourneys = selectedDate != null
                              ? getJourneysForSelectedDate(user.userId, selectedDate, journeys)
                              : [];
                          
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: userJourneys.isNotEmpty
                                            ? NetworkImage(userJourneys.first.image)
                                            : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              user.userName,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              user.userId.toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            SizedBox(width: 100),
                                            GestureDetector(
                                              onTap: () async {
                                                DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101),
                                                );
                        
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    selectedDates[user.userId] = pickedDate; // Update the selected date for the specific user
                                                  });
                                                  print('Selected date for user ${user.userId}: ${pickedDate.toLocal()}'.split(' ')[0]);
                                                }
                                              },
                                              child: SizedBox(
                                                child: Image.asset(
                                                  'assets/images/calendar.png',
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            // Display the selected date if it is not null
                                            Text(
                                              selectedDates[user.userId] == null
                                                  ? 'No date'
                                                  : '${selectedDates[user.userId]!.toLocal().toString().split(' ')[0]}', // Format the date as needed
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      SizedBox(
                                        child: Image.asset(
                                          'assets/images/send.png',
                                          height: 15,
                                          width: 15,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(userJourneys.isNotEmpty ? userJourneys.first.startedTime : 'N/A'),
                                      SizedBox(width: 40),
                                      Row(
                                          children: [
                                            SizedBox(
                                              child: Image.asset(
                                                userJourneys.isNotEmpty && (userJourneys.first.completedTime == '08:45:00' || userJourneys.first.completedTime == '10:30:00' || userJourneys.first.completedTime == '07:30:00' || userJourneys.first.completedTime == '10:15:00' || userJourneys.first.completedTime == '09:00:00')
                                                    ? 'assets/images/check.png'
                                                    : 'assets/images/receive.png',
                                                height: 15,
                                                width: 15,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              userJourneys.isNotEmpty
                                                  ? (userJourneys.first.completedTime == '08:45:00' || userJourneys.first.completedTime == '10:30:00' || userJourneys.first.completedTime == '07:30:00' || userJourneys.first.completedTime == '10:15:00' || userJourneys.first.completedTime == '09:00:00'
                                                      ? 'Working'
                                                      : userJourneys.first.completedTime)
                                                  : 'N/A',
                                              style: TextStyle(
                                                color: userJourneys.isNotEmpty && (userJourneys.first.completedTime == '08:45:00' || userJourneys.first.completedTime == '10:30:00' || userJourneys.first.completedTime == '07:30:00' || userJourneys.first.completedTime == '10:15:00' || userJourneys.first.completedTime == '09:00:00')
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),

                                      SizedBox(width: 90),
                                      GestureDetector(
                                        onTap: () {
                                          if (userJourneys.isNotEmpty) {
                                            List<String> waypoints = userJourneys.first.visitedLocation;
                                            String destination = userJourneys.first.currentLocation;
                                            openGoogleMap(waypoints, destination);
                                          }
                                        },
                                        child: SizedBox(
                                          child: Image.asset(
                                            'assets/images/location.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            }
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
class User {
  final int userId;
  final String userName;
  final String email;
  final String password;

  User({
    required this.userId,
    required this.userName,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      email: json['email'],
      password: json['password'],
    );
  }
}

// Journey model class
class JourneyData {
  final int id;
  final int userId;
  final String journeyDate;
  final String currentLocation;
  final String startedLocation;
  final List<String> visitedLocation;
  final String totalDistance;
  final String image;
  final String startedTime;
  final String completedTime;

  JourneyData({
    required this.id,
    required this.userId,
    required this.journeyDate,
    required this.currentLocation,
    required this.startedLocation,
    required this.visitedLocation,
    required this.totalDistance,
    required this.image,
    required this.startedTime,
    required this.completedTime,
  });

  factory JourneyData.fromJson(Map<String, dynamic> json) {
    return JourneyData(
      id: json['id'],
      userId: json['user_id'],
      journeyDate: json['journey_date'],
      currentLocation: json['current_location'],
      startedLocation: json['started_location'],
      visitedLocation: List<String>.from(json['visited_location']),
      totalDistance: json['total_distance'],
      image: json['image'],
      startedTime: json['started_time'],
      completedTime: json['completed_time'],
    );
  }
}

