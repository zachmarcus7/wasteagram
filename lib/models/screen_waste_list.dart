import 'screen_waste_post.dart';

class ScreenWasteList {

  late List<ScreenWastePost> postList = [];
  
  void toList(ScreenWastePost post) {
    postList.add(post);
  }

  int getQuantity() {
    int total = 0;
    postList.forEach( (post) => total += post.getQuantity);
    return total;
  }

}