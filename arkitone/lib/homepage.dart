import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Caterpillar vehicles illustration
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (index) {
                    return Container(
                      margin: EdgeInsets.all(4),
                      color: Colors.amber[200],
                      // Replace with actual vehicle illustrations
                      child: Icon(Icons.local_shipping, size: 40, color: Colors.amber[800]),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              // Caterpillar logo
              Text(
                'CATERPILLAR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '"Your one stop vehicle inspection app"',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              // Login button
              ElevatedButton(
                child: Text('LOGIN'),
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.amber[800],
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // TODO: Implement login functionality
                },
              ),
              SizedBox(height: 10),
              // Sign up button
              OutlinedButton(
                child: Text('SIGN UP'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.amber),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // TODO: Implement sign up functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}