import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';

class AgreementsFormField extends FormField<bool> {
  AgreementsFormField({
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool initialValue = false,
    bool autovalidate = false,
    @required BuildContext context,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          builder: (FormFieldState<bool> state) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                      value: state.value,
                      onChanged: (value) {
                        state.didChange(value);
                      },
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'I accept the ',
                        style: Theme.of(context).textTheme.body1,
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, TermsOfServicePage.routeName);
                              },
                            text: 'Terms of Service',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                          ),
                          TextSpan(
                            text: ' and\nthe ',
                            style: Theme.of(context).textTheme.body1,
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, PrivacyPolicyPage.routeName);
                              },
                            text: 'Privacy Policy',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                          ),
                        ],
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
                state.hasError
                    ? Text(
                        state.errorText,
                        style: Theme.of(context).textTheme.body1.copyWith(
                              color: Colors.red,
                            ),
                      )
                    : Container()
              ],
            );
          },
        );
}
