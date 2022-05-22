import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: const MyHomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Permission Handler")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            ElevatedButton(
              child: Text(
                "Request Camera Permission",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: requestCameraPermission,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                "Request Multiple Permission",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: requestMultiplePermissions,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                "Request Location Permission",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: requestPermissionWithOpenSettings,
            ),
          ]),
        ),
      ),
    );
  }

  showSnack(String message, [Color? color]) {
    color = color ?? Colors.red;
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: color,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      showSnack("Camera permission is granted", Colors.green);
    } else if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        showSnack("Camera permission is granted", Colors.green);
      } else {
        showSnack("Camera permission is denied");
      }
    }
  }

  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.location, Permission.storage].request();

    if (status[Permission.location]!.isGranted &&
        status[Permission.storage]!.isGranted) {
      showSnack("Location and Storage permissions are granted");
    }
  }

  void requestPermissionWithOpenSettings() async {
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
