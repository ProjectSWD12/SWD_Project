// Functional Correctness – Dart unit tests
// Requires: flutter_test, cloud_firestore_mocks, and your TourRepository class.
// Run with: flutter test test/qa/functional_correctness_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:tour_guide_manager/data/tour_repository.dart'; // adjust import path
import 'package:tour_guide_manager/models/tour.dart';            // adjust import path

void main() {
  group('Functional Correctness – Tour Creation', () {
    late MockFirestoreInstance firestore;
    late TourRepository repo;

    setUp(() {
      firestore = MockFirestoreInstance();
      repo = TourRepository(firestore: firestore);
    });

    test('Saves a valid tour', () async {
      final tour = Tour(
        name: 'Test tour',
        description: 'Amazing tour',
        date: DateTime.now().add(const Duration(days: 1)),
      );

      await repo.createTour(tour);

      final snap = await firestore.collection('tours').doc(tour.id).get();
      expect(snap.exists, true);
      expect(snap.data()?['name'], equals('Test tour'));
    });

    test('Rejects invalid tour', () async {
      final badTour = Tour(
        name: '',
        description: '',
        date: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(() => repo.createTour(badTour), throwsA(isA<ValidationException>()));
    });
  });
}
