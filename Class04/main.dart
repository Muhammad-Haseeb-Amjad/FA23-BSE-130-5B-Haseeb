import 'package:flutter/material.dart';

void main() => runApp(ProfileSwitcherApp());

class ProfileSwitcherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileSwitcher(),
    );
  }
}

class ProfileSwitcher extends StatefulWidget {
  @override
  _ProfileSwitcherState createState() => _ProfileSwitcherState();
}

class _ProfileSwitcherState extends State<ProfileSwitcher> {
  bool showFirstProfile = true; // start with profile 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showFirstProfile ? Profile1() : Profile2(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showFirstProfile = !showFirstProfile; // toggle profiles
          });
        },
        child: Icon(Icons.switch_account, color: Colors.white),
        backgroundColor: Colors.blue,
        tooltip: "Switch Profile",
      ),
    );
  }
}

//////////////////////////////////
// Profile 1
//////////////////////////////////
class Profile1 extends StatefulWidget {
  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  Color bgColor = Colors.grey[100]!;
  int _currentIndex = 1;

  final String name = 'Muhammad Haseeb Amjad';
  final String designation = 'AI Flutter Developer';
  final String email = 'muhammadhaseebamjad90@gmail.com';
  final String address = '13/wb, Vehari';
  final String phone = '+92 328 7623023';

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: h * 0.05),

            // Theme Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThemeCircle(Colors.red),
                SizedBox(width: w * 0.05),
                _buildThemeCircle(Colors.green),
                SizedBox(width: w * 0.05),
                _buildThemeCircle(Colors.blue),
              ],
            ),
            SizedBox(height: h * 0.03),

            // Profile Picture
            CircleAvatar(
              radius: w * 0.2,
              backgroundImage: AssetImage("Image/haseeb.jpg"),
            ),
            SizedBox(height: h * 0.02),

            // Name
            Text(
              name,
              style: TextStyle(
                  fontSize: w * 0.055,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: h * 0.005),

            // Designation
            Text(
              designation,
              style: TextStyle(fontSize: w * 0.04, color: Colors.grey[700]),
            ),
            SizedBox(height: h * 0.02),

            // Contact Info Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.05),
              padding: EdgeInsets.all(w * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.email, "Email", email, w),
                  Divider(),
                  _buildInfoRow(Icons.home, "Address", address, w),
                  Divider(),
                  _buildInfoRow(Icons.phone, "Phone", phone, w),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildThemeCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          bgColor = color.withOpacity(0.2);
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 4),
          color: Colors.transparent,
        ),
        child: Icon(Icons.color_lens, color: color, size: 30),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, double w) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: w * 0.06),
        SizedBox(width: w * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: w * 0.035, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////
// Profile 2 (Responsive)
//////////////////////////////////
class Profile2 extends StatefulWidget {
  @override
  _Profile2State createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {
  String appBarTitle = "Profile";
  String name = "Muhammad Haseeb Amjad";
  String role = "AI Flutter Developer";
  String email = "muhammadhaseebamjad90@gmail.com";
  String phone = "+92 328 7623023";
  String address = "13/wb vehari";

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // AppBar
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(fontSize: w * 0.06)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue, size: w * 0.07),
            onPressed: () => _editAppBarName(context),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),

      // Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: h * 0.02),

            CircleAvatar(
              radius: w * 0.2,
              backgroundImage: AssetImage("Image/haseeb2.jpg"),
            ),
            SizedBox(height: h * 0.02),
            Text(name,
                style: TextStyle(
                    fontSize: w * 0.055, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(role, style: TextStyle(fontSize: w * 0.04, color: Colors.grey[600])),

            SizedBox(height: h * 0.025),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () => _editProfileDialog(context),
                    icon: Icon(Icons.edit, color: Colors.blue, size: w * 0.06),
                    label: Text("Edit", style: TextStyle(fontSize: w * 0.04)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: h * 0.015,
                        horizontal: w * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.03),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Settings Clicked")),
                    );
                  },
                  icon: Icon(Icons.settings, color: Colors.grey[700], size: w * 0.07),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Logged Out")),
                    );
                  },
                  icon: Icon(Icons.logout, color: Colors.red, size: w * 0.07),
                ),
              ],
            ),

            SizedBox(height: h * 0.03),

            _buildInfoCard(Icons.email, "Email", email, w),
            _buildInfoCard(Icons.phone, "Phone", phone, w),
            _buildInfoCard(Icons.location_on, "Address", address, w),

            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: w * 0.02),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: w * 0.06,
            backgroundColor: Colors.blue[50],
            child: Icon(icon, color: Colors.blue, size: w * 0.07),
          ),
          SizedBox(width: w * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: w * 0.035, color: Colors.grey[600])),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editProfileDialog(BuildContext context) {
    TextEditingController nameCtrl = TextEditingController(text: name);
    TextEditingController roleCtrl = TextEditingController(text: role);
    TextEditingController emailCtrl = TextEditingController(text: email);
    TextEditingController phoneCtrl = TextEditingController(text: phone);
    TextEditingController addressCtrl = TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: roleCtrl, decoration: InputDecoration(labelText: "Role")),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
              TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: "Phone")),
              TextField(controller: addressCtrl, decoration: InputDecoration(labelText: "Address")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = nameCtrl.text;
                role = roleCtrl.text;
                email = emailCtrl.text;
                phone = phoneCtrl.text;
                address = addressCtrl.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editAppBarName(BuildContext context) {
    TextEditingController appBarCtrl = TextEditingController(text: appBarTitle);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change AppBar Title"),
        content: TextField(controller: appBarCtrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                appBarTitle = appBarCtrl.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
