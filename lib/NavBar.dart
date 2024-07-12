import 'package:flutter/material.dart';
import 'package:to_do/pages/list_task.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("Ali Batuhan Özsürmeli"),
              accountEmail: Text("info@batuhanozsurmeli.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network("https://yt3.ggpht.com/yti/ANjgQV-Ag9Kjab9g3jIW4twVIWCTaqjoeLkD4KLbG6k87GALVivI=s108-c-k-c0x00ffffff-no-rj",
                width: 90,
                height: 90,
                fit: BoxFit.cover,),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/hmb_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.select_all, color: Color(0xff13678A)),
            title: Text("Show all"),
            onTap: () {
              setState(() {

              });
            },
          ),
          ListTile(
            leading: Icon(Icons.sort, color: Color(0xff13678A)),
            title: Text("Sort by priority"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.date_range, color: Color(0xff13678A)),
            title: Text("Sort by date"),
            onTap: () {},
          ),
          //Divider(),
        ],
      ),
    );
  }
}
