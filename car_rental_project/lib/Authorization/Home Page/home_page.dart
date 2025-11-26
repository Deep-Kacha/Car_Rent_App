import 'package:car_rental_project/Authorization/Booking/Book_car.dart';
import 'package:car_rental_project/Authorization/Booking/Booked_Car.dart';
import 'package:car_rental_project/Authorization/Favorite_car/Favorite.dart';
import 'package:car_rental_project/Authorization/Menu/Menu.dart';
import 'package:car_rental_project/Authorization/Menu/Menus%20Files/ViewProfile.dart';
import 'package:flutter/material.dart';
import 'car_model.dart';
import 'car_data.dart';

class HomePage extends StatefulWidget {
  static List<Map<String, dynamic>> bookedCarsMaps = [];

  static var bookedCars;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = "All";
  String searchQuery = "";
  Set<String> favoriteCars = {};

  final List<String> categories = ["All", "Cars", "SUVs", "XUVs", "Vans"];

  void onToggleFavorite(Car car) {
    setState(() {
      if (favoriteCars.contains(car.name)) {
        favoriteCars.remove(car.name);
      } else {
        favoriteCars.add(car.name);
      }
    });
  }

  List<Car> get filteredCars {
    final carsByCategory = selectedCategory == "All"
        ? cars
        : cars.where((car) => car.category == selectedCategory).toList();

    if (searchQuery.isEmpty) return carsByCategory;

    return carsByCategory
        .where(
          (car) => car.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  Widget buildHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile + Search
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewProfilePage()),
                  );
                },
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Ethan John",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search cars near you...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
          child: const Text(
            "Categories",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  margin: const EdgeInsets.only(right: 20),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 30 : 16,
                    vertical: 8,
                  ),
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

        const SizedBox(height: 10),

        /// Cars List
        Expanded(
          child: filteredCars.isEmpty
              ? const Center(
                  child: Text(
                    "No cars available in this category",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    final car = filteredCars[index];
                    final isFavorite = favoriteCars.contains(car.name);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.asset(
                              car.image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3E2723),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Car Name + Favorite
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      car.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isFavorite) {
                                            favoriteCars.remove(car.name);
                                          } else {
                                            favoriteCars.add(car.name);
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

                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        car.address,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookingPage(
                                              car: car,
                                              onCarBooked:
                                                  (
                                                    Map<String, dynamic>
                                                    bookingDetails,
                                                  ) {},
                                            ),
                                          ),
                                        );
                                        setState(
                                          () {},
                                        ); // refresh after booking
                                      },
                                      child: Text(
                                        car.price,
                                        style: const TextStyle(
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
    );
  }

  Widget buildFavoritesPage() {
    final favoriteList = cars
        .where((car) => favoriteCars.contains(car.name))
        .toList();

    return FavoritePage(
      favoriteCars: favoriteList,
      onToggleFavorite: onToggleFavorite,
    );
  }

  Widget buildMenuPage() => MenuPage();

  Widget buildBookedPage() {
    return BookedCar(bookedCars: HomePage.bookedCarsMaps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: selectedIndex == 0
            ? buildHomePage()
            : selectedIndex == 1
            ? buildBookedPage()
            : selectedIndex == 2
            ? buildFavoritesPage()
            : buildMenuPage(),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: "Booking",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "Favorite",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
          ],
        ),
      ),
    );
  }
}
