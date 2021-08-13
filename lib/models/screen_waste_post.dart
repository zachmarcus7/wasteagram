class ScreenWastePost {

  var date;
  var imageURL;
  var quantity;
  var latitude;
  var longitude;

  ScreenWastePost({this.date,
                   this.imageURL,
                   this.quantity,
                   this.latitude,
                   this.longitude});
  
  ScreenWastePost.fromSnapshot(var post) {
    this.date = post['date'];
    this.imageURL = post['imageURL'];
    this.quantity = post['quantity'];
    this.latitude = post['latitude'];
    this.longitude = post['longitude'];
  }

  int get getQuantity => quantity as int;

}