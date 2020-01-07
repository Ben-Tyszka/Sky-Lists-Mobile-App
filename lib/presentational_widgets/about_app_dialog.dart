import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';

class AboutAppDialog extends StatelessWidget {
  AboutAppDialog({@required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: 'Sky Lists',
      applicationLegalese:
          'Copyright © 2019 Sky Lists Mobile. All rights reserved.',
      applicationVersion: version,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Sky Lists is still under development. Bug reports, suggestions and/or feedback would be greatly appreciated.',
        ),
        Divider(
          height: 10.0,
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, PrivacyPolicyPage.routeName);
          },
          child: Text(
            'Privacy Policy',
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, TermsOfServicePage.routeName);
          },
          child: Text(
            'Terms of Service',
          ),
        ),
        Divider(
          height: 10.0,
        ),
        Text(
          'Contact',
        ),
        Text.rich(
          TextSpan(
            text: 'Website: ',
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    const url = 'https://skylists.app';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                text: 'skylists.app',
                style: Theme.of(context).textTheme.body1.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'General: ',
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    const url = 'mailto:contact@skylists.app';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                text: 'contact@skylists.app',
                style: Theme.of(context).textTheme.body1.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Business Inquiries: ',
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    const url = 'mailto:biz@skylists.app';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                text: 'biz@skylists.app',
                style: Theme.of(context).textTheme.body1.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Legal: ',
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    const url = 'mailto:legal@skylists.app';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                text: 'legal@skylists.app',
                style: Theme.of(context).primaryTextTheme.body1.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
