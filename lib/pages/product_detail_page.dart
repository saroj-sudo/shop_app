import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String productname;
  final double price;
  final String photoUrl;
  ProductDetailPage({
    this.productId,
    this.productname,
    this.price,
    this.photoUrl,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState(
        productId: this.productId,
        productname: this.productname,
        price: this.price,
        photoUrl: this.photoUrl,
      );
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final String productId;
  final String productname;
  final double price;
  final String photoUrl;

  _ProductDetailPageState({
    this.productId,
    this.productname,
    this.price,
    this.photoUrl,
  });

  bool showFeatures = false;
  bool isLiked = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(AntDesign.arrowleft),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        productname,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Text(
                              "1",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.yellow,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    bottom: 20.0,
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Entypo.heart : Entypo.heart_outlined,
                        size: 50.0,
                        color:
                            isLiked ? Colors.redAccent[700] : Colors.red[300],
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        AntDesign.infocirlce,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      Text(
                        price.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'kfjdofjdljfoejdjfjeojdjfoejjdfjjsjfejsoiafjdcvlkdjfeojfdfjoiejajdf,dfjeosjdfoejsfdjfjsfjejfjdlj',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          buildFeatures();
                          setState(() {
                            showFeatures = !showFeatures;
                          });
                        },
                        icon: Icon(
                          showFeatures
                              ? AntDesign.upcircle
                              : AntDesign.downcircle,
                        ),
                      ),
                      Text(
                        "Features",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              showFeatures ? buildFeatures() : Text(''),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                width: double.infinity,
                child: Text(
                  "Colors: ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    Text(
                      'Quantity: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        child: Text("Order Now"),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        child: Text("Add to Cart"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatures() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 20.0, bottom: 10.0),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('fdfoejofjdjfoejfalj'),
              ),
            ),
            Card(
              elevation: 5.0,
              child: ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('fdfoejofjdjfoejfalj'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
