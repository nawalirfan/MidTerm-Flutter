import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_nawal_22805/product_model.dart';
import 'package:midterm_nawal_22805/provider_class.dart';
import 'package:provider/provider.dart';

class GridViewProducts extends StatefulWidget {
  const GridViewProducts({super.key});

  @override
  State<GridViewProducts> createState() => _GridView();
}

class _GridView extends State<GridViewProducts> {
  List<Products> postList = [];

  @override
  void initState() {
    Provider.of<DataClass>(context, listen: false).getPostData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<DataClass>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
      ),
      body: Consumer<DataClass>(builder: (context, value, child) {
        if (value.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _buildList(postModel.post ?? []);
        }
      }),
    );
  }

  Padding _buildList(List<Products> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 5, left: 5),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 11.0 / 6.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                context: context,
                builder: (context) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      color: const Color(0x99A4EBEE),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: item.images.map((image) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(item.description.toString()),
                          Text('\$ ${item.price.toString()}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Text(item.rating.toString()),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(item.discountPercentage.toString()),
                                      const Icon(
                                        Icons.discount,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Material(
              elevation: 10,
              child: Card(
                color: const Color.fromARGB(255, 157, 245, 240),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    if (item.images.isNotEmpty && item.images[0] is String)
                      Image.network(
                        item.images[0],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text(item.title),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text('${item.price}  USD'),
                            const Icon(Icons.visibility),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.description}',
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
