import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/calculator/calculator.dart';

class ScrapPickupScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        title: Text(
          'Schedule Pickup',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calculator()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            StepProgressIndicator(),
            SizedBox(height: 32.0),
            Text(
              'Selected scrap for pickup',
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text('Price may fluctuate because of the recycling industry.',
                style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 16.0),
            ScrapCategory(
              title: 'Paper Categories',
              items: ['Newspaper'],
            ),
            ScrapCategory(
              title: 'Metal Categories',
              items: ['Oil Container'],
            ),
            SizedBox(height: 32.0),
            UploadImageSection(),
            SizedBox(height: 32.0),
            OffersAndBenefitsSection(),
            SizedBox(height: 16.0),
            EarningsSection(),
            SizedBox(height: 32.0),
            ContinueButton(),
          ],
        ),
      ),
    );
  }
}

class StepProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Color(0xff3b61f4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StepIndicator(isActive: false, label: 'Pickup date'),
          StepIndicator(isActive: false, label: 'Confirm'),
        ],
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final bool isActive;
  final String label;

  StepIndicator({required this.isActive, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundColor: Colors.white,
          child: isActive
              ? Icon(
                  Icons.check,
                  size: 16.0,
                  color: Colors.black,
                )
              : Icon(
                  Icons.abc,
                  size: 16.0,
                  color: Colors.black,
                ),
        ),
        SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}

class ScrapCategory extends StatelessWidget {
  final String title;
  final List<String> items;

  ScrapCategory({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Column(
          children: items
              .map((item) => Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Text(item),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class UploadImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Color(0xFF06193D),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.camera_alt, size: 40.0, color: Colors.white),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              'Upload scrap item\'s pictures\nThis will help us identify your scrap items better.',
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}

class OffersAndBenefitsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Apply Coupons',
            style: TextStyle(fontSize: 16.0),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}

class EarningsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Earnings',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        EarningsItem(
          itemName: 'Newspaper',
          quantity: 2,
        ),
        EarningsItem(
          itemName: 'Oil Container',
          quantity: 1,
        ),
        Divider(thickness: 1.0, color: Colors.white),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items Total'),
                  Text('₹56'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Coupon Applied'),
                  Text('₹0'),
                ],
              ),
            ),
          ],
        ),
        Divider(thickness: 1.0, color: Colors.white),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Approximate Earnings',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text('₹56'),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          'With online payment 10% extra on total amount',
          style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class EarningsItem extends StatefulWidget {
  final String itemName;
  final int quantity;

  EarningsItem({required this.itemName, required this.quantity});

  @override
  _EarningsItemState createState() => _EarningsItemState();
}

class _EarningsItemState extends State<EarningsItem> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width *
                0.6, // Set a fixed width for more space
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
              borderRadius: BorderRadius.circular(
                  10.0), // Set the border radius for rounded corners
            ),
            padding: EdgeInsets.all(16.0), // Padding for internal space
            child: Text(
              widget.itemName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0, // Optional: Adjust font size if needed
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
              borderRadius: BorderRadius.circular(
                  10.0), // Set the border radius for rounded corners
            ),
            padding:
                EdgeInsets.all(8.0), // Padding for spacing inside the container
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // To avoid unnecessary space in the row
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decreaseQuantity,
                ),
                Text(
                  _quantity.toString(),
                  style: TextStyle(color: Colors.black),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _increaseQuantity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff3b61f4), // Background color
        ),
        child: Center(
            child: Text(
          'Continue',
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
