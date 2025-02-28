import "dart:convert";

import "package:ecom_crud_api/utils/urls.dart";
import "package:http/http.dart"as http;

class ProductController {

  List product=[];

  Future<void>fetchProduct() async{
    final response = await http.get(Uri.parse(Urls.readProduct));
    // print(response.body);
    if(response.statusCode==200){
      final data= jsonDecode(response.body);
      product=data["data"]; // api data ar data parameter ar length

    }
    print(product);
  }

  Future<void>createProduct(String name, img, int  qty, totalPrice, price ) async{
    final response = await http.post(Uri.parse(Urls.createProduct),
    headers:
    {
      "Content-Type": "application/json"
    },
      body: jsonEncode({
        "ProductName": name,
        "ProductCode": DateTime.now().millisecondsSinceEpoch,
        "Img": img,
        "Qty": qty,
        "UnitPrice": price,
        "TotalPrice": totalPrice
      })
    );

    if(response.statusCode==201){
      fetchProduct();
    }

  }
}