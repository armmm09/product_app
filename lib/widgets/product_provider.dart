import 'package:product_app/data/models/model_data.dart';
import 'package:flutter/material.dart';



class ProductProvider extends ChangeNotifier {
 
  List<Product> daftarProducts = [
    Product(
      id: 1,
      namaProduk: 'Apple',
      harga: 55000,
      stock: 33,
      gambar: 'https://5.imimg.com/data5/AK/RA/MY-68428614/apple-1000x1000.jpg',
    ),
    Product(
      id: 2,
      namaProduk: 'Orange',
      harga: 35000,
      stock: 20,
      gambar: 'https://i0.wp.com/www.astronauts.id/blog/wp-content/uploads/2022/12/Agar-Tidak-Salah-Ini-Cara-Memilih-Jeruk-yang-Manis.jpg?w=1280&ssl=1',
    ),
    Product(
      id: 3,
      namaProduk: 'Banana',
      harga: 25000,
      stock: 50,
      gambar: 'https://www.astronauts.id/blog/wp-content/uploads/2023/02/Kenali-Ciri-Buah-Pisang-Matang.jpg',
    ),
   
  ];

  List<Product> searchResults = [];

  void search(String query) {
    searchResults = daftarProducts.where((product) {
      return (product.namaProduk ?? '').toLowerCase().contains(query.toLowerCase()) ||
          product.id.toString() == query;
    }).toList();
    notifyListeners();
    //metode seperti notifyListeners() untuk memberi tahu widget-widget yang mendengarkan bahwa ada perubahan state.
    // pengganti set staete di change motifier
  }

  void create(Map<String, dynamic> value) {
    try {
      int id = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> data = {...value};
      data['id'] = id;

      final product = Product.fromJson(data);
      daftarProducts.add(product);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }

 void updateProduct(int productId, Map<String, dynamic> updatedData) {
    final productIndex = daftarProducts.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      daftarProducts[productIndex] = Product.fromJson(updatedData);
      notifyListeners();
    }
  }

  void deleteProduct(int productId) {
    daftarProducts.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

}


