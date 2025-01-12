import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dimension(),
    );
  }
}

class Dimension extends StatefulWidget {
  const Dimension({super.key});

  @override
  State<Dimension> createState() => _DimensionState();
}

class _DimensionState extends State<Dimension> {
  late String appVersion;

  void fetchLatestRelease() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.github.com/repos/SatyamBhargav/liveUpdate/releases/latest'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);
        // log('Response data: $data');
        final currentAppVersion = await getAppVersion();
        // Extract specific fields
        final tagName = data['tag_name'];
        // final changelog = data['body'];
        // final downloadUrl = data['assets'][0]['browser_download_url'];
        if (tagName == currentAppVersion) {
          await Future.delayed(Duration(seconds: 2));
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                backgroundColor: Colors.transparent,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(30)),
                    // height: 400,
                    child: Column(
                      // alignment: Alignment.bottomCenter,
                      children: [
                        PhosphorIcon(
                          PhosphorIcons.info(),
                          size: 50,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'New app version available\nv$appVersion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancle',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                )),
                            ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        } else {
          log('true');
        }
      } else {
        log('Failed to fetch latest release. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error while fetching: $e');
    }
  }

  Future<String> getAppVersion() async {
    try {
      // Retrieve app package information
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // Extract current version and build number
      String currentVersion = packageInfo.version; // e.g., "1.2.3"
      // String buildNumber = packageInfo.buildNumber; // e.g., "42"
      setState(() {
        appVersion = currentVersion;
      });
      return currentVersion;
      // log('Current App Version: $currentVersion');
      // log('Build Number: $buildNumber');
    } catch (e) {
      log('Failed to get app version: $e');
      return e.toString();
    }
  }

  @override
  void initState() {
    fetchLatestRelease();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your screen dimension is'),
            Text('Height - ${MediaQuery.of(context).size.height}'),
            Text('Width - ${MediaQuery.of(context).size.width}'),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  fetchLatestRelease();
                  // getAppVersion();
                },
                child: Text('Check for Update')),
            Container(
              padding: EdgeInsets.all(10),
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30)),
              // height: 400,
              child: Column(
                // alignment: Alignment.bottomCenter,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.info(),
                    size: 50,
                    color: Colors.black,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'New app version available\nv$appVersion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancle',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomRectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(100, 100, 110, 110); // Custom crop area
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
