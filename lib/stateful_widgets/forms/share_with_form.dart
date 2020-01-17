// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import 'package:sky_lists/models/sky_list_meta.dart';
// import 'package:sky_lists/utils/us_number_text_input_formatter.dart';
// import 'package:sky_lists/database_service.dart';
// import 'package:sky_lists/utils/validation.dart';

// class ShareWithForm extends StatefulWidget {
//   @override
//   _ShareWithFormState createState() => _ShareWithFormState();
// }

// class _ShareWithFormState extends State<ShareWithForm> {
//   final _formKey = GlobalKey<FormState>();

//   bool _isLoading;
//   String _message;
//   ShareMethod _currentMethod;

//   TextEditingController _shareWithController;

//   @override
//   void initState() {
//     _shareWithController = TextEditingController();
//     _message = '';
//     _isLoading = false;
//     _currentMethod = ShareMethod.EMAIL;

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _shareWithController.dispose();
//     super.dispose();
//   }

//   void onRadioChange(ShareMethod value) {
//     setState(() {
//       _currentMethod = value;
//     });
//   }

//   void onPressed() async {
//     if (!_formKey.currentState.validate()) return;
//     setState(() {
//       _isLoading = true;
//     });

//     final toShareWithId = _currentMethod == ShareMethod.EMAIL
//         ? await _db.searchForEmail(
//             emailToSearchFor: _shareWithController.value.text)
//         : await _db.searchForPhoneNumber(
//             phoneToSearchFor: _shareWithController.value.text,
//           );

//     if (toShareWithId == null) {
//       setState(() {
//         _message = 'Email not found';
//       });
//     } else {
//       // final list = Provider.of<SkyListMeta>(context);

//       // await _db.shareList(
//       //   list: list,
//       //   shareWithId: toShareWithId,
//       // );

//       // setState(() {
//       //   _message = '';
//       // });
//     }

//     setState(() {
//       _isLoading = false;
//     });
//     _formKey.currentState.reset();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           Text('Share via'),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Radio(
//                 value: ShareMethod.EMAIL,
//                 groupValue: _currentMethod,
//                 onChanged: onRadioChange,
//               ),
//               Text('Email'),
//               Radio(
//                 value: ShareMethod.PHONE,
//                 groupValue: _currentMethod,
//                 onChanged: onRadioChange,
//               ),
//               Text('Phone Number')
//             ],
//           ),
//           Divider(),
//           TextFormField(
//             controller: _shareWithController,
//             keyboardType: _currentMethod == ShareMethod.EMAIL
//                 ? TextInputType.emailAddress
//                 : TextInputType.phone,
//             decoration: InputDecoration(
//               hintText: _currentMethod == ShareMethod.EMAIL
//                   ? "Email"
//                   : "Phone Number",
//               counterText: "",
//               icon: Icon(
//                 _currentMethod == ShareMethod.EMAIL ? Icons.email : Icons.phone,
//               ),
//             ),
//             autocorrect: false,
//             maxLength: 60,
//             validator: _currentMethod == ShareMethod.EMAIL
//                 ? validateEmail
//                 : validatePhone,
//             enabled: !_isLoading,
//             inputFormatters: _currentMethod == ShareMethod.EMAIL
//                 ? <TextInputFormatter>[]
//                 : <TextInputFormatter>[
//                     UsNumberTextInputFormatter(),
//                   ],
//           ),
//           _isLoading
//               ? CircularProgressIndicator()
//               : FlatButton.icon(
//                   icon: Icon(
//                     Icons.send,
//                   ),
//                   label: Text('Share'),
//                   onPressed: onPressed,
//                 ),
//           Text(
//             _message,
//             style: TextStyle(
//               color: Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/share_with.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ShareWithForm extends StatefulWidget {
  ShareWithForm({this.list});
  final ListMetadata list;

  @override
  _ShareWithFormState createState() => _ShareWithFormState();
}

class _ShareWithFormState extends State<ShareWithForm> {
  final TextEditingController _emailController = TextEditingController();

  ShareListBloc _shareBloc;

  String emailVal;
  String passwordVal;

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isShareButtonEnabled(ShareListState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _shareBloc = BlocProvider.of<ShareListBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void _onEmailChanged() {
    if (emailVal == _emailController.text) return;

    setState(() {
      emailVal = _emailController.text;
    });
    _shareBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _shareBloc.add(
      Submitted(
        email: _emailController.text,
        list: widget.list,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareListBloc, ShareListState>(
      builder: (context, state) {
        return ShareWith(
          emailController: _emailController,
          isSubmitting: state.isSubmitting,
          onFormSubmitted: _onFormSubmitted,
          isFailure: state.isFailure,
          isSubmitButtonEnabled: isShareButtonEnabled(state),
          failureMessage: state.failureMessage,
        );
      },
    );
  }
}
