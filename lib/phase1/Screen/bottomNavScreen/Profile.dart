import 'package:air_drops/phase1/customs/GoogleProgressBarC.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:air_drops/phase1/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:air_drops/phase1/auth/auth_page.dart';
import 'package:air_drops/phase1/colors/UiColors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = AuthService().currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      final userId = user?.uid;

      // Fetch user data from Firebase 'users' collection
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      setState(() {
        userData = doc.data();
      });

      // Backup the data to Firebase and Supabase
      if (userData != null) {
        await _backupUserData(userId);
        await _backupUserDataToSupabase(userId); // Backup to Supabase
      }
    }
  }

  // Function to back up user data to Firebase
  Future<void> _backupUserData(String? userId) async {
    if (userId != null && userData != null) {
      try {
        await FirebaseFirestore.instance.collection('userBackups').doc(userId).set({
          'email': user?.email,
          'country': userData?['country'],
          'adsWatched': userData?['adsWatched'],
          'totalRefers': userData?['totalRefers'],
          'CoinBalance': userData?['counter'],
        });
      } catch (e) {
        print("Error backing up user data to Firebase: $e");
      }
    }
  }

  // Function to back up user data to Supabase
  Future<void> _backupUserDataToSupabase(String? userId) async {
    if (userId != null && userData != null) {
      try {
        final supabase = Supabase.instance.client;

        // Insert user data into Supabase table (assuming 'user_backups' table exists)
        final response = await supabase.from('user_backups').upsert({
          'user_id': userId,
          'email': user?.email,
          'country': userData?['country'],
          'ads_watched': userData?['adsWatched'],
          'total_refers': userData?['totalRefers'],
        });

        if (response.error != null) {
          print("Error backing up user data to Supabase: ${response.error!.message}");
        } else {
          print("User data successfully backed up to Supabase.");
        }
      } catch (e) {
        print("Error backing up user data to Supabase: $e");
      }
    }
  }
  Future<void> _emailbackup(String? userId) async {
    if (userId != null && userData != null) {
      try {
        final supabase = Supabase.instance.client;

        // Insert user data into Supabase table (assuming 'user_backups' table exists)
        final response = await supabase.from('user_backups').upsert({
          'user_id': userId,
          'email': user?.email,
          'country': userData?['country'],
          'ads_watched': userData?['adsWatched'],
          'total_refers': userData?['totalRefers'],
        });

        if (response.error != null) {
          print("Error backing up user data to Supabase: ${response.error!.message}");
        } else {
          print("User data successfully backed up to Supabase.");
        }
      } catch (e) {
        print("Error backing up user data to Supabase: $e");
      }
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Uicolor.appBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileInfoCard(context),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () async {
                    _launchURL('https://aicnc.netlify.app/policy/aic-coin-policy');
                  },
                  child: const Text(
                    "Read our Privacy Policy",
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.blueAccent, fontSize: 24),
                  ),
                ),
              ),
              const Center(child: Text("App Version: 21")),
              const Center(child: Text("Build Version: 1.21.2025-01")),
              const SizedBox(height: 20),
              const Text("Connect your Wallet", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Coming Soon",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.teal,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userData == null
            ? const Center(child: GoogleColorChangingProgressBar())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfoRow(Icons.person, 'Name', '${userData?['firstName'] ?? 'xxxxxxxx'} ${userData?['lastName'] ?? 'yyyyyyy'}'),
                  const Divider(),
                  _buildProfileInfoRow(Icons.email, 'Email', user?.email ?? 'xxxxxxxx'),
                  const Divider(),
                  _buildProfileInfoRow(Icons.flag, 'Country', userData?['country'] ?? 'xxxxxxxx'),
                  const Divider(),
                  _buildProfileInfoRow(Icons.code, 'Referral Code', userData?['referralCode'] ?? 'xxxxxxxxxx'),
                  const Divider(),
                  _buildProfileInfoRow(Icons.check_circle, 'Total Tasks Completed', (userData?['taskCounter'] ?? '-').toString()),
                  const Divider(),
                  _buildProfileInfoRow(Icons.play_circle, 'Total Ads Watched', (userData?['adsWatched'] ?? '-').toString()),
                  const Divider(),
                  _buildProfileInfoRow(Icons.play_circle, 'Total Invites', (userData?['totalRefers'] ?? '0').toString()),
                  const Divider(),
                  _buildProfileInfoRow(Icons.monetization_on, 'AIC Earned', (userData?['counter'] ?? '0').toString()),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
