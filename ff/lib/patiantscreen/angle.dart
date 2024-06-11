import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class AngleStream {
  Stream<double> getAngleStream() {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('all');
    final StreamController<double> controller = StreamController<double>();

    databaseRef.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final roll = data['roll'] as double?;
      if (roll != null) {
        controller.add(roll);
      }
    });

    // Close the stream controller when done.
    // You might want to implement some mechanism to close this properly when no longer needed
    // For now, let's return the stream immediately
    return controller.stream;
  }
}

