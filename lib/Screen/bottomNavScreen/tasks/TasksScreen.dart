import 'package:air_drops/colors/UiColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To convert JSON data


class TasksScreenPage extends StatefulWidget {
  const TasksScreenPage({super.key});

  @override
  State<TasksScreenPage> createState() => _TasksScreenPageState();
}

class _TasksScreenPageState extends State<TasksScreenPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  int _counter = 0; // Total points counter
  int _taskCounter = 0; // Total task completion counter
  List<Task> _tasks = []; // List to store tasks

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load points counter when screen is initialized
    _loadTaskCounter(); // Load task completion counter
    _initializeTasksOnline(); //Tasks from online
  }

  // Method to load points counter from Firestore
  Future<void> _loadCounter() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
        if (doc.exists) {
          setState(() {
            _counter = doc['counter'] ?? 0; // Set total points from Firestore
          });
        }
      }
    } catch (error) {
      _showErrorDialog("Error loading points", error.toString());
    }
  }

  // Method to load the task completion counter from Firestore
  Future<void> _loadTaskCounter() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get(); // Get user document
        if (doc.exists) {
          setState(() {
            _taskCounter = doc['taskCounter'] ?? 0; // Load task completion counter
          });
        }
      }
    } catch (error) {
      _showErrorDialog("Error loading task counter", error.toString());
    }
  }

//   Future<void> _initializeTasksOnline() async {
//   const String url = 'https://6712859b840ac760b0a76b0e--aicnc.netlify.app/tasksaic.json'; // JSON URL
//   try {
//     final response = await http.get(Uri.parse(url)); // Fetch JSON data
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body); // Parse JSON as a Map
//       // Check if the map contains a 'tasks' key with a list of tasks
//       if (data.containsKey('tasks')) {
//         setState(() {
//           _tasks = (data['tasks'] as List).map((task) => Task.fromJson(task)).toList(); // Convert JSON to Task objects
//         });
//       } else {
//         _showErrorDialog("Error", "Invalid JSON structure: 'tasks' key not found");
//       }
//     } else {
//       _showErrorDialog("Error", "Failed to load tasks from server");
//     }
//   } catch (error) {
//     _showErrorDialog("Error", error.toString());
//   }
// }

Future<void> _initializeTasksOnline() async {
    const String url = 'https://aicnc.netlify.app/tasksaic.json'; // Example URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('tasks')) {
          setState(() {
            _tasks = (data['tasks'] as List).map((task) => Task.fromJson(task)).toList();
          });
          _loadTaskStatus(); // After loading tasks, listen for real-time updates
        }
      } else {
        _showErrorDialog("Error", "Failed to load tasks from server");
      }
    } catch (error) {
      _showErrorDialog("Error", error.toString());
    }
  }


  // Method to load task claimed status with Firestore real-time listener
  // Future<void> _loadTaskStatus() async {
  //   try {
  //     User? user = _auth.currentUser; // Get the current user
  //     if (user != null) {
  //       for (Task task in _tasks) {
  //         _firestore
  //             .collection('users')
  //             .doc(user.uid)
  //             .collection('tasks')
  //             .doc(task.taskId)
  //             .snapshots() // Set up real-time listener for task document
  //             .listen((DocumentSnapshot snapshot) {
  //           if (snapshot.exists) {
  //             setState(() {
  //               task.isClaimed = snapshot['claimed'] ?? false; // Update task claimed status in real-time
  //             });
  //           }
  //         });
  //       }
  //     }
  //   } catch (error) {
  //     _showErrorDialog("Error loading task status", error.toString());
  //   }
  // }


//   Future<void> _loadTaskStatus() async {
//   try {
//     User? user = _auth.currentUser; // Get the current user
//     if (user != null) {
//       for (Task task in _tasks) {
//         // Get the claimed status for each task in real-time
//         _firestore
//             .collection('users')
//             .doc(user.uid)
//             .collection('tasks')
//             .doc(task.taskId)
//             .snapshots()
//             .listen((DocumentSnapshot snapshot) {
//           if (snapshot.exists) {
//             setState(() {
//               task.isClaimed = snapshot['claimed'] ?? false; // Set claimed status from Firestore
//             });
//           }
//         });
//       }
//     }
//   } catch (error) {
//     _showErrorDialog("Error loading task status", error.toString());
//   }
// }


