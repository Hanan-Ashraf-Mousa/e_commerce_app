import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';

class FirebaseManager {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static CollectionReference<UserModel> getUsersCollection() {
    return db
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore:
              (snapshot, _) => UserModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  Future<void> storeUser(UserModel user) async {
    try {
      await getUsersCollection().doc(user.id).set(user);
    } catch (e) {
      throw Exception('Failed to store user: $e');
    }
  }

  static Future<UserModel?> getUserProfile(String id) async {
    final docSnapshot = await getUsersCollection().doc(id).get();
    return docSnapshot.data();
  }

  static CollectionReference getCartCollection(String uid) {
    return db.collection('users').doc(uid).collection('cart');
  }

  Future<void> addToCart(ProductModel product, String uid) async {
    try {
      final cartDoc = await getCartCollection(uid).doc(product.id).get();
      if (cartDoc.exists) {
        await getCartCollection(uid).doc(product.id).update({
          'quantity': FieldValue.increment(product.quantity),
        });
      } else {
        await getCartCollection(uid).doc(product.id).set({...product.toJson()});
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> clearCart(String userId) async {
    final cartRef = getCartCollection(userId);
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await getCartCollection(userId).doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<void> updateCartQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(userId, productId);
      } else {
        await getCartCollection(
          userId,
        ).doc(productId).update({'quantity': quantity});
      }
    } catch (e) {
      throw Exception('Failed to update cart quantity: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    try {
      final snapshot = await getCartCollection(userId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'product': ProductModel.fromJson(data as Map<String, dynamic>),
          'quantity': data['quantity'] as int? ?? 1,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  CollectionReference getFavoritesCollection(String uid) {
    return db.collection('users').doc(uid).collection('favourites');
  }

  Future<void> addToFavorites(ProductModel product, String userId) async {
    try {
      await getFavoritesCollection(
        userId,
      ).doc(product.id).set(product.toJson());
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await getFavoritesCollection(userId).doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Future<List<ProductModel>> getFavoriteItems(String userId) async {
    try {
      final snapshot = await getFavoritesCollection(userId).get();
      return snapshot.docs
          .map(
            (doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite items: $e');
    }
  }

  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final doc = await getFavoritesCollection(userId).doc(productId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  // orders
  CollectionReference getOrdersCollection(String uid) {
    return db.collection('users').doc(uid).collection('orders');
  }

  Future<void> placeOrder(String userId, List<ProductModel> products) async {
    final orderData =
        OrderModel(
          id: userId,
          products: products,
          createdAt: DateTime.now(),
          status: 'pending',
        ).toJson();
    await getOrdersCollection(userId).add(orderData);
  }

  Future<List<OrderModel>> getOrders(String userId) async {
    final snapshot =
        await getOrdersCollection(
          userId,
        ).orderBy('createdAt', descending: true).get();

    return snapshot.docs
        .map(
          (doc) => OrderModel.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          }),
        )
        .toList();
  }
}
