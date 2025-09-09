import 'package:car_rental_project/Home%20Page/Favorite.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_project/Home%20Page/Menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = "All";
  String searchQuery = "";

  /// Store favorite car names
  Set<String> favoriteCars = {};

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
      "details": "143 Trips",
      "category": "Cars",
      "price": "₹2000/day",
// <<<<<<< HEAD
      "address": "Race Course • 9 Km",
// =======
      "location": "Race Course, Rajkot",
// >>>>>>> 48ce218afaebcc15c3ad9fcd7d7ee1d08cf01048
    },
    {
      "name": "Mahindra Scorpio 2014",
      "image": "assets/images/2car.jpg",
      "details": "114 Trips",
      "category": "XUVs",
      "price": "₹2550/day",
// <<<<<<< HEAD
      "address": "Ramnath para",
// =======
      "location": "Ring Road, Ahmedabad",
// >>>>>>> 48ce218afaebcc15c3ad9fcd7d7ee1d08cf01048
    },
    {
      "name": "Maruti Suzuki Ertiga",
      "image": "assets/images/4car.jpg",
      "details": "12 Trips",
      "category": "Vans",
      "price": "₹3000/day",
// <<<<<<< HEAD
      "address": "Sahakar road",
// =======
      "location": "Nanpura, Surat",
// >>>>>>> 48ce218afaebcc15c3ad9fcd7d7ee1d08cf01048
    },
    {
      "name": "Hyundai Creta 2021",
      "image": "assets/images/creta.jpg",
      "details": "95 Trips",
      "category": "SUVs",
      "price": "₹2800/day",
// <<<<<<< HEAD
      "address": "Satellite chowk",
    },
    {
      "name": "Kia seltos 2020",
      "image": "assets/images/8car.jpg",
      "details": "13 Trips",
      "category": "SUVs",
      "price": "₹2100/day",
      "address": "Bhaktinagar circle",
    },
    {
      "name": "Tata Nexon EV 2023",
      "image": "assets/images/5car.jpg",
      "details": "15 Trips",
      "category": "SUVs",
      "price": "₹3000/day",
      "address": "University road ",
    },
    {
      "name": "Inova Crysta 2021",
      "image": "assets/images/7car.jpg",
      "details": "75 Trips",
      "category": "XUVs",
      "price": "₹2500/day",
      "address": "morbi road ",
    },
    {
      "name": "VollksWagen Polo tdi 2021",
      "image": "assets/images/10car.jpg",
      "details": "50 Trips",
      "category": "Cars",
      "price": "₹2700/day",
      "address": "Bhavnath Park",
    },
    {
      "name": "Ford Ecosport 2016",
      "image": "assets/images/9car.jpg",
      "details": "90 Trips",
      "category": "SUVs",
      "price": "₹2300/day",
      "address": "Kotecha Chowk",
// =======
//       "location": "Location : Gota Road, Ahmedabad",
// >>>>>>> 48ce218afaebcc15c3ad9fcd7d7ee1d08cf01048
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

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> pages = {
      0: SizedBox(), // Home
      2: Center(child: Text("📖 My Bookings")),
      3: FavoritePage(
        favoriteCars: cars
            .where((car) => favoriteCars.contains(car["name"]))
            .toList(),
        onToggleFavorite: (String carName) {
          setState(() {
            if (favoriteCars.contains(carName)) {
              favoriteCars.remove(carName);
            } else {
              favoriteCars.add(carName);
            }
          });
        },
      ),
      4: MenuPage(),
    };

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
                              radius: 21,
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/150?img=3",
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Ethan John",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
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
                              final car = filteredCars[index];
                              final isFavorite = favoriteCars.contains(
                                car["name"],
                              );

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
                                        car["image"]!,
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
                                                car["name"]!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (isFavorite) {
                                                      favoriteCars.remove(
                                                        car["name"],
                                                      );
                                                    } else {
                                                      favoriteCars.add(
                                                        car["name"]!,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Icon(
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),

                                          Text(
                                            car["details"] ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 4),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
// <<<<<<< HEAD
                                              Expanded(
                                                child: Text(
                                                  car["address"] ?? "",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                                
// =======
//                                               Text(
//                                                 car["location"] ?? "",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 12,
// // >>>>>>> 48ce218afaebcc15c3ad9fcd7d7ee1d08cf01048
//                                                 ),
//                                               ),

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
                                                  car["price"]!,
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
