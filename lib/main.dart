// Copyright [2023] [KANAGARAJ M]

//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at

//        http://www.apache.org/licenses/LICENSE-2.0

//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.


import 'package:air_drops/phase1/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';
///PHASE 2
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await Supabase.initialize(
//     url: 'https://vdauwgurmubcnnqhtjnk.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkYXV3Z3VybXViY25ucWh0am5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NDI2NzMsImV4cCI6MjA0NTUxODY3M30._Ow86Tn28BmH6qbxs3vwNlWhDmZS1VRGvDsw4UQcB5Q',
//   );
//   runApp(MyApp());
// }


///PHASE !
Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  _PermissionsHandler();
  await Supabase.initialize(
    url: 'https://vdauwgurmubcnnqhtjnk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkYXV3Z3VybXViY25ucWh0am5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NDI2NzMsImV4cCI6MjA0NTUxODY3M30._Ow86Tn28BmH6qbxs3vwNlWhDmZS1VRGvDsw4UQcB5Q',
  );
  runApp(const UpdateCheckerApp());
}

Future<void> _PermissionsHandler() async {
  var noti_status = await Permission.notification.status;
  var location_status = await Permission.location.status; 
  if (noti_status.isDenied && location_status.isDenied) {
    noti_status = await Permission.notification.request();
    if (noti_status.isDenied) {
      // Handle the denied state
    }
  } else {}
}