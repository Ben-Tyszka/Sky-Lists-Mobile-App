import 'package:sky_lists/presentational_widgets/qr_code_dialog.dart';

/// Data class that the the decoded qr string is put into
class DecodeData {
  /// The id of the list that was in the qr code
  final String listId;

  /// The id of the owner of the list that was in the qr code
  final String ownerId;

  /// Constructs data class
  DecodeData(this.listId, this.ownerId);
}

/// Decodes the [raw] qr string into [DecodeData]
///
/// Composition of the data in the qr code:
/// known random chars + listId + known random chars + ownerId + known random chars
/// In a very simple, primative, and probably unnecisary attempt to hide
/// the uids of the list and owner from the end user
DecodeData decodeQR(String raw) {
  // Splits raw string into two parts
  final data = raw.split(QrCodeAlertDialog.centerPart);
  // If wrong format, throw error
  if (data.length == 0 || data == [""]) {
    throw Error();
  }
  // If wrong format, throw error
  if (!data[0].contains(QrCodeAlertDialog.leftPart) ||
      !data[1].contains(QrCodeAlertDialog.rightPart)) {
    throw Error();
  }
  // Substring based on left part
  final String listId = data[0].substring(QrCodeAlertDialog.leftPart.length);
  // Substring based on right part
  final String ownerId = data[1].split(QrCodeAlertDialog.rightPart)[0];

  // Return data class
  return DecodeData(listId, ownerId);
}
