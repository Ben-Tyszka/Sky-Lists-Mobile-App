import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
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
          style: Theme.of(context).primaryTextTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        Divider(
          height: 10.0,
        ),
        Column(
          children: <Widget>[
            OutlineButton(
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context).add(
                  NavigatorPushTo(
                    PrivacyPolicyPage.routeName,
                  ),
                );
              },
              child: Text(
                'Privacy Policy',
              ),
            ),
            OutlineButton(
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context).add(
                  NavigatorPushTo(
                    TermsOfServicePage.routeName,
                  ),
                );
              },
              child: Text(
                'Terms of Service',
              ),
            ),
          ],
        ),
        Divider(
          height: 10.0,
        ),
        Text(
          'Contact',
          style: Theme.of(context).primaryTextTheme.subtitle2,
          textAlign: TextAlign.center,
        ),
        Text.rich(
          TextSpan(
            text: 'Website: ',
            style: Theme.of(context).primaryTextTheme.bodyText2,
            children: <TextSpan>[
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final url = 'https://skylists.app';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                text: 'skylists.app',
                style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
            style: Theme.of(context).primaryTextTheme.bodyText2,
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
                style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
            style: Theme.of(context).primaryTextTheme.bodyText2,
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
                style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
            style: Theme.of(context).primaryTextTheme.bodyText2,
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
                style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
