import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

import 'package:sky_lists/presentational_widgets/about_app_dialog.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String version = 'Loading...';

  @override
  initState() {
    super.initState();
    getVersion();
  }

  void getVersion() async {
    String projectVersion;
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = '';
    }

    String projectCode;
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    String platformVersion;
    try {
      platformVersion = await GetVersion.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      version = "v$projectVersion+$projectCode for $platformVersion";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AboutAppDialog(
      version: version,
    );
  }
}
