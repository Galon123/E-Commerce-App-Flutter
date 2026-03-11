import 'package:e_commerce_app/assets/constants.dart';
import 'package:e_commerce_app/providers/user_provider.dart';
import 'package:e_commerce_app/screens/main/my_listings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.largeSize)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Section (Avatar & Name)
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo.shade100,
                  child: const Icon(Icons.person, size: 70, color: Colors.indigo),
                ),
            ),
            const SizedBox(height: 15),
            Text(
              userProvider.username,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Verified Student",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 30),

            const Divider(height: 50,),

            // 2. Action Menu
            _buildSectionHeader("Activity"),
            _buildMenuItem(
              icon: Icons.gavel_rounded,
              title: "My Bids",
              subtitle: "Check the status of your offers",
              onTap: () => Navigator.pushReplacementNamed(context, '/my_bids'),
            ),
            _buildMenuItem(
              icon: Icons.inventory_2_outlined,
              title: "My Listings",
              subtitle: "Manage the items you're selling",
              onTap: () => Navigator.pushReplacementNamed(context, '/my_listings'),
            ),

            const SizedBox(height: 20),
            _buildSectionHeader("Account Settings"),
            _buildMenuItem(
              icon: Icons.notifications_none_rounded,
              title: "Notifications",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.security_outlined,
              title: "Privacy & Security",
              onTap: () {},
            ),

            const SizedBox(height: 30),

            // 3. Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context, userProvider),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Logout", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.indigo.shade700, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textColour),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.cardColour)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.cardColour)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cardColour),
        onTap: onTap,
      ),
    );
  }

  void _confirmLogout(BuildContext context, UserProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to leave?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await provider.logout();
              Navigator.pop(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}