Future<void> _loadTaskStatus() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        for (Task task in _tasks) {
          _firestore
              .collection('users')
              .doc(user.uid)
              .collection('tasks')
              .doc(task.taskId)
              .snapshots() // Real-time Firestore listener
              .listen((DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              setState(() {
                task.isClaimed = snapshot['claimed'] ?? false; // Update claimed status in real-time
              });
            }
          });
        }
      }
    } catch (error) {
      _showErrorDialog("Error loading task status", error.toString());
    }
  }


  // Method to check and claim reward for a task
  // void _claimReward(Task task) async {
  //   User? user = _auth.currentUser; // Get the current user
  //   if (user != null) {
  //     try {
  //       // Check if the task is already claimed in Firestore
  //       DocumentSnapshot doc = await _firestore
  //           .collection('users')
  //           .doc(user.uid)
  //           .collection('tasks')
  //           .doc(task.taskId)
  //           .get();

  //       if (doc.exists && doc['claimed'] == true) {
  //         // Task has already been claimed, show a dialog
  //         _showErrorDialog("Task already claimed", "You have already claimed the reward for this task.");
  //       } else {
  //         // Task has not been claimed, proceed with claiming
  //         setState(() {
  //           _counter += task.reward; // Update points counter
  //           _taskCounter += 1; // Increment task completion counter
  //         });
  //         await _updateCounter(); // Update total points in Firestore
  //         await _updateTaskCounter(); // Update total tasks completed in Firestore
  //         await _updateTaskClaimStatus(task, user.uid); // Update task status in Firestore
  //       }
  //     } catch (error) {
  //       _showErrorDialog("Error claiming task", error.toString());
  //     }
  //   }
  // }


//   void _claimReward(Task task) async {
//   User? user = _auth.currentUser; // Get the current user
//   if (user != null) {
//     try {
//       // Check if the task is already claimed in Firestore
//       DocumentSnapshot doc = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('tasks')
//           .doc(task.taskId)
//           .get();

//       if (doc.exists && doc['claimed'] == true) {
//         // Task has already been claimed, show a dialog
//         _showErrorDialog("Task already claimed", "You have already claimed the reward for this task.");
//       } else {
//         // Task has not been claimed, proceed with claiming
//         setState(() {
//           _counter += task.reward; // Update points counter
//           _taskCounter += 1; // Increment task completion counter
//         });
//         await _updateCounter(); // Update total points in Firestore
//         await _updateTaskCounter(); // Update total tasks completed in Firestore

//         // Mark task as claimed in Firestore
//         await _firestore.collection('users').doc(user.uid).collection('tasks').doc(task.taskId).set({
//           'claimed': true, // Mark task as claimed
//           'reward': task.reward, // Save task reward (optional)
//         });

//         setState(() {
//           task.isClaimed = true; // Mark task as claimed locally
//         });
//       }
//     } catch (error) {
//       _showErrorDialog("Error claiming task", error.toString());
//     }
//   }
// }


// Method to check and claim reward for a task
// void _claimReward(Task task) async {
//   User? user = _auth.currentUser; // Get the current user
//   if (user != null) {
//     try {
//       // Check if the task is already claimed in Firestore
//       DocumentSnapshot doc = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('tasks')
//           .doc(task.taskId)
//           .get();

//       if (doc.exists && doc['claimed'] == true) {
//         // Task has already been claimed, show a dialog
//         _showErrorDialog("Task already claimed", "You have already claimed the reward for this task.");
//       } else {
//         // Task has not been claimed, proceed with claiming
//         setState(() {
//           _counter += task.reward; // Update points counter
//           _taskCounter += 1; // Increment task completion counter
//           task.isClaimed = true; // Set the task as claimed locally
//         });
//         await _updateCounter(); // Update total points in Firestore
//         await _updateTaskCounter(); // Update total tasks completed in Firestore
//         await _updateTaskClaimStatus(task, user.uid); // Update task status in Firestore
//       }
//     } catch (error) {
//       _showErrorDialog("Error claiming task", error.toString());
//     }
//   }
// }


