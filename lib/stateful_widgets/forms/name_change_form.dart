import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/database_service.dart';

import 'package:sky_lists/presentational_widgets/name_change.dart';

class NameChangeForm extends StatefulWidget {
  @override
  _NameChangeFormState createState() => _NameChangeFormState();
}

class NameData {
  String name = '';
}

class _NameChangeFormState extends State<NameChangeForm> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  TextEditingController _controller;
  bool _isLoading = false;
  NameData _data = NameData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<FirebaseUser>(context);
    _controller = TextEditingController(text: user?.displayName ?? '');
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState.save();

      final user = Provider.of<FirebaseUser>(context, listen: false);
      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = _data.name;
      user.updateProfile(userUpdateInfo);

      _db.updateDisplayName(userId: user.uid, newName: _data.name);

      _formKey.currentState.reset();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onSaved(String val) {
    _data.name = val;
  }

  @override
  Widget build(BuildContext context) {
    return NameChange(
      controller: _controller,
      formKey: _formKey,
      isLoading: _isLoading,
      onSaved: _onSaved,
      submit: _submit,
    );
  }
}
