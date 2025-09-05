import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = "All";
  String searchQuery = "";

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
      "name": "Brezza 2020",
      "image": "assets/images/1car.jpg",
      "details": "143 Trips | Price: ₹2000/day",
      "category": "Cars",
      "price": "₹2000/day",
    },
    {
      "name": "Mahindra Scorpio 2014",
      "image": "assets/images/2car.jpg",
      "details": "114 Trips | Price: ₹2550/day",
      "category": "SUVs",
      "price": "₹2550/day",
    },
    {
      "name": "Maruti Suzuki Ertiga",
      "image": "assets/images/4car.jpg",
      "details": "12 Trips | Price: ₹3000/day",
      "category": "Vans",
      "price": "₹3000/day",
    },
    {
      "name": "Hyundai Creta 2021",
      "image": "assets/images/creta.jpg",
      "details": "4.8 ★ 95 Trips | Price: ₹2800/day",
      "category": "SUVs",
      "price": "₹2800/day",
    },
    {
      "name": "Toyota Innova Crysta",
      "image": "assets/images/innova.jpg",
      "details": "4.9 ★ 210 Trips | Price: ₹3500/day",
      "category": "Vans",
      "price": "₹3500/day",
    },
    {
      "name": "Tata Harrier 2022",
      "image": "assets/images/harrier.jpg",
      "details": "5.0 ★ 65 Trips | Price: ₹3200/day",
      "category": "SUVs",
      "price": "₹3200/day",
    },
    {
      "name": "Kia Seltos 2021",
      "image": "assets/images/seltos.jpg",
      "details": "4.7 ★ 130 Trips | Price: ₹2700/day",
      "category": "SUVs",
      "price": "₹2700/day",
    },
    {
      "name": "Honda City 2020",
      "image": "assets/images/city.jpg",
      "details": "4.9 ★ 180 Trips | Price: ₹2200/day",
      "category": "Cars",
      "price": "₹2200/day",
    },
    {
      "name": "Suzuki Swift Dzire",
      "image": "assets/images/dzire.jpg",
      "details": "4.8 ★ 200 Trips | Price: ₹1900/day",
      "category": "Cars",
      "price": "₹1900/day",
    },
    {
      "name": "Mahindra XUV700",
      "image": "assets/images/xuv700.jpg",
      "details": "5.0 ★ 50 Trips | Price: ₹4000/day",
      "category": "XUVs",
      "price": "₹4000/day",
    },
    {
      "name": "Hyundai Venue",
      "image": "assets/images/venue.jpg",
      "details": "4.6 ★ 80 Trips | Price: ₹2400/day",
      "category": "SUVs",
      "price": "₹2400/day",
    },
    {
      "name": "Renault Triber",
      "image": "assets/images/triber.jpg",
      "details": "4.7 ★ 70 Trips | Price: ₹2100/day",
      "category": "Vans",
      "price": "₹2100/day",
    },
    {
      "name": "Maruti Baleno",
      "image": "assets/images/baleno.jpg",
      "details": "4.8 ★ 160 Trips | Price: ₹2000/day",
      "category": "Cars",
      "price": "₹2000/day",
    },
  ];

  /// Getter for filtered cars (Category + Search)
  List<Map<String, String>> get filteredCars {
    final carsByCategory = selectedCategory == "All"
        ? cars
        : cars.where((car) => car["category"] == selectedCategory).toList();

    if (searchQuery.isEmpty) return carsByCategory;

    return carsByCategory
        .where(
          (car) =>
              car["name"]!.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  /// Align pages with navigation indexes (0,2,3,4)
  final Map<int, Widget> pages = {
    0: SizedBox(),
    2: Center(child: Text("📖 My Bookings")),
    3: Center(child: Text("⭐ Favorites")),
    4: Center(child: Text("📂 Menu")),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: selectedIndex == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
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
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  filteredCars[index]["details"] ??
                                                      "",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
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
