import 'package:canteen_management_user/mainScreens/edit_profile.dart';
import 'package:canteen_management_user/mainScreens/history_screen.dart';
import 'package:canteen_management_user/mainScreens/home_screen.dart';
import 'package:canteen_management_user/mainScreens/my_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:canteen_management_user/authentication/auth_screen.dart';
import 'package:canteen_management_user/global/global.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //header drawer
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "TrainOne"),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          //body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    "My Orders",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>MyOrdersScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>EditProfilePage()));
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>HistoryScreen()));
                  },
                ),

                // // ListTile(
                // //   leading: const Icon(
                // //     Icons.search,
                // //     color: Colors.black,
                // //   ),
                // //   title: const Text(
                // //     "Search",
                // //     style: TextStyle(color: Colors.black),
                // //   ),
                // //   onTap: () {},
                // // ),
                // const Divider(
                //   height: 10,
                //   color: Colors.grey,
                //   thickness: 2,
                // ),
                // // ListTile(
                // //   leading: const Icon(
                // //     Icons.add_location,
                // //     color: Colors.black,
                // //   ),
                // //   title: const Text(
                // //     "Add New Address",
                // //     style: TextStyle(color: Colors.black),
                // //   ),
                // //   onTap: () {},
                // // ),
                // const Divider(
                //   height: 10,
                //   color: Colors.grey,
                //   thickness: 2,
                // ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const AuthScreen()));
                    });
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
