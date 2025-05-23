import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final int cartItemCount; // New parameter for cart item count

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.cartItemCount = 0, // Default to 0 if not provided
  });

  void _navigateToPage(BuildContext context, int index) {
    // Remove current routes and add new route
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      _getRouteForIndex(index),
      (route) => false,
    );
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/messages';
      case 2:
        return '/promotions';
      case 3:
        return '/cart';
      case 4:
        return '/profile';
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(191, 155, 67, 1),
            Color.fromRGBO(217, 182, 106, 1),
            Color.fromRGBO(191, 155, 67, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              // Call the onTap callback if provided
              if (onTap != null) {
                onTap!(index);
              }

              // Navigate to the appropriate screen
              _navigateToPage(context, index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.7),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            elevation: 0,
            items: [
              _buildBottomNavigationBarItem(
                  Icons.home_outlined, Icons.home, 'Home', currentIndex == 0),
              _buildBottomNavigationBarItem(Icons.chat_bubble_outline,
                  Icons.chat_bubble, 'Messages', currentIndex == 1),
              _buildBottomNavigationBarItem(Icons.percent_outlined,
                  Icons.percent, 'Promotions', currentIndex == 2),
              _buildCartNavigationBarItem(
                  currentIndex == 3, cartItemCount),
              _buildBottomNavigationBarItem(Icons.person_outline, Icons.person,
                  'Profile', currentIndex == 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, IconData activeIcon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Transform.scale(
        scale: isSelected ? 1.3 : 1.0,
        child: Icon(isSelected ? activeIcon : icon),
      ),
      label: label,
    );
  }
  
  // New method specifically for the cart item with badge
  BottomNavigationBarItem _buildCartNavigationBarItem(bool isSelected, int itemCount) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.scale(
            scale: isSelected ? 1.3 : 1.0,
            child: Icon(isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined),
          ),
          if (itemCount > 0)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      label: 'Cart',
    );
  }
}