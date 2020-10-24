import 'package:meta/meta.dart';

FoodItemList foodItemList = FoodItemList(foodItems: [
  FoodItem(
      id: 1,
      title: "BBQ Burger",
      hotel: "Las Vegas Hotel",
      price: 14.60,
      img: "assets/images/beachBBQBurger.png"
  ),
  FoodItem(
      id: 2,
      title: "Burger & Fries",
      hotel: "Dudleys Hotel",
      price: 15.40,
      img: "assets/images/burgerWithFrenchFries.png"
  ),
  FoodItem(
      id: 3,
      title: "Hamburger",
      hotel: "Golf Course Hotel",
      price: 20.80,
      img: "assets/images/Hamburger.png"
  ),
  FoodItem(
      id: 4,
      title: "Chicken Pizza",
      hotel: "Las Vegas Hotel",
      price: 12.00,
      img: "assets/images/chickenPizza.png"
  ),
  FoodItem(
      id: 5,
      title: "Veggies Pizza",
      hotel: "Five Star Hotel",
      price: 30.60,
      img: "assets/images/superVeggiesPizza.png"
  ),
  FoodItem(
      id: 6,
      title: "Cheese Pizza",
      hotel: "Tanzanite Park Hotel",
      price: 40.20,
      img: "assets/images/extraCheesePizza.png"
  ),
]);

class FoodItemList {
  List<FoodItem> foodItems;

  FoodItemList({@required this.foodItems});
}

class FoodItem {
  int id;
  String title;
  String hotel;
  double price;
  String img;
  int quantity;

  FoodItem({
      @required this.id,
      @required this.title,
      @required this.hotel,
      @required this.price,
      @required this.img,
      this.quantity = 1
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }

}
