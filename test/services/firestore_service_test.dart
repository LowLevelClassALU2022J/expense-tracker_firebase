import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/income_category.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

void main() {
  group('FirestoreService Tests', () {
    late FirestoreService firestoreService;
    late MockCollectionReference mockCollectionReference;
    late MockDocumentReference mockDocumentReference;
    late MockQuerySnapshot mockQuerySnapshot;

    setUp(() {
      mockCollectionReference = MockCollectionReference();
      mockDocumentReference = MockDocumentReference();
      mockQuerySnapshot = MockQuerySnapshot();

      firestoreService = FirestoreService('test_user_id');
    });

    test('getIncomeCategories returns a list of income categories', () async {
      when(mockCollectionReference.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));

      expect(firestoreService.getIncomeCategories(),
          isA<Stream<List<IncomeCategory>>>());
    });

    test('addIncomeCategory adds a new income category', () async {
      when(mockCollectionReference.where('name', isEqualTo: 'TestCategory'))
          .thenAnswer((_) => mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) => Future.value(mockQuerySnapshot));

      final result = await firestoreService.addIncomeCategory('TestCategory');

      expect(result, isA<IncomeCategory>());
    });

    // Add more tests for other methods as needed

    tearDown(() {
      // Clear any mock calls or instances
      clearInteractions(mockCollectionReference);
      clearInteractions(mockDocumentReference);
      clearInteractions(mockQuerySnapshot);
    });
  });
}
