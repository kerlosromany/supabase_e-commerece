import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order_model.dart';
import '../../models/user_data_model.dart';
import 'widgets/order_widget.dart';

import '../../../main.dart';

class AreaOrdersScreen extends StatefulWidget {
  final String area;
  const AreaOrdersScreen({super.key, required this.area});

  @override
  State<AreaOrdersScreen> createState() => _AreaOrdersScreenState();
}

class _AreaOrdersScreenState extends State<AreaOrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getTheArea();
    if(areaSelected == "other"){
      fetchOrderWithCustomAreas();
    }else{
      fetchOrderWithUserData();
    }
    
  }

  String areaSelected = "";
  void getTheArea() {
    if (widget.area == "بنها") {
      areaSelected = "banha";
    } else if (widget.area == "شبرا مصر") {
      areaSelected = "shoubra";
    } else if (widget.area == "وسط البلد") {
      areaSelected = "wst_el_balad";
    } else {
      areaSelected = "other";
    }
  }

  Future<void> fetchOrderWithCustomAreas() async {
  setState(() {
    isLoading = true;
  });

  try {
    final response = await supabase
        .from('orders')
        .select('*, users!inner(id, name, email, address, phoneNumber)')
        .not('area', 'in', ['banha', 'shoubra', 'wst_el_balad'])
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      setState(() {
        errorMessage = 'No data found for custom areas.';
        isLoading = false;
      });
    } else {
      setState(() {
        orders = response;
        isLoading = false;
      });
    }
  } on PostgrestException catch (e) {
    log("PostgrestException: $e");
  } catch (e) {
    log("Error: $e");
  }
}


  Future<void> fetchOrderWithUserData() async {
    setState(() {
      isLoading = true;
    });

    try {

      // Fetch orders along with user data

      final response = await supabase
          .from('orders')
          .select('*, users!inner(id, name, email, address, phoneNumber)')
          .eq("area", areaSelected)
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        setState(() {
          errorMessage = 'Error fetching data: $response';
          isLoading = false;
        });
      } else {
        setState(() {
          orders = response;
          isLoading = false;
        });
      }
    } on PostgrestException catch (e) {
      log("$e");
      log(e.toString());
    } catch (e) {
      log("$e");
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: errorMessage.isEmpty? isLoading? const Center(
          child: CircularProgressIndicator(),
        ) : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderWidget(
              orderModel: OrderModel.fromJson(order),
              userDataModel: UserDataModel.fromJson(order['users']),
              
            );
          },
        ) : Center(
          child: Text(errorMessage  , style: const TextStyle(color: Colors.red),),
        ),
      ),
    );
  }
}
