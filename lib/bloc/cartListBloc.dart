import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../model/foodItem.dart';
import '../bloc/provider.dart';

class CartListBloc extends BlocBase {
  CartListBloc();

  var _listController = BehaviorSubject<List<FoodItem>>.seeded([]);

  CartProvider provider = CartProvider();

  Stream<List<FoodItem>> get listStream => _listController.stream;
  Sink<List<FoodItem>> get listSink => _listController.sink;

  addToLIst(FoodItem foodItem) {
    listSink.add(provider.addToList(foodItem));
  }

  removeFromLIst(FoodItem foodItem) {
    listSink.add(provider.removeFromList(foodItem));
  }

  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
