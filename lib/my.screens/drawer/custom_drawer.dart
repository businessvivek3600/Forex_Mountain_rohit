import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_constants.dart';
import '../../constants/assets_constants.dart';
import '../../utils/picture_utils.dart';
import 'packages/packages.dart';

class CustomAppDrawer extends StatelessWidget {
  final String? username;
  final Function()? onLogout;
  final Function()? onMyDownline;
  final Function()? onMyTeam;
  final Function()? onTreeView;

  const CustomAppDrawer({
    super.key,
    this.username = "FX0000322",
    this.onLogout,
    this.onMyDownline,
    this.onMyTeam,
    this.onTreeView,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: Colors.blueGrey.shade900,
        width: size.width * 0.8,
        child: SafeArea(
          child: Column(
            children: [
              // 🔝 Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.amber,
                      child: Icon(Iconsax.personalcard, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            username ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.white.withOpacity(0.2), thickness: 1),

              // 📄 Drawer Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Iconsax.box5,
                      title: 'Packages',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PackagesScreen()),
                        );
                      },
                    ),

                    // 🔽 ExpansionTile for Downline
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        unselectedWidgetColor: Colors.white70,
                        textTheme: Theme.of(context).textTheme.copyWith(
                          bodyLarge: const TextStyle(color: Colors.white),
                        ),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                        collapsedIconColor: Colors.white70,
                        iconColor: Colors.white,
                        leading: const Icon(Iconsax.people, color: Colors.white),
                        title: const Text(
                          'Downline',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        childrenPadding: const EdgeInsets.only(left: 40),
                        children: [
                          _buildDrawerItem(
                            context,
                            icon: Iconsax.user,
                            title: 'My Downline',
                            onTap: onMyDownline,
                            isChild: true,
                          ),
                          _buildDrawerItem(
                            context,
                            icon: Iconsax.people,
                            title: 'My Team',
                            onTap: onMyTeam,
                            isChild: true,
                          ),
                          _buildDrawerItem(
                            context,
                            icon: Iconsax.hierarchy,
                            title: 'Generation Tree View',
                            onTap: onTreeView,
                            isChild: true,
                          ),
                        ],
                      ),
                    ),

                    // 🔚 Logout
                    _buildDrawerItem(
                      context,
                      icon: Iconsax.logout,
                      title: 'Logout',
                      onTap: onLogout,
                      iconColor: Colors.redAccent,
                      textColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),

              // ⬇ Footer
              buildFooter(size, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        Function()? onTap,
        Color iconColor = Colors.white,
        Color textColor = Colors.white,
        bool isChild = false,
      }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      leading: Icon(icon, color: iconColor, size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: isChild ? 8 : 20),
      horizontalTitleGap: 12,
    );
  }

  Widget buildFooter(Size size, BuildContext context) {
    return Container(
      height: 25 + size.height * 0.07,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: "${AppConstants.packageID}_app_dash_logo",
            placeholder: (context, url) => const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white30,
              ),
            ),
            errorWidget: (context, url, error) =>
                SizedBox(height: 60, child: assetImages(Assets.appWebLogoWhite)),
            cacheManager: CacheManager(
              Config("${AppConstants.packageID}_app_dash_logo",
                  stalePeriod: const Duration(days: 30)),
            ),
          ),
        ],
      ),
    );
  }
}
