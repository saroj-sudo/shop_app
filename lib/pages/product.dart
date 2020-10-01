import 'package:flutter/material.dart';
import 'package:superMarket/pages/product_detail_page.dart';
import './login_page.dart';

class Product extends StatefulWidget {
  final String productId;
  final String productname;
  final double price;
  final String photoUrl;

  Product({
    this.productId,
    this.productname,
    this.price,
    this.photoUrl,
  });

  @override
  _ProductState createState() => _ProductState(
        productId: this.productId,
        productname: this.productname,
        price: this.price,
        photoUrl: this.photoUrl,
      );
}

class _ProductState extends State<Product> {
  final String productId;
  final String productname;
  final double price;
  final String photoUrl;

  bool isLiked = false;
  bool isCart = false;

  _ProductState({
    this.productId,
    this.productname,
    this.price,
    this.photoUrl,
  });

  @override
  void initState() {
    super.initState();
    chekIfLikedAndCart();
  }

  final currentUserId = currentUser.uid;

  chekIfLikedAndCart() async {
    final userLikeRef =
        favouritesRef.doc(currentUserId).collection("userFavourites");
    final userCartRef = cartsRef.doc(currentUserId).collection("userCarts");

    final likeproduct = await userLikeRef.doc(productId).get();

    final cartproduct = await userCartRef.doc(productId).get();
    if (likeproduct.exists) {
      setState(() {
        isLiked = true;
      });
      if (cartproduct.exists) {
        setState(() {
          isCart = true;
        });
      }
    }
  }

  handleLikeProduct() async {
    final collection =
        favouritesRef.doc(currentUserId).collection("userFavourites");

    final product = await collection.doc(productId).get();
    if (!product.exists) {
      await collection.doc(productId).set({
        'producId': productId,
        'productname': productname,
        'price': price,
        'photoUrl': photoUrl,
      });
      setState(() {
        isLiked = true;
      });
    } else {
      await collection.doc(productId).delete();
      setState(() {
        isLiked = false;
      });
    }
  }

  handleCartProduct() async {
    final collection = cartsRef.doc(currentUserId).collection("userCarts");

    final product = await collection.doc(productId).get();
    if (!product.exists) {
      await collection.doc(productId).set({
        'producId': productId,
        'productname': productname,
        'price': price,
        'photoUrl': photoUrl,
      });
      setState(() {
        isCart = true;
      });
    } else {
      await collection.doc(productId).delete();
      setState(() {
        isCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                    productId: productId,
                    productname: productname,
                    price: price,
                    photoUrl: photoUrl,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(photoUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: isCart ? Colors.green : Colors.yellow,
              ),
              onPressed: handleCartProduct,
            ),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.yellow,
              ),
              onPressed: () {
                handleLikeProduct();
              },
            ),
            Spacer(),
            Container(
              height: 120.0,
              width: double.infinity,
              color: Colors.brown.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productname,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellow,
                    ),
                  ),
                  Text(
                    "Rs.$price",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
