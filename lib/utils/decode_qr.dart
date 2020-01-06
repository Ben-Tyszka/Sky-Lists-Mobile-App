import 'package:sky_lists/presentational_widgets/qr_code_dialog.dart';

class DecodeData {
  final String listId;
  final String ownerId;

  DecodeData(this.listId, this.ownerId);
}

DecodeData decodeQR(String raw) {
  final data = raw.split(QrCodeAlertDialog.centerPart);
  if (data.length == 0 || data == [""]) {
    throw Error();
  }
  if (!data[0].contains(QrCodeAlertDialog.leftPart) ||
      !data[1].contains(QrCodeAlertDialog.rightPart)) {
    throw Error();
  }

  final String listId = data[0].substring(5);
  final String ownerId = data[1].split(QrCodeAlertDialog.rightPart)[0];

  return DecodeData(listId, ownerId);
}
