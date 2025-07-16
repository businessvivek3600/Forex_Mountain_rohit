import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:forex_mountain/my.screens/drawer/my.downline/direct_member_screen.dart';
import 'package:forex_mountain/my.screens/drawer/my.downline/my_team_view_screen.dart';
import 'package:forex_mountain/my.screens/support/support_screen.dart';
import 'package:forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_constants.dart';
import '../../constants/assets_constants.dart';
import '../../screens/drawerPages/support_pages/support_Page.dart';
import '../../utils/picture_utils.dart';
import 'my.downline/my_generation_team_view.dart';
import 'packages/packages.dart';

class CustomAppDrawer extends StatelessWidget {
  // Add support callbacks if needed
  final Function()? onSupportChat;
  final Function()? onContactUs;

  final String? userName;
  final String? userEmail;
  final String? userImage;

  const CustomAppDrawer({
    super.key,
    this.onSupportChat,
    this.onContactUs,
    this.userName,
    this.userEmail,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: CachedNetworkImage(
                  imageUrl: "${AppConstants.packageID}_app_dash_logo",
                  placeholder: (context, url) => const SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white30),
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                      height: 60, child: assetImages(Assets.appWebLogoWhite)),
                  cacheManager: CacheManager(
                    Config("${AppConstants.packageID}_app_dash_logo",
                        stalePeriod: const Duration(days: 30)),
                  ),
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Iconsax.box5,
                            color: Colors.white, size: 24),
                        title: const Text(
                          'Packages',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        horizontalTitleGap: 12,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PackagesScreen()),
                          );
                        },
                      ),
                    ),
                    _buildExpansionTile(
                      context,
                      title: 'Downline',
                      icon: Iconsax.people,
                      submenus: [
                        {
                          'icon': Iconsax.people,
                          'title': 'My Team',
                          'onTap': () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyTeamViewScreen(),
                                ));
                          },
                        },
                        {
                          'icon': Iconsax.user,
                          'title': 'Direct Member',
                          'onTap': () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>const DirectMemberScreen(),
                                ));
                          },
                        },

                        {
                          'icon': Iconsax.hierarchy,
                          'title': 'Generation Tree View',
                          'onTap': () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>const TreeViewPage(),
                                ));
                          },
                        },
                      ],
                    ),
                    _buildExpansionTile(
                      context,
                      title: 'Support',
                      icon: Iconsax.message_question,
                      submenus: [
                        {
                          'icon': Iconsax.message,
                          'title': 'Support Chat',
                          'onTap':(){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>SupportScreen(),
                                ));
                        },
                        },
                        {
                          'icon': Iconsax.call,
                          'title': 'Contact Us',
                          'onTap': onContactUs,
                        },
                      ],
                    ),
                  ],
                ),
              ),
              TransparentContainer(
                child: SizedBox(
                  width: 220,
                  height: 40,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          (userImage?.isNotEmpty ?? false)
                              ? userImage!
                              : 'https://icon-library.com/images/user-image-icon/user-image-icon-9.jpg',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? 'User Name',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              userEmail ?? 'email@example.com',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.logout, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
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
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: EdgeInsets.symmetric(horizontal: isChild ? 8 : 20),
      horizontalTitleGap: 12,
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
    );
  }

  Widget _buildExpansionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> submenus,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        collapsedIconColor: Colors.white70,
        iconColor: const Color.fromARGB(255, 243, 200, 6),
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        children: submenus.map((submenu) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: Icon(submenu['icon'], size: 20, color: Colors.white),
              title: Text(
                submenu['title'],
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              onTap: submenu['onTap'],
            ),
          );
        }).toList(),
      ),
    );
  }
}
