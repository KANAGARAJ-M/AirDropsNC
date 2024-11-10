import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class HandlePermissions {
  Future<void> _storagePermission(BuildContext context) async {
    var notification_status = await Permission.notification.status;
    var notification_asccess_status =  await Permission.accessNotificationPolicy.status;

    // Check if permission is denied
    if (notification_status.isDenied && notification_asccess_status.isDenied) {
      notification_status = await Permission.notification.request();

      if (notification_status.isDenied) {
        // Show dialog if permission is still denied
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Permissions Required"),
              content: Text("Please enable storage permissions to proceed."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
