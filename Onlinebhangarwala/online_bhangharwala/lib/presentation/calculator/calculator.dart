import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/pickup_datetime/pickup_datetime.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/widgets/app_bar/appbar_home.dart';
import 'package:online_bhangharwala/widgets/bottomNavigation.dart';
import 'package:online_bhangharwala/widgets/drawer.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List<int> _quantities = [0];
  List<String?> _selectedCategories = [null];
  List<String> _categories = [];
  int _currentIndex = 2;
  Map<String, double> _categoryPrices = {};
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
      if (_categories.isNotEmpty) {
        _selectedCategories[0] = _categories[0];
      }
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  double _calculateEarnings() {
    double totalEarnings = 0.0;
    for (int i = 0; i < _quantities.length; i++) {
      double pricePerUnit = _categoryPrices[_selectedCategories[i]] ?? 0.0;
      totalEarnings += pricePerUnit * _quantities[i];
    }
    return totalEarnings;
  }

  Widget _buildCategoryRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_quantities[index] > 0) _quantities[index]--;
                    });
                  },
                  icon: Icon(Icons.remove, color: Colors.black),
                ),
                Text(
                  '${_quantities[index]}',
                  style: TextStyle(color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantities[index]++;
                    });
                  },
                  icon: Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
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
      _quantities.add(0);
      _selectedCategories.add(_categories.isNotEmpty ? _categories[0] : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(title: 'Home', icon: Icons.home),
      drawer: DrawerPage(),
      body: FutureBuilder<void>(
        future: _fetchCategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimate Your Earnings',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _quantities.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryRow(index);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: _addCategoryRow,
                    child: Text('+ Add Category',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.white),
                  Text(
                    'Your Approximate Earnings',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    '₹ ${_calculateEarnings().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScrapPickupScreen()),
                      );
                    }, // Disable button if no payment mode is selected
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Color(0xff3b61f4)),
                    child: Text('Schedule Pickup',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
