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
            return null;
          },
        );
}
