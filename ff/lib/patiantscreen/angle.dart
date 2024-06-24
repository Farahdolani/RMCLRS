import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class AngleStream {
  Stream<double> getAngleStream() {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('all').child('roll');
    final StreamController<double> controller = StreamController<double>();

    // Listen for value changes in the 'roll' child
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as double?;
      if (data != null) {
        controller.add(data);
      }
    });

    // Close the stream controller when done.
    // You might want to implement some mechanism to close this properly when no longer needed
    // For now, let's return the stream immediately
    return controller.stream;
  }
}

