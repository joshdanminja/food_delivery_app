import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './bloc/listStyleColorBloc.dart';

import './bloc/cartListBloc.dart';
import './model/foodItem.dart';

class Cart extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    List<FoodItem> foodItems;

    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          foodItems = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: Container(child: CartBody(foodItems)),
            ),
            bottomNavigationBar: BottomBar(foodItems),
          );
        } else {
          return Container(child: Text("Something returned null."));
        }
      },
    );
  }
}

class BottomBar extends StatelessWidget {
  final List<FoodItem> foodItems;

  BottomBar(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 29, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          totalAmount(foodItems),
          Divider(height: 1.5, color: Colors.grey[700]),
          persons(),
          nextButtonBar()
        ],
      ),
    );
  }

  Container nextButtonBar() {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xfffeb324), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "15-25 minutes",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Text(
            "Next",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          )
        ],
      ),
    );
  }

  Container persons() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Persons",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          CustomPersonWidget()
        ],
      ),
    );
  }

  Container totalAmount(List<FoodItem> foodItems) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Total",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
          Text(
            "\$${returnTotalAmount(foodItems)}",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          ),
        ],
      ),
    );
  }

  String returnTotalAmount(List<FoodItem> foodItems) {
    double totalAmount = 0.0;

    for (int i = 0; i < foodItems.length; i++) {
      totalAmount = totalAmount + foodItems[i].price * foodItems[i].quantity;
    }
    return totalAmount.toStringAsFixed(2);
  }
}

class CustomPersonWidget extends StatefulWidget {
  @override
  _CustomPersonWidgetState createState() => _CustomPersonWidgetState();
}

class _CustomPersonWidgetState extends State<CustomPersonWidget> {
  int noOfPersons = 1;
  double _buttonWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300], width: 1.5),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 3),
      width: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: FlatButton(
              padding: EdgeInsets.only(right: 7),
              child: Text(
                "-",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
              onPressed: () {
                setState(() {
                  if (noOfPersons > 1) {
                    noOfPersons--;
                  }
                });
              },
            ),
          ),
          Text(
            noOfPersons.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: FlatButton(
              padding: EdgeInsets.only(left: 7),
              child: Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              onPressed: () {
                setState(() {
                  noOfPersons++;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartBody extends StatelessWidget {
  final List<FoodItem> foodItems;

  CartBody(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          title(),
          Expanded(
              flex: 1,
              child: foodItems.length > 0 ? foodItemList() : noItemContainer()),
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text(
          "No more items left in the cart.",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 18),
        ),
      ),
    );
  }

  ListView foodItemList() {
    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return CartListItem(foodItem: foodItems[index]);
      },
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: 'My ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Order',
                      style: TextStyle(fontWeight: FontWeight.w100, fontSize: 28)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  final FoodItem foodItem;

  CartListItem({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
        hapticFeedbackOnStart: true,
        maxSimultaneousDrags: 1,
        data: foodItem,
        child: DraggableChild(foodItem: foodItem),
        feedback: DraggableChildFeedback(foodItem: foodItem),
        childWhenDragging: foodItem.quantity > 1
            ? DraggableChild(foodItem: foodItem)
            : Container());
  }
}

class DraggableChild extends StatelessWidget {
  final FoodItem foodItem;

  DraggableChild({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 25),
        child: ItemContent(foodItem: foodItem));
  }
}

class DraggableChildFeedback extends StatelessWidget {
  final FoodItem foodItem;

  DraggableChildFeedback({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return Opacity(
      opacity: 0.7,
      child: Material(
        child: StreamBuilder<Object>(
          stream: colorBloc.colorStream,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.only(bottom: 5),
              child: ItemContent(foodItem: foodItem),
              decoration: BoxDecoration(
                  color: snapshot.data != null ? snapshot.data : Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.95,
            );
          },
        ),
      ),
    );
  }
}

class ItemContent extends StatelessWidget {
  final FoodItem foodItem;

  ItemContent({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(foodItem.img,
                fit: BoxFit.fill, height: 50, width: 50),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
              children: [
                TextSpan(text: foodItem.quantity.toString()),
                TextSpan(text: " x "),
                TextSpan(text: foodItem.title)
              ],
            ),
          ),
          Text(
            "\$${foodItem.quantity * foodItem.price}",
            style:
                TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        DragTargetWidget(bloc)
      ],
    );
  }
}

class DragTargetWidget extends StatefulWidget {
  final CartListBloc bloc;

  DragTargetWidget(this.bloc);

  @override
  _DragTargetWidgetState createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {
  final CartListBloc listBloc = BlocProvider.getBloc<CartListBloc>();
  final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

  @override
  Widget build(BuildContext context) {
    return DragTarget<FoodItem>(onWillAccept: (FoodItem foodItem) {
      colorBloc.setColor(Colors.red);
      return true;
    }, onAccept: (FoodItem foodItem) {
      listBloc.removeFromLIst(foodItem);
      colorBloc.setColor(Colors.white);
    }, onLeave: (foodItem) {
      colorBloc.setColor(Colors.white);
    }, builder: (context, incoming, rejected) {
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: Icon(CupertinoIcons.delete, size: 33),
      );
    });
  }
}
