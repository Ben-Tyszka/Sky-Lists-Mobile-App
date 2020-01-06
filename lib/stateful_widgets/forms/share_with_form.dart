import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/utils/us_number_text_input_formatter.dart';
import 'package:sky_lists/utils/validation.dart';
import 'package:sky_lists/database_service.dart';

enum ShareMethod {
  EMAIL,
  PHONE,
}

class ShareWithForm extends StatefulWidget {
  @override
  _ShareWithFormState createState() => _ShareWithFormState();
}

class _ShareWithFormState extends State<ShareWithForm> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  bool _isLoading;
  String _message;
  ShareMethod _currentMethod;

  TextEditingController _shareWithController;

  @override
  void initState() {
    _shareWithController = TextEditingController();
    _message = '';
    _isLoading = false;
    _currentMethod = ShareMethod.EMAIL;

    super.initState();
  }

  @override
  void dispose() {
    _shareWithController.dispose();
    super.dispose();
  }

  void onRadioChange(ShareMethod value) {
    setState(() {
      _currentMethod = value;
    });
  }

  void onPressed() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });

    final toShareWithId = _currentMethod == ShareMethod.EMAIL
        ? await _db.searchForEmail(
            emailToSearchFor: _shareWithController.value.text)
        : await _db.searchForPhoneNumber(
            phoneToSearchFor: _shareWithController.value.text,
          );

    if (toShareWithId == null) {
      setState(() {
        _message = 'Email not found';
      });
    } else {
      final list = Provider.of<SkyListMeta>(context);
      final user = Provider.of<FirebaseUser>(context);

      await _db.shareList(
        list: list,
        ownerId: user.uid,
        sharedWithId: toShareWithId,
      );
      setState(() {
        _message = '';
      });
    }

    setState(() {
      _isLoading = false;
    });
    _formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text('Share via'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: ShareMethod.EMAIL,
                groupValue: _currentMethod,
                onChanged: onRadioChange,
              ),
              Text('Email'),
              Radio(
                value: ShareMethod.PHONE,
                groupValue: _currentMethod,
                onChanged: onRadioChange,
              ),
              Text('Phone Number')
            ],
          ),
          Divider(),
          TextFormField(
            controller: _shareWithController,
            keyboardType: _currentMethod == ShareMethod.EMAIL
                ? TextInputType.emailAddress
                : TextInputType.phone,
            decoration: InputDecoration(
              hintText: _currentMethod == ShareMethod.EMAIL
                  ? "Email"
                  : "Phone Number",
              counterText: "",
              icon: Icon(
                _currentMethod == ShareMethod.EMAIL ? Icons.email : Icons.phone,
              ),
            ),
            autocorrect: false,
            maxLength: 60,
            validator: _currentMethod == ShareMethod.EMAIL
                ? validateEmail
                : validatePhone,
            enabled: !_isLoading,
            inputFormatters: _currentMethod == ShareMethod.EMAIL
                ? <TextInputFormatter>[]
                : <TextInputFormatter>[
                    UsNumberTextInputFormatter(),
                  ],
          ),
          _isLoading
              ? CircularProgressIndicator()
              : FlatButton.icon(
                  icon: Icon(
                    Icons.send,
                  ),
                  label: Text('Share'),
                  onPressed: onPressed,
                ),
          Text(
            _message,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
