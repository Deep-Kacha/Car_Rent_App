import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = ["All", "Cars", "SUVs", "XUVs", "Vans"];

  final List<Map<String, String>> cars = [
    {
      "name": "Brezzo 2020",
      "image": "assets/images/1car.jpg",
      "details": "5.0 ★ 143 Trips | Price: ₹2000/day",
      "category": "Cars",
    },
    {
      "name": "Mahindra Scorpio 2014",
      "image": "assets/images/2car.jpg",
      "details": "5.0 ★ 114 Trips | Price: ₹2500/day",
      "category": "SUVs",
    },
    {
      "name": "Maruti Suziki Ertiga",
      "image": "assets/images/4car.jpg",
      "details": "5.0 ★ 12 Trips | Price: ₹2500/day",
      "category": "Vans",
    },
  ];

  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    // Filter cars based on selected category
    List<Map<String, String>> filteredCars = selectedCategory == "All"
        ? cars
        : cars.where((car) => car["category"] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3",
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Ethan John",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search cars near you...",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: isSelected
                          ? EdgeInsets.symmetric(horizontal: 30, vertical: 8)
                          : EdgeInsets.zero,
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                            )
                          : null,
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey, // ✅ white text for selected
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // Available Cars
            Expanded(
              child: filteredCars.isEmpty
                  ? Center(
                      child: Text(
                        "No cars available in this category",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.only(bottom: 15),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                filteredCars[index]["image"]!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredCars[index]["name"]!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      filteredCars[index]["details"]!,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
