import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServicePage extends StatelessWidget {
  static final String routeName = '/terms_of_service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Welcome to Sky Lists',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'These terms and conditions outline the rules and regulations for the use of this mobile app.',
                style: Theme.of(context).textTheme.subtitle,
              ),
              Divider(),
              Text(
                'By accessing this app we assume you accept these terms and conditions in full. Do not continue to use this app if you do not accept all of the terms and conditions stated on this page.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'The following terminology applies to these Terms and Conditions and Privacy Policy and any or all Agreements: \'Client\', \'You\' and \'Your\' refers to you, the person accessing this website and accepting the App\'s terms and conditions. \'The Company\', \'Ourselves\', \'We\', \'Sky Lists\', \'Sky Lists Mobile\', \'App\', \'Our\' and \'Us\', refers to our Company and App. \'Party\', \'Parties\', or \'Us\', refers to both the Client and ourselves, or either the Client or ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner, whether by formal meetings of a fixed duration, or any other means, for the express purpose of meeting the Client\'s needs in respect of provision of the Company\'s stated services/products, in accordance with and subject to, prevailing law of. Any use of the above terminology or other words in the singular, plural, capitalisation and/or he/she or they, are taken as interchangeable and therefore as referring to same.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Content Liability',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'We shall have no responsibility or liability for any content appearing on your mobile app or phone. You agree to indemnify and defend us against all claims arising out of or based upon your App. No link(s) or content may appear on any page on your App or within any context containing content or materials that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'License',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'Unless otherwise stated, Sky Lists Mobile and/or it\'s licensors own the intellectual property rights for all material on Sky Lists. All intellectual property rights are reserved.',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Disclaimer',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our app and the use of this app (including, without limitation, any warranties implied by law in respect of satisfactory quality, fitness for purpose and/or the use of reasonable care and skill).',
                style: Theme.of(context).textTheme.body1,
              ),
              Divider(),
              Text(
                'Terms of Service Changes',
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                'Sky Lists Mobile may change its Terms of Service from time to time, and in Sky Lists Mobile\'s sole discretion. Sky Lists Mobile encourages visitors to frequently check this page for any changes to its Terms of Service. Your continued use of this app after any change in this Terms of Service will finalitute your acceptance of such change.',
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
