import 'package:ecom_crud_api/product_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 final ProductController productController= ProductController();

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
          onPressed: ()=>productDialog(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: productController.product.length,
          itemBuilder: (context, index){

          var productC= productController.product[index];
          return  Card(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            elevation: 1,
            child:ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(productC["Img"]),),
              title: Text(productC["ProductName"]),
              subtitle: Text("Price: \$${productC["UnitPrice"]} | Qty: ${productC["Qty"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // otherwise the row will not showed in the trailing
                children: [
                  IconButton(
                    onPressed: ()=>productDialog(),
                    icon: Icon(Icons.edit),

                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.delete,color: Colors.red,),

                  )


                ],
              ),

            ),
          );

      })
    );
  }

  void productDialog(){

    TextEditingController nameController=TextEditingController();
   // TextEditingController codeController=TextEditingController();
    TextEditingController qtyController=TextEditingController();
    TextEditingController priceController=TextEditingController();
    TextEditingController imageController=TextEditingController();
    TextEditingController tpController=TextEditingController();


    showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          title:Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name'
                ),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(
                    labelText: 'Product image'
                ),
              ),
              TextField(
                controller: tpController,
                decoration: InputDecoration(
                    labelText: 'Product price'
                ),
              ),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(
                    labelText: 'Product Qty'
                ),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                    labelText: 'Product Total Price'
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: ()=>Navigator.pop(context),
                      child: Text("Cancel")),
                  SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed: ()async{


                        await  productController.createProduct(nameController.text, imageController.text,  int.parse(qtyController.text), int.parse(tpController.text), int.parse(priceController.text));
                         await fetchData();
                          Navigator.pop(context);


                      },
                      child: Text("Add Product"))
                ],
              )

            ],
          ),

        ));

  }
}
