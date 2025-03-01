import 'package:ecom_crud_api/product_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ProductController productController = ProductController();

  Future<void> fetchData() async {
    await productController.fetchProduct();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print(productController.product.length);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Product CRUD with API"),
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => productDialog(),
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: productController.product.length,
            itemBuilder: (context, index) {
              var productC = productController.product[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                elevation: 1,
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      productC.img.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(productC.productName.toString()),
                  subtitle: Text(
                      "Price: \$${productC.unitPrice} | Qty: ${productC.qty}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // otherwise the row will not showed in the trailing
                    children: [
                      IconButton(
                        onPressed: () => productDialog(
                            id: productC.sId,
                            name: productC.productName,
                            qty: productC.qty,
                            img: productC.img,
                            price: productC.unitPrice,
                            totalPrice: productC.totalPrice),
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          productController.deleteProduct(productC.sId.toString()).then((value){
                            if(value){

                              setState(() {
                                fetchData();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Product Delete"),
                                  duration: Duration(seconds: 2),
                                )

                              );
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Something wrong"),
                                    duration: Duration(seconds: 2),
                                  ));
                            }



                          });

                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  void productDialog({
    String? id,
    name,
    img,
    int? qty,
    price,
    totalPrice,
  }) {
    TextEditingController nameController = TextEditingController();
    // TextEditingController codeController=TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    TextEditingController tpController = TextEditingController();

    //initialize controller with parameters value

    nameController.text = name ?? "";
    qtyController.text = qty != null?  qty.toString(): "0";
    priceController.text = price.toString() ?? "";
    imageController.text = img ?? "";
    tpController.text = totalPrice !=null? totalPrice.toString() : "0";

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(id == null ? "Add Product" : "Update Product"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(labelText: 'Product image'),
                  ),
                  TextField(
                    controller: tpController,
                    decoration: InputDecoration(labelText: 'Product price'),
                  ),
                  TextField(
                    controller: qtyController,
                    decoration: InputDecoration(labelText: 'Product Qty'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration:
                        InputDecoration(labelText: 'Product Total Price'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel")),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (id == null) {
                              await productController.createProduct(
                                  nameController.text,
                                  imageController.text,
                                  int.parse(qtyController.text),
                                  int.parse(tpController.text),
                                  int.parse(priceController.text));
                            } else {
                              await productController.updateProduct(
                                  id,
                                  nameController.text,
                                  imageController.text,
                                  int.parse(qtyController.text),
                                  int.parse(tpController.text),
                                  int.parse(priceController.text));
                            }

                            await fetchData();
                            Navigator.pop(context);
                            setState(() {

                            });
                          },
                          child: Text(
                              id == null ? "Add Product" : "Update Product"))
                    ],
                  )
                ],
              ),
            ));
  }
}
