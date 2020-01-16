import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

/// Returns a nicely formatted Date/Time string from a [timestamp]
String timestampToFormmatedDate(dynamic timestamp) {
  if (timestamp == null) return 'Loading...';

  try {
    final castedTimestamp = timestamp as Timestamp;
    return 'Last Modified: ${DateFormat("EEE MMM d,").add_jm().format(castedTimestamp.toDate())}';
  } catch (_) {
    return 'Loading...';
  }
}
