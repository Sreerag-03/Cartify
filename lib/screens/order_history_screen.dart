import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: orders.isEmpty
          ? Center(child: Text("No orders found"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID: ${order.id}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Total: ₹${order.totalAmount}",
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Date: ${DateFormat.yMMMd().format(order.timestamp.toDate())}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Divider(),
                        Column(
                          children: order.items.map((item) {
                            return ListTile(
                              leading: Image.network(item['image'], width: 50, height: 50),
                              title: Text(item['name']),
                              subtitle: Text("₹${item['price']} x ${item['quantity']}"),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
