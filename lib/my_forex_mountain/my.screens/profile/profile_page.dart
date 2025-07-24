import 'package:flutter/material.dart';
import 'package:forex_mountain/constants/assets_constants.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../my.provider/my_dashboard_provider.dart';
import 'change_password.dart';
import 'edit _profile_page.dart';
import 'payment_details.dart';
import 'profile_page.dart';
import 'verify_KYC.dart';
import 'package:forex_mountain/utils/color.dart';
import 'package:forex_mountain/utils/picture_utils.dart';
import 'package:forex_mountain/utils/text.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<MyDashboardProvider>(context);
    final customer = dashboardProvider.dashboardData?.customer!;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Iconsax.element_4, color: Colors.amber),
            onPressed: () {},
          ),
          title: bodyLargeText('PROFILE', context, fontSize: 20),
          backgroundColor: Colors.black,
        ),
        body: dashboardProvider.isLoading
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.white30,
                  highlightColor: Colors.white54,
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildShimmerCard(),
              const SizedBox(height: 20),
              _buildShimmerCard(),
            ],
          ),
        )
            : ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.withOpacity(0.3),
                      Colors.deepOrange.withOpacity(0.1)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: Image.asset(
                      "assets/images/appLogo_s.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      "${customer!.firstName} ${customer.lastName}",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage(customer: customer)),
                      ).then((result) {
                        if (result == true) {
                          // ⬇️ Refresh dashboard data after profile update
                          Provider.of<MyDashboardProvider>(context, listen: false).getDashboardData();
                        }
                      });
                    },
                    child: const Icon(Iconsax.edit, color: Colors.amber, size: 18),
                  ),
                ],
              ),
            ),

            Center(
              child: Text(
               customer.customerEmail ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// Profile Details Card with stacked Edit Icon
            Stack(
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  blurSigma: 15,
                  child: Column(
                    children: [
                      _infoRow(Iconsax.call, "Mobile", customer.customerMobile),
                      _infoRow(Iconsax.calendar, "Date of Birth", customer.dateOfBirth),
                      _infoRow(Iconsax.location, "City", customer.city),
                      _infoRow(Iconsax.home, "House No.",customer.customerShortAddress ?? ""),
                      _infoRow(
                          Iconsax.building, "Address 1", customer.customerAddress1),
                      _infoRow(Iconsax.location_tick, "Address 2",
                          customer.customerAddress2),
                      _infoRow(Iconsax.location_tick, "State", customer.customerAddress2),
                      _infoRow(Iconsax.code, "Zip Code", customer.zip ?? ""),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => EditProfilePage(customer: customer)),
    ).then((result) {
    if (result == true) {
    // ⬇️ Refresh dashboard data after profile update
    Provider.of<MyDashboardProvider>(context, listen: false).getDashboardData();
    }
    });
    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.amber,
                      child: Icon(Iconsax.edit, size: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            _buildGlassTile(context, Iconsax.password_check, "Change Password",
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePassword()));
            }),
            _buildGlassTile(context, Iconsax.message, "Payment Details", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentDetailsPage()));
            }),
            _buildGlassTile(context, Iconsax.verify, "Verify KYC", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VerifyKyc()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTile(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        borderRadius: 18,
        blurSigma: 12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              Icon(icon, color: Colors.amber),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const Icon(Iconsax.arrow_right_3, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildShimmerCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      blurSigma: 15,
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white30,
                    highlightColor: Colors.white54,
                    child: Container(
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white30,
                    highlightColor: Colors.white54,
                    child: Container(
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

}
