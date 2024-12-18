import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Content inside BottomAppBar
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Colors.green, width: 3), // Green border only on top
              ),
            ),
            child: BottomAppBar(
              notchMargin: 10.0,
              color: Colors.black, // Allow custom paint to show
              clipBehavior: Clip.antiAlias,
              shape: const CircularNotchedRectangle(),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: Text(
                        "Trip",
                        style: TextStyle(
                          color: Color(0xFFFCB535),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: Icons.home,
                          label: "Home",
                          index: 0,
                          isSelected: selectedIndex == 0,
                          onTap: onItemTapped,
                        ),
                        _buildNavItem(
                          icon: Icons.wallet,
                          label: "Wallet",
                          index: 1,
                          isSelected: selectedIndex == 1,
                          onTap: onItemTapped,
                        ),
                        const SizedBox(width: 30), // Space for the floating button
                        _buildNavItem(
                          icon: Icons.history,
                          label: "History",
                          index: 2,
                          isSelected: selectedIndex == 2,
                          onTap: onItemTapped,
                        ),
                        _buildNavItem(
                          icon: Icons.person,
                          label: "Profile",
                          index: 3,
                          isSelected: selectedIndex == 3,
                          onTap: onItemTapped,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        )],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required ValueChanged<int> onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.green,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.green,
              fontSize: 12,
            ),
          ),

        ],
      ),
    );
  }
}

