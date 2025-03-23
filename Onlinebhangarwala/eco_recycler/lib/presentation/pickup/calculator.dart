import 'package:flutter/material.dart';
import 'package:eco_recycler/presentation/cancel_reason/cancel_reason.dart';
import 'package:eco_recycler/presentation/pickup/calculator_result.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:eco_recycler/widgets/app_bar/pickup_app_bar.dart';

class Calculator extends StatefulWidget {
  final String pickupId;
  final String pickupdate;
  final String pickuptime;
  final String name;
  final String address;

  Calculator({
    required this.pickupId,
    required this.pickupdate,
    required this.pickuptime,
    required this.name,
    required this.address,
  });

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List<double> _quantities = [0.0];
  List<String?> _selectedCategories = [null];
  List<String> _categories = [];
  Map<String, double> _categoryPrices = {};
  Map<String, String> _categoryUnits = {};
  Map<String, int> _categoryIds =
      {}; // Map to store category names with their IDs
  late Future<void> _fetchCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesFuture = _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final ApiService apiService = ApiService();
    final List<Map<String, dynamic>> categoryData =
        await apiService.fetchCategoriesWithPrices();

    setState(() {
      _categories =
          categoryData.map((data) => data['name'].toString()).toList();
      _categoryPrices = {
        for (var data in categoryData)
          data['name'].toString(): double.parse(data['price'])
      };
      _categoryUnits = {
        for (var data in categoryData)
          data['name'].toString(): data['per'] ?? 'Kg'
      };
      _categoryIds = {
        for (var data in categoryData)
          data['name'].toString():
              data['sub_id'] // Assuming `id` is the subcategoryId
      };
      if (_categories.isNotEmpty) {
        _selectedCategories[0] = _categories[0];
      }
    });
  }

  double _calculateEarnings() {
    double totalEarnings = 0.0;
    List<Map<String, dynamic>> calculatedItems = [];

    for (int i = 0; i < _quantities.length; i++) {
      if (_quantities[i] > 0) {
        String categoryName = _selectedCategories[i] ?? '';
        double pricePerUnit = _categoryPrices[categoryName] ?? 0.0;
        double totalPrice = (pricePerUnit * _quantities[i]).toDouble();

        calculatedItems.add({
          'subcat': categoryName,
          'unit': _categoryUnits[categoryName] ?? '',
          'kg': _quantities[i].toString(),
          'totalprice': totalPrice,
          'price': pricePerUnit
        });

        totalEarnings += totalPrice;
      }
    }

    return totalEarnings;
  }

  Widget _buildCategoryRow(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.02; // Responsive padding

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategories[index],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategories[index] = newValue;
                    });
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(width: padding * 2),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: _quantities[index].toString(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _quantities[index] = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: padding * 2),
          IconButton(
            onPressed: () {
              setState(() {
                _quantities.removeAt(index);
                _selectedCategories.removeAt(index);
              });
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _addCategoryRow() {
    setState(() {
      _quantities.add(0.0);
      _selectedCategories.add(_categories.isNotEmpty ? _categories[0] : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05; // Responsive padding

    return Scaffold(
      appBar: PCustomAppBar(title: 'Scrap Weighing', pickupId: widget.pickupId),
      body: FutureBuilder<void>(
        future: _fetchCategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          } else {
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scrap Items',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _quantities.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryRow(index);
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextButton(
                    onPressed: _addCategoryRow,
                    child: Text(
                      '+ Add Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      double totalEarnings = _calculateEarnings();
                      List<Map<String, dynamic>> calculatedItems = [];
                      List<int> selectedSubcategoryIds = [];

                      for (int i = 0; i < _quantities.length; i++) {
                        if (_quantities[i] > 0) {
                          double totalPrice =
                              (_categoryPrices[_selectedCategories[i]] ?? 0.0) *
                                  _quantities[i];
                          int subcategoryId =
                              _categoryIds[_selectedCategories[i]] ?? 0;

                          calculatedItems.add({
                            'unit':
                                _categoryUnits[_selectedCategories[i]] ?? '',
                            'subcat': _selectedCategories[i],
                            'kg': _quantities[i].toString(),
                            'totalprice': totalPrice,
                            'price':
                                (_categoryPrices[_selectedCategories[i]] ?? 0.0)
                          });

                          selectedSubcategoryIds.add(subcategoryId);
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculationResults(
                            pickupId: widget.pickupId,
                            calculatedItems: calculatedItems,
                            totalAmount: totalEarnings,
                            pickupdate: widget.pickupdate,
                            pickuptime: widget.pickuptime,
                            name: widget.name,
                            address: widget.address,
                            subcategoryIds:
                                selectedSubcategoryIds, // Pass the IDs
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                      backgroundColor: Color(0xff3b61f4),
                    ),
                    child: Text(
                      'Calculate',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenWidth * 0.045),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
