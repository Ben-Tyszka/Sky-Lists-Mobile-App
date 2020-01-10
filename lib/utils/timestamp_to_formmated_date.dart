import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

/// Returns a nicely formatted Date/Time string from a [timestamp]
String timestampToFormmatedDate(Timestamp timestamp) {
  if (timestamp == null) return '';

  return 'Last Modified: ${DateFormat("EEE MMM d,").add_jm().format(timestamp.toDate())}';
}
