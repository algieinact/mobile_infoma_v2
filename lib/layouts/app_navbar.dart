import 'package:flutter/material.dart';
import '../residence_list_screen.dart';
import '../activities_screen.dart';
import '../booking_list_screen.dart';
import '../screens/home_screen.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  
  const AppNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                onTap: () {
                  if (currentIndex != 0) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                },
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.home_work_outlined,
                activeIcon: Icons.home_work,
                label: 'Residence',
                onTap: () {
                  if (currentIndex != 1) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const ResidenceListScreen()),
                    );
                  }
                },
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.local_activity_outlined,
                activeIcon: Icons.local_activity,
                label: 'Activities',
                onTap: () {
                  if (currentIndex != 2) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
                    );
                  }
                },
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.book_outlined,
                activeIcon: Icons.book,
                label: 'Bookings',
                onTap: () {
                  if (currentIndex != 3) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const BookingListScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? Colors.blue : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}