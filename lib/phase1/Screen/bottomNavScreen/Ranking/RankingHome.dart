import 'package:air_drops/phase1/customs/GoogleProgressBarC.dart';
import 'package:air_drops/phase1/style/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:air_drops/phase1/colors/UiColors.dart';

class RankinghomePage extends StatefulWidget {
  const RankinghomePage({super.key});

  @override
  State<RankinghomePage> createState() => _RankinghomePageState();
}

class _RankinghomePageState extends State<RankinghomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _fetchRankings() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('counter', descending: true)
          .limit(999)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      // print('Error fetching rankings: $e');
      return [];
    }
  }

  Future<int?> _fetchCurrentUserRank() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('counter', descending: true)
          .get();

      int rank = 1;
      for (var doc in snapshot.docs) {
        if (doc.id == currentUser.uid) {
          return rank;
        }
        rank++;
      }
      return null;
    } catch (e) {
      // print('Error fetching current user rank: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
        backgroundColor: Uicolor.appBar,
      ),
      backgroundColor: Uicolor.body,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRankings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: GoogleColorChangingProgressBar());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No rankings available yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            );
          }

          final rankings = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: rankings.length,
                  itemBuilder: (context, index) {
                    final user = rankings[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Uicolor.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            '#${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,

                              color: TextColorUi.normal_dark,
                            ),
                          ),
                          backgroundColor: Uicolor.white,
                        ),
                        title: Text(
                          '${user['firstName']} ${user['lastName']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "AIC Coins: ${user['counter'] ?? 0} \nAds Watched: ${user['adsWatched'] ?? 0},\nReferral : ${user['totalRefers'] ?? 0}"),
                        trailing: Text(
                          '${user['country']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              FutureBuilder<int?>(
                future: _fetchCurrentUserRank(),
                builder: (context, rankSnapshot) {
                  if (rankSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: GoogleColorChangingProgressBar(),
                    );
                  }

                  if (rankSnapshot.hasError || rankSnapshot.data == null) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Your rank could not be determined.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Uicolor.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Your Rank: #${rankSnapshot.data}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
