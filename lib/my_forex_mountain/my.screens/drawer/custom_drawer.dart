import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/assets_constants.dart';
import '../../../sl_container.dart';
import '../../../utils/picture_utils.dart';
import '../../my.provider/my_auth_provider.dart';
import '../../my.provider/my_dashboard_provider.dart';
import '../../widgets/glass_card.dart';
import '../my.auth/my_login_screen.dart';
import '../support/support_screen.dart';
import 'my.downline/direct_member_screen.dart';
import 'my.downline/my_generation_team-view.dart';
import 'my.downline/my_team_view_screen.dart';
import 'packages/packages.dart';

class CustomAppDrawer extends StatelessWidget {
  final Function()? onSupportChat;
  final Function()? onContactUs;


  const CustomAppDrawer({
    super.key,
    this.onSupportChat,
    this.onContactUs,

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
                    height: 60,
                    child: assetImages(Assets.appWebLogoWhite),
                  ),
                  cacheManager: CacheManager(
                    Config("${AppConstants.packageID}_app_dash_logo",
                        stalePeriod: const Duration(days: 30)),
                  ),
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1),

              /// Main content
              Expanded(
                child: Column(
                  children: [
                    /// Drawer menu list
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
                                  MaterialPageRoute(
                                      builder: (_) => PackagesScreen()),
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
                                        builder: (context) =>
                                        const MyTeamViewScreen()),
                                  );
                                },
                              },
                              {
                                'icon': Iconsax.user,
                                'title': 'Direct Member',
                                'onTap': () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const DirectMemberScreen()),
                                  );
                                },
                              },
                              {
                                'icon': Iconsax.hierarchy,
                                'title': 'Generation Tree View',
                                'onTap': () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const MyGenerationTeamView()),
                                  );
                                },
                              },
                            ],
                          ),
                         Padding(
                           padding: const EdgeInsets.all(4.0),
                           child: ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                leading: const Icon(Iconsax.message_question,
                                    color: Colors.white, size: 24),
                                title: const Text(
                                  'Support',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                horizontalTitleGap: 12,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const MySupportScreen()),
                                  );
                                },
                              ),
                         ),
                      ]
                      ),
                    ),

                    /// User Info Footer
                    TransparentContainer(
                      child: SizedBox(
                        width: 220,
                        height: 40,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage('https://icon-library.com/images/user-image-icon/user-image-icon-9.jpg',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Consumer<MyDashboardProvider>(
                                builder: (context, provider, child) {
                                final customer =   provider.dashboardData?.customer;
                                return Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                       '${customer!.firstName} ${customer.lastName}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        customer.customerEmail ?? "",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            ),
                            GestureDetector(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: GlassCard(
                                        borderRadius: 20,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Confirm Logout",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            const Text(
                                              "Are you sure you want to logout?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () => Navigator.pop(ctx, false),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.white12,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () => Navigator.pop(ctx, true),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Logout",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await sl.get<NewAuthProvider>().logout();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => MyLoginScreen()),
                                        (Route<dynamic> route) => false,
                                  );
                                }
                              },
                              child: const Icon(Icons.logout, color: Colors.white70),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
