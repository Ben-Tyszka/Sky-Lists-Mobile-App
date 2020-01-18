import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static final String routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Your privacy is important to us.',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
              Divider(),
              Text(
                'It is Sky Lists Mobile\'s policy to respect your privacy regarding any information we may collect while operating our app. This Privacy Policy applies to this mobile application (hereinafter, "us", "we", "Sky Lists Mobile" or "Sky Lists"). We respect your privacy and are committed to protecting personally identifiable information you may provide us through the App. We have adopted this privacy policy ("Privacy Policy") to explain what information may be collected on our App, how we use this information, and under what circumstances we may disclose the information to third parties. This Privacy Policy applies only to information we collect through the App and does not apply to our collection of information from other sources. This Privacy Policy, together with the Terms and conditions posted on our App, set forth the general rules and policies governing your use of our App. Depending on your activities when visiting our App, you may be required to agree to additional terms and conditions.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'App Users',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'Like most App operators, Sky Lists Mobile collects non-personally-identifying information of the sort that web browsers, apps and servers typically make available, such as the platform type, language preference, and the date and time of each visitor request. Sky Lists Mobile\'s purpose in collecting non-personally identifying information is to better understand how Sky Lists Mobile\'s users interact with the app. From time to time, Sky Lists Mobile may release non-personally-identifying information in the aggregate, e.g., by publishing a report on trends in the usage of its app. Sky Lists Mobile also collects potentially personally-identifying information like Internet Protocol (IP) addresses for logged in users. Sky Lists Mobile only discloses logged in user and commenter IP addresses under the same circumstances that it uses and discloses personally-identifying information as described below.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Gathering of Personally-Identifying Information',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'Certain users to Sky Lists Mobile\'s app choose to interact with Sky Lists in ways that require Sky Lists Mobile to gather personally-identifying information. The amount and type of information that Sky Lists gathers depends on the nature of the interaction. For example, we ask visitors who sign up for an account to provide a username, display name and an email address.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Security',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'The security of your Personal Information is extraordinary important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security. Your password is stored in accordance with industry standards and best practices.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Aggregated Statistics',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'Sky Lists Mobile may collect statistics about the behavior of users of its app. Sky Lists Mobile may display this information publicly or provide it to others. However, Sky Lists Mobile does not disclose your personally-identifying information.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Privacy Policy Changes',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'Although most changes are likely to be minor, Sky Lists Mobile may change its Privacy Policy from time to time, and in Sky Lists Mobile\'s sole discretion. Sky Lists  Mobile encourages visitors to frequently check this page for any changes to its Privacy Policy. Your continued use of this app after any change in this Privacy Policy will finalitute your acceptance of such change.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.title,
              ),
              Text.rich(
                TextSpan(
                  text: 'General: ',
                  style: Theme.of(context).textTheme.body1,
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'mailto:contact@skylists.app';
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
                  style: Theme.of(context).textTheme.body1,
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'mailto:biz@skylists.app';
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
                  style: Theme.of(context).textTheme.body1,
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'mailto:legal@skylists.app';
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                      text: 'legal@skylists.app',
                      style: Theme.of(context).textTheme.body1.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
