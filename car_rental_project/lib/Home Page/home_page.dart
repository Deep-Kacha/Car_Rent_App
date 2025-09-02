import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  Widget buildNavItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 25, color: isSelected ? Colors.black : Colors.grey),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  final List<String> categories = ["All", "Cars", "SUVs", "XUVs", "Vans"];

  final List<Map<String, String>> cars = [
    {
      "name": "Brezzo 2020",
      "image": "assets/images/1car.jpg",
      "details": "143 Trips",
      "category": "Cars",
      "price": "₹2000/day",
    },
    {
      "name": "Mahindra Scorpio 2014",
      "image": "assets/images/2car.jpg",
      "details": "114 Trips",
      "category": "SUVs",
      "price": "₹2550/day",
    },
    {
      "name": "Maruti Suzuki Ertiga",
      "image": "assets/images/4car.jpg",
      "details": "12 Trips",
      "category": "Vans",
      "price": "₹3000/day",
    },
    {
      "name": "Hyundai Creta 2021",
      "image": "assets/images/creta.jpg",
      "details": "95 Trips",
      "category": "SUVs",
      "price": "₹2800/day",
    },
    {
      "name": "Tata Nexon EV 2023",
      "image": "assets/images/5car.jpg",
      "details": "47 Trips",
      "category": "XUVs",
      "price": "₹3200/day",
    },
    {
      "name": "Honda City 2019",
      "image": "assets/images/6car.jpg",
      "details": "68 Trips",
      "category": "Cars",
      "price": "₹2200/day",
    },
    {
      "name": "Toyota Innova Crysta 2022",
      "image": "assets/images/7car.jpg",
      "details": "133 Trips",
      "category": "Vans",
      "price": "₹3500/day",
    },
    {
      "name": "Kia Seltos 2021",
      "image": "assets/images/8car.jpg",
      "details": "89 Trips",
      "category": "SUVs",
      "price": "₹2900/day",
    },
    {
      "name": "Ford EcoSport 2020",
      "image": "assets/images/9car.jpg",
      "details": "75 Trips",
      "category": "XUVs",
      "price": "₹2500/day",
    },
    {
      "name": "Volkswagen Polo 2018",
      "image": "assets/images/10car.jpg",
      "details": "54 Trips",
      "category": "Cars",
      "price": "₹2100/day",
    },
  ];

  String selectedCategory = "All";

  final Map<int, Widget> pages = {
    0: SizedBox(),
    2: Center(child: Text("📖 My Bookings")),
    3: Center(child: Text("⭐ Favorites")),
    4: Center(child: Text("📂 Menu")),
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredCars = selectedCategory == "All"
        ? cars
        : cars.where((car) => car["category"] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: selectedIndex == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile + Search
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

                  /// Categories
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                                ? EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 8,
                                  )
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
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),

                  /// Cars List
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
                              return Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Image.asset(
                                        filteredCars[index]["image"]!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3E2723),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// Car Name + Favorite
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                filteredCars[index]["name"]!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),

                                          /// Only Trips Count
                                          Text(
                                            filteredCars[index]["details"] ??
                                                "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),

                                          SizedBox(height: 4),

                                          /// Location + Price
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Race course • 9 Km",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  filteredCars[index]["price"]!,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
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
              )
            : pages[selectedIndex] ?? Center(child: Text("Page not found")),
      ),

      /// Bottom Nav
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(Icons.home, "Home", 0),
            buildNavItem(Icons.directions_car, "Booked Car", 2),
            buildNavItem(Icons.favorite_border, "Favorite", 3),
            buildNavItem(Icons.menu, "Menu", 4),
          ],
        ),
      ),
    );
  }
}
