// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/seller_model.dart';

class DeliveryMansView extends StatefulWidget {
  const DeliveryMansView({Key? key}) : super(key: key);

  @override
  State<DeliveryMansView> createState() => _DeliveryMansViewState();
}

class _DeliveryMansViewState extends State<DeliveryMansView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'Search by name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 10, color: Colors.blue)),
                  labelPadding: EdgeInsets.symmetric(horizontal: 100),
                  tabs: [
                    Tab(
                      child: Text('All Delivery Mans',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Tab(
                      child: Text('Accepted',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Tab(
                      child: Text('Not Accepted',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  buildSellerDataTable(
                    getSellersStream(role: 'delivery'),
                  ),
                  buildSellerDataTable(
                      getSellersStream(approved: true, role: 'delivery')),
                  buildSellerDataTable(
                      getSellersStream(approved: false, role: 'delivery')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSellerDetailsDialog(SellerModel seller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seller Details'),
          content: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: seller.image == null
                      ? CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person_outline),
                        )
                      : CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                            child: Image.network(seller.image!),
                          ),
                        ),
                ),
                Container(
                  color: Colors.white,
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Primary Information'),
                      Text('Address Information'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('First Name:   ${seller.firstName ?? ''}'),
                          Text('Middle Name:  ${seller.middleName ?? ''}'),
                          Text('Last Name:    ${seller.lastName ?? ''}'),
                          Text('Phone Number: ${seller.phoneNumber ?? ''}'),
                          Text('Email:   ${seller.email ?? ''}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country:     ${seller.country ?? ''}'),
                          Text('Region:      ${seller.region ?? ''}'),
                          Text('City:        ${seller.city ?? ''}'),
                          Text('Zone:        ${seller.zone ?? ''}'),
                          Text('Woreda:      ${seller.woreda ?? ''}'),
                          Text('Kebele:      ${seller.kebele ?? ''}'),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildSellerDataTable(Stream<List<SellerModel>> sellersStream) {
    return StreamBuilder<List<SellerModel>>(
        stream: sellersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Center(child: const Text('No registered seller')));
          } else {
            List<SellerModel> filteredSellers = snapshot.data!
                .where((seller) =>
                    seller.firstName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    seller.middleName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    seller.lastName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .toList();
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade700),
                      showCheckboxColumn: false,
                      columnSpacing: 100,
                      dataTextStyle: TextStyle(fontFamily: 'Normal'),
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Permission',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Image',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Id',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text('First Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Middle Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Last Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Phone Number',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Email',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Country',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Region',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('City',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Zone',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Woreda',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Kebele',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: filteredSellers.asMap().entries.map((entry) {
                        final int rowIndex = entry.key;
                        final SellerModel seller = entry.value;
                        return DataRow(
                          color: MaterialStateColor.resolveWith((states) =>
                              rowIndex % 2 == 0
                                  ? Colors.grey.shade300
                                  : Colors.white),
                          cells: [
                            DataCell(
                              Container(
                                width: 100,
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (seller.approved == false) {
                                      setState(() {
                                        seller.approved = true;
                                      });
                                    } else {
                                      setState(() {
                                        seller.approved = false;
                                      });
                                    }

                                    await FirebaseFirestoreHelper.instance
                                        .updateSeller(seller);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    seller.approved == false
                                        ? 'Accept'
                                        : 'Reject',
                                    style: TextStyle(
                                      color: seller.approved == false
                                          ? Colors.green
                                          : Colors.red,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              seller.image == null
                                  ? CircleAvatar(
                                      radius: 20,
                                      child: Icon(Icons.person),
                                    )
                                  : CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: Image.network(
                                          seller.image!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.id ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.firstName ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.middleName ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.lastName ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.phoneNumber ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.email ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.country ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.region ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.city ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.zone ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.woreda ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Text(
                                  seller.kebele ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                          onSelectChanged: (selected) {
                            showSellerDetailsDialog(seller);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

Stream<List<SellerModel>> getSellersStream({bool? approved, String? role}) {
  Query query = FirebaseFirestore.instance.collection('sellers');
  if (approved != null) {
    query = query.where('approved', isEqualTo: approved);
  }
  
  if (role != null) {
    query = query.where('role', isEqualTo: role);
  }
  return query.snapshots().map((querySnapshot) {
    List<SellerModel> sellerModels = querySnapshot.docs
        .map((doc) => SellerModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return sellerModels;
  });
}
