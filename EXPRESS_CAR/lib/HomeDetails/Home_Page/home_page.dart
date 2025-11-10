import 'package:express_car/HomeDetails/Booking/Book_car.dart';
import 'package:express_car/HomeDetails/Booking/Booked_car.dart';
import 'package:express_car/HomeDetails/Favorite_car/Favorite.dart';
import 'package:express_car/HomeDetails/Menu/Menu.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ViewProfile.dart';
import 'package:flutter/material.dart';
import 'car_model.dart';
import 'car_data.dart';

class HomePage extends StatefulWidget {
  static List<Map<String, dynamic>> bookedCarsMaps = [];

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
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Use screen-relative padding
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: 16,
          ),
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
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.06, // Responsive radius
                      backgroundImage: const AssetImage(
                        "assets/images/profile.jpg",
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04), // Responsive spacing
                    const Text(
                      "Ethan John",
                      style: TextStyle(
                        fontSize: 24, // Slightly adjusted for better scaling
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search cars near you...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: const OutlineInputBorder(
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

        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: const Text(
            "Categories",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        // Use a Wrap widget for categories to handle different screen widths
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Wrap(
            spacing: 12.0, // Horizontal space between chips
            runSpacing: 8.0, // Vertical space between lines
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  }
                },
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.orange,
                shape: StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        /// Cars List
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use GridView for wider screens (e.g., tablets or landscape)
              bool useGridView = constraints.maxWidth > 600;

              if (filteredCars.isEmpty) {
                return const Center(
                  child: Text(
                    "No cars available in this category",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
                            height: screenHeight * 0.22, // Responsive height
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
                                      onToggleFavorite(car);
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
                                        borderRadius: BorderRadius.circular(8),
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
                                      setState(() {});
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: useGridView
                      ? 2
                      : 1, // 2 columns for grid, 1 for list
                  childAspectRatio: useGridView
                      ? 1.1
                      : 1.3, // Adjust aspect ratio
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
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
