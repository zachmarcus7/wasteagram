import 'package:test/test.dart';
import 'package:wasteagram/models/screen_waste_post.dart';

void main() {
  group('screenWastePost successfully created and getter works', () {

    final screenWastePost = ScreenWastePost(
      date:'July 10, 2021',
      imageURL: 'google.com/image',
      quantity: 4,
      latitude: '10.002',
      longitude: '-234.002');
    
    test('screenPostWaste created successfully', () {
      expect(screenWastePost.date, 'July 10, 2021');
    });

    test('screenWaste post getter works', () {
      expect(screenWastePost.getQuantity, 4);
    });
  });
}