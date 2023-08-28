import 'package:product_app/widgets/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/data/models/model_data.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Daftar Produk (${productProvider.daftarProducts.length})',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: (value) {
                productProvider.search(value);
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: productProvider.searchResults.length,
              itemBuilder: (context, i) {
                final product = productProvider.searchResults[i];
                String? namaProduk = product.namaProduk;

                return GestureDetector(
                  onTap: () {
                    // akan ditambahkan product detail ,yang berisi detail product
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120, // Tinggi gambar
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(product.gambar ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          namaProduk!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Price: ${product.harga}, Stock: ${product.stock}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FormProduct(product: product),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    productProvider.updateProduct(
                                        product.id!,
                                        value); // mengubah product dengan id
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.mode_edit_outlined,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Product'),
                                      content: Text(
                                          'Are you sure you want to delete this product?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); 
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            productProvider.deleteProduct(
                                                product
                                                    .id!); // Menghapus product dengan id
                                            Navigator.pop(
                                                context); 
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FormProduct()))
              .then((value) {
            if (value != null) {
              productProvider.create(value);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

  


class FormProduct extends StatefulWidget {
  final Product? product;
  const FormProduct({Key? key, this.product}) : super(key: key);

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final namaProduk = TextEditingController();
  final harga = TextEditingController();
  final stock = TextEditingController();
  final gambar = TextEditingController();

  @override
  void initState() {
    if (widget.product?.id != null) {
      namaProduk.text = widget.product!.namaProduk ?? '';
      harga.text = widget.product!.harga.toString();
      stock.text = widget.product!.stock.toString();
      gambar.text = widget.product!.gambar ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.product?.id == null ? 'Tambah Produk' : 'Edit Produk'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: namaProduk,
            decoration: const InputDecoration(
              hintText: 'Nama Produk...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: harga,
            decoration: const InputDecoration(
              hintText: 'Harga...',
              hintStyle: TextStyle(color: Colors.black45), // akan di jadikan custom text
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: stock,
            decoration: const InputDecoration(
              hintText: 'Stock...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: gambar,
            decoration: const InputDecoration(
              hintText: 'URL Gambar...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'namaProduk': namaProduk.text,
              'harga': int.tryParse(harga.text) ?? 0,
              'stock': int.tryParse(stock.text) ?? 0,
              'gambar': gambar.text,
            });
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
