// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/model/products_repository.dart';
import 'supplemental/asymmetric_view.dart';

class HomePage extends StatelessWidget {
  final Category category;
  const HomePage({ this.category = Category.all, Key? key}) : super(key: key);

  List<Card> _buildGridCards(BuildContext context){
    List<Product> products = ProductsRepository.loadProducts(Category.all);
    if(products.isEmpty){
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString());

    return products.map((product){
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.button,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

              // SizedBox(height: 4.0,),
              Text(
                formatter.format(product.price),
                style: theme.textTheme.caption,
              ),
                ],
              ),
            ),
            AspectRatio(aspectRatio: 18/11,
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
              fit: BoxFit.fitWidth,
            ),),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: theme.textTheme.headline2,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        formatter.format(product.price),
                        style: theme.textTheme.subtitle2,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      );
    }).toList();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return  AsymmetricView(
      products: ProductsRepository.loadProducts(category),
    );
    //   Scaffold(
    //   // TODO: Add app bar (102)
    //   appBar: AppBar(
    //     title: Text('SHRINE'),
    //     leading: IconButton(
    //       onPressed: () {
    //         print('menu button');
    //       },
    //       icon: Icon(Icons.menu,
    //       semanticLabel: 'menu',),
    //     ),
    //     actions: [
    //       IconButton(onPressed: () {
    //         print('search button');
    //       }, icon: Icon(Icons.search)),
    //       IconButton(onPressed: () {},
    //           icon: Icon(Icons.tune,
    //           semanticLabel: 'filter button',
    //           )),
    //     ],
    //   ),
    //
    //   // TODO: Add a grid view (102)
    //   body: AsymmetricView(
    //     products: ProductsRepository.loadProducts(Category.all),
    //   ),
    //   // GridView.count(
    //   //     crossAxisCount: 2,
    //   //     padding: const EdgeInsets.all(16.0),
    //   //     childAspectRatio: 8.0 / 9.0,
    //   //     children: _buildGridCards(context) // Replace
    //   // ),
    //   // TODO: Set resizeToAvoidBottomInset (101)
    //   resizeToAvoidBottomInset: false,
    // );
  }
}
