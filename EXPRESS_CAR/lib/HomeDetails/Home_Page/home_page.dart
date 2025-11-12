import 'package:express_car/HomeDetails/Booking/Book_car.dart';
import 'package:express_car/HomeDetails/Booking/Booked_car.dart';
import 'package:express_car/HomeDetails/Favorite_car/Favorite.dart';
import 'package:express_car/HomeDetails/Menu/Menu.dart';
import 'package:express_car/HomeDetails/Menu/Menus_Files/ViewProfile.dart';
import 'package:express_car/HomeDetails/Home_Page/car_model.dart';
import 'package:express_car/HomeDetails/Home_Page/car_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_car/Authentication/auth_wrapper.dart';

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

  User? get currentUser => FirebaseAuth.instance.currentUser;

  void onToggleFavorite(Car car) async {
    setState(() {
      if (favoriteCars.contains(car.name)) {
        favoriteCars.remove(car.name);
      } else {
        favoriteCars.add(car.name);
      }
    });

    // 🔹 Optional: Persist to Firestore (Favorites)
    try {
      final uid = currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'favorites': favoriteCars.toList(),
        });
      }
    } catch (e) {
      print("⚠️ Failed to save favorites: $e");
    }
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

  Future<Map<String, dynamic>?> _fetchCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final firestoreData = doc.data();

      // 🔹 Merge Firestore + Auth Data
      return {
        'displayName':
            firestoreData?['displayName'] ?? user.displayName ?? 'Guest User',
        'photoURL': firestoreData?['photoURL'] ?? user.photoURL ?? '',
      };
    } catch (e) {
      print("⚠️ Error fetching user data: $e");
      return {
        'displayName': user.displayName ?? 'Guest User',
        'photoURL': user.photoURL ?? '',
      };
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate back to AuthWrapper
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
        (route) => false,
      );
    }
  }

  Widget buildHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _fetchCurrentUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final name = snapshot.data?['displayName'] ?? 'Guest User';
              final photoURL = snapshot.data?['photoURL'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ViewProfilePage()),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              (photoURL == null || photoURL.isEmpty)
                              ? const AssetImage("assets/images/profile.jpg")
                                    as ImageProvider
                              : NetworkImage(photoURL),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'logout') {
                              await _logout(context);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'logout',
                              child: Text('Logout'),
                            ),
                          ],
                          icon: const Icon(
                            Icons.more_vert,
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
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ],
              );
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
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
                onTap: () => setState(() => selectedCategory = category),
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
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onToggleFavorite(car),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        car.address,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
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
                                            builder: (_) => BookingPage(
                                              car: car,
                                              onCarBooked: (details) {},
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

  Widget buildBookedPage() => BookedCar(bookedCars: HomePage.bookedCarsMaps);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: [
          buildHomePage(),
          buildBookedPage(),
          buildFavoritesPage(),
          buildMenuPage(),
        ][selectedIndex],
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
          onTap: (index) => setState(() => selectedIndex = index),
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
