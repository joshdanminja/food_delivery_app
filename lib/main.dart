import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import './cart.dart';

import './bloc/cartListBloc.dart';
import './model/foodItem.dart';
import './bloc/listStyleColorBloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => CartListBloc()),
        Bloc((i) => ColorBloc())
      ],
      child: MaterialApp(
          title: "Food Delivery",
          home: Home(),
          debugShowCheckedModeBanner: false),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              FirstHalf(),
              SizedBox(height: 45),
              for (var foodItem in foodItemList.foodItems)
                ItemContainer(foodItem: foodItem)
            ],
          ),
        ),
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  final FoodItem foodItem;

  ItemContainer({@required this.foodItem});

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(FoodItem foodItem) {
    bloc.addToLIst(foodItem);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToCart(foodItem);

        final snackbar = SnackBar(
          content: Text("${foodItem.title} added to cart."),
          duration: Duration(milliseconds: 600),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      child: Items(
          hotel: foodItem.hotel,
          itemName: foodItem.title,
          itemPrice: foodItem.price,
          img: foodItem.img,
          leftAligned: (foodItem.id % 2) == 0 ? true : false),
    );
  }
}

class Items extends StatelessWidget {
  final bool leftAligned;
  final String itemName;
  final String hotel;
  final String img;
  final double itemPrice;

  Items({
    @required this.hotel,
    @required this.itemName,
    @required this.itemPrice,
    @required this.img,
    @required this.leftAligned,
  });

  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadius = 10;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: leftAligned ? 0 : containerPadding,
              right: leftAligned ? containerPadding : 0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                      left: leftAligned
                          ? Radius.circular(0)
                          : Radius.circular(containerBorderRadius),
                      right: leftAligned
                          ? Radius.circular(containerBorderRadius)
                          : Radius.circular(0)),
                  child: Image.asset(img, fit: BoxFit.fill),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(
                    left: leftAligned ? 20 : 0, right: leftAligned ? 0 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            itemName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ),
                        Text(
                          "\$$itemPrice",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black45, fontSize: 15),
                          children: [
                            TextSpan(text: "by "),
                            TextSpan(
                              text: hotel,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: containerPadding)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FirstHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
      child: Column(
        children: <Widget>[
          CustomerAppBar(),
          SizedBox(height: 15),
          title(),
          SizedBox(height: 15),
          searchBar(),
          SizedBox(height: 20),
          categories()
        ],
      ),
    );
  }

  Widget categories() {
    return Container(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryListItem(
              categoryIcon: Icons.local_pizza,
              categoryName: "Pizza",
              availability: 12,
              selected: true),
          CategoryListItem(
              categoryIcon: Icons.local_bar,
              categoryName: "Drinks",
              availability: 12,
              selected: false),
          CategoryListItem(
              categoryIcon: Icons.cake,
              categoryName: "Cakes",
              availability: 12,
              selected: false),
          CategoryListItem(
              categoryIcon: Icons.fastfood,
              categoryName: "Chips",
              availability: 12,
              selected: false),
          CategoryListItem(
              categoryIcon: Icons.local_dining,
              categoryName: "Dining",
              availability: 12,
              selected: false),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.search, color: Colors.black45),
        SizedBox(width: 10),
        Expanded(
            child: TextField(
          decoration: InputDecoration(
              hintText: "Search...",
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(color: Colors.black87)),
        ))
      ],
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Food ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Delivery',
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 28)
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CustomerAppBar extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.menu),
          StreamBuilder(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<FoodItem> foodItems = snapshot.data;

              int length = foodItems != null ? foodItems.length : 0;
              return buildGestureDetector(length, context, foodItems);
            },
          ),
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int length, BuildContext context, List<FoodItem> foodItems) {
    return GestureDetector(
      onTap: () {
        if (length > 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 30),
        child: Text(length.toString()),
        padding: EdgeInsets.all(15),
        decoration:
            BoxDecoration(color: Colors.yellow[800], shape: BoxShape.circle),
      ),
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final bool selected;

  CategoryListItem({
      @required this.categoryIcon,
      @required this.categoryName,
      @required this.availability,
      @required this.selected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: selected ? Color(0xfffeb324) : Colors.white,
        border: Border.all(
            color: selected ? Colors.transparent : Colors.grey[200],
            width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[100],
              blurRadius: 15,
              offset: Offset(25, 0),
              spreadRadius: 5
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: selected ? Colors.transparent : Colors.grey,
                  width: 1),
            ),
            child: Icon(categoryIcon, color: Colors.black, size: 30),
          ),
          SizedBox(height: 5),
          Text(
            categoryName,
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
              width: 1,
              height: 20,
              color: Colors.black26),
          Text(
            availability.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          )
        ],
      ),
    );
  }
}