void _claimReward(Task task) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(task.taskId)
            .get();

        if (doc.exists && doc['claimed'] == true) {
          _showErrorDialog("Task already claimed", "You have already claimed the reward for this task.");
        } else {
          setState(() {
            _counter += task.reward;
            _taskCounter += 1;
          });
          await _updateCounter();
          await _updateTaskCounter();
          await _updateTaskClaimStatus(task, user.uid);
        }
      } catch (error) {
        _showErrorDialog("Error claiming task", error.toString());
      }
    }
  }

  


  // Method to update points counter in Firestore
  Future<void> _updateCounter() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'counter': _counter, // Save total points to Firestore
        }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
      }
    } catch (error) {
      _showErrorDialog("Error updating points", error.toString());
    }
  }

  // Method to update task completion counter in Firestore
  Future<void> _updateTaskCounter() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'taskCounter': _taskCounter, // Save total tasks completed to Firestore
        }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
      }
    } catch (error) {
      _showErrorDialog("Error updating task counter", error.toString());
    }
  }

  // Method to update task claimed status in Firestore using taskId
  // Future<void> _updateTaskClaimStatus(Task task, String userId) async {
  //   try {
  //     await _firestore.collection('users').doc(userId).collection('tasks').doc(task.taskId).set({
  //       'claimed': true, // Mark task as claimed in Firestore
  //       'reward': task.reward,
  //     });
  //   } catch (error) {
  //     _showErrorDialog("Error updating task status", error.toString());
  //   }
  // }

  Future<void> _updateTaskClaimStatus(Task task, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('tasks').doc(task.taskId).set({
        'claimed': true,
        'reward': task.reward,
      });
    } catch (error) {
      _showErrorDialog("Error updating task status", error.toString());
    }
  }

  Future<void> _launchUrl(String url, Task task) async {
  try {
    final Uri url0 = Uri.parse(url); // Parse the URL

    await launchUrl(
      url0,
      mode: LaunchMode.platformDefault, // Set the launch mode to platform default
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true, // Enable JavaScript in the web view
      ),
    );

    
    setState(() {
      task.isClaimedEnabled = true; 
    });
  } catch (error) {
    _showErrorDialog("Error launching URL", error.toString());
  }
}


  // Method to show error dialog
  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog

                print("Error$content");
              },
            ),
          ],
        );
      },
    );
  }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[400],
//       appBar: AppBar(
//         title: Text(
//               'Total Tasks Completed: $_taskCounter', // Display total tasks completed
//               style: const TextStyle(fontSize: 18, color: Colors.white),
//             ),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
            
//             ..._tasks.map((task) {
//               return Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       _launchUrl(task.url, task); // Launch URL when task is tapped
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 4,),borderRadius: BorderRadius.circular(10,),color: Colors.white),
//                       child: Column(
                        
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
                          
//                           Text(task.title, style: const TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w700)),
//                           Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
                                
//                                 SizedBox(height: 10,),
//                                 SizedBox(width: 10,),
//                                 Text("Reward : ${task.reward}", style: const TextStyle(fontSize: 16, color: Colors.red)),
//                                 SizedBox(width: 10,),
//                                 // if (!task.isClaimed)
//                                 //   ElevatedButton(
//                                 //     onPressed: task.isClaimedEnabled // Enable claim button only if the link has been visited
//                                 //         ? () => _claimReward(task)
//                                 //         : null, // Disable if not visited
//                                 //     style: ElevatedButton.styleFrom(
//                                 //       backgroundColor: task.isClaimed ? Colors.blueAccent : Colors.green, // Disable claim button if claimed
//                                 //     ),
//                                 //     child: Text(task.isClaimed ? 'Claimed' : 'Claim'),
//                                 //   ),

//                                 if (!task.isClaimed)
//   ElevatedButton(
//     onPressed: task.isClaimedEnabled
//         ? () => _claimReward(task)
//         : null, // Disable if not visited
//     style: ElevatedButton.styleFrom(
//       backgroundColor: task.isClaimed ? Colors.blueAccent : Colors.green, // Change color if claimed
//     ),
//     child: Text(task.isClaimed ? 'Claimed' : 'Claim'),
//   ),

//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15,)
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Uicolor.body,
      appBar: AppBar(
        title: Text(
          'Total Tasks Completed: $_taskCounter',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Uicolor.appBar,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _tasks.map((task) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl(task.url, task); // Launch URL when task is tapped
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title, style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 10),
                              const SizedBox(width: 10),
                              Text("Reward : ${task.reward}", style: const TextStyle(fontSize: 16, color: Colors.red)),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: task.isClaimedEnabled && !task.isClaimed
                                    ? () => _claimReward(task)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: task.isClaimed ? Colors.green : Colors.blueAccent,
                                ),
                                child: Text(
                                  task.isClaimed ? 'Completed' : 'Claim Reward',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Task class with necessary properties
class Task {
  final String taskId;
  final String title;
  // final String imageUrl;
  final int reward;
  final String url; // URL to open for the task
  bool isClaimed;
  bool isClaimedEnabled;

  Task({
    required this.taskId,
    required this.title,
    // required this.imageUrl,
    required this.reward,
    required this.url,
    this.isClaimed = false,
    this.isClaimedEnabled = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      title: json['title'],
      reward: json['reward'],
      url: json['url'],
    );
  }
}


