import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:forex_mountain/database/model/response/voucher_package_model.dart';
import 'package:forex_mountain/utils/default_logger.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/app_constants.dart';
import '../../../widgets/load_more_container.dart';
import '/constants/assets_constants.dart';
import '/database/functions.dart';
import '/database/model/response/voucher_model.dart';
import '/providers/auth_provider.dart';
import '/providers/voucher_provider.dart';
import '/sl_container.dart';
import '/utils/color.dart';
import '/utils/picture_utils.dart';
import '/utils/sizedbox_utils.dart';
import '/utils/skeleton.dart';
import '/utils/text.dart';
import 'package:provider/provider.dart';

import '../../dashboard/main_page.dart';

class GiftVoucherPage extends StatefulWidget {
  const GiftVoucherPage({Key? key}) : super(key: key);

  @override
  State<GiftVoucherPage> createState() => _GiftVoucherPageState();
}

class _GiftVoucherPageState extends State<GiftVoucherPage>
    with TickerProviderStateMixin {
  var provider = sl.get<VoucherProvider>();
  @override
  void initState() {
    provider.tabController = TabController(length: 2, vsync: this);
    provider.getVoucherList(true).then((value) {
      if (provider.packages.isNotEmpty) {
        provider.setCurrentIndex(0);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    provider.currentIndex = 0;
    provider.totalVouchers = 0;
    provider.voucherPage = 0;
    provider.currentPackage = null;
    provider.packages.clear();
    provider.paymentTypes.clear();
    provider.history.clear();
    provider.tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    await provider.getVoucherList(false);
  }

  Future<void> _refresh() async {
    provider.voucherPage = 0;
    await provider.getVoucherList(false);
    provider.tabController.animateTo(0);
    if (provider.packages.isNotEmpty) {
      provider.carouselController!.animateToPage(0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double sectionHeight = 200;
    return Consumer<VoucherProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
              title: titleLargeText('Vouchers', context, useGradient: true),
              shadowColor: Colors.white),
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: userAppBgImageProvider(context),
                  fit: BoxFit.cover,
                  opacity: 1),
            ),
            child: !provider.loadingVoucher
                ? Column(
                    children: [
                      _buildUpperSection(sectionHeight, provider, context),
                      Expanded(
                        child: LoadMoreContainer(
                            finishWhen: provider.history.length >=
                                provider.totalVouchers,
                            onLoadMore: _loadMore,
                            onRefresh: _refresh,
                            builder: (scrollController, status) {
                              return ListView(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  ...provider.history.map((e) => Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 8.0),
                                      child: buildVoucher(e, context))),
                                  if (provider.history.isEmpty)
                                    const Divider(color: Colors.white54),
                                  if (provider.history.isEmpty)
                                    buildEmptyHistory(context),
                                ],
                              );
                            }),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white)),
          ),
          // bottomNavigationBar: buildBottomButton(context),
        );
      },
    );
  }

  Column _buildUpperSection(
      double sectionHeight, VoucherProvider provider, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _TabBarWidget(
                sectionHeight: sectionHeight,
                packages: provider.packages,
                tabController: provider.tabController,
                provider: provider),
            Expanded(
              child: SizedBox(
                height: !provider.loadingVoucher && provider.packages.isEmpty
                    ? sectionHeight
                    : sectionHeight,
                width: double.maxFinite,
                child: (provider.loadingVoucher || provider.packages.isNotEmpty)
                    ? Column(
                        children: [
                          height20(),
                          Expanded(child: VoucherCarousel()),
                        ],
                      )
                    : buildNoVouchers(context),
              ),
            ),
          ],
        ),
        buildVoucherDetailsCard(provider, context),
        height10(),
      ],
    );
  }

  Column buildEmptyHistory(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: Get.height * 0.2, child: assetLottie(Assets.emptyCards)),
        bodyLargeText("You don't have any voucher yet.", context,
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget buildVoucherDetailsCard(
      VoucherProvider provider, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              // border: Border.all(),
              borderRadius: BorderRadius.circular(5),
              // color: Colors.white,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 5,
              //     spreadRadius: 1,
              //   )
              // ],
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                UiCategoryTitleContainer(
                    child: bodyLargeText('My Vouchers', context,
                        color: Colors.white)),
                width10(),
                bodyLargeText('(', context, color: Colors.white),
                bodyLargeText(
                    '${provider.history.where((element) => element.usedBy == null).length}',
                    context,
                    color: Colors.orange),
                bodyLargeText(')', context, color: Colors.white),
              ],
            ),
          ),
          width10(),
          GestureDetector(
            onTap: () => checkServiceEnableORDisable(
                'mobile_is_voucher', () => buildShowModalBottomSheet(context)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ]),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.add,
                  //   size: 18,
                  //   weight: 20,
                  //   color: appLogoColor,
                  // ),
                  // width5(),
                  bodyMedText('Get It Now', context,
                      color: appLogoColor, fontWeight: FontWeight.bold),
                ],
              ),
              // style: ElevatedButton.styleFrom(
              //     elevation: 10,
              //     shadowColor: Colors.black54,
              //     backgroundColor: purpleDark,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(50))),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoucher(VoucherModel e, BuildContext context) {
    String currency_icon = sl.get<AuthProvider>().userData.currency_icon ?? '';

    bool used = e.usedBy != null && e.usedBy!.isNotEmpty;
    Color textColor = !used ? Colors.black : Colors.black54;

    Color primaryColor1 =
        used ? const Color(0xfff1e3d3) : const Color(0xffcbf3f0);

    String packageType = e.packageType == '1' ? 'Joining' : 'Renewal';
    String subType = e.packageId == '1'
        ? 'Monthly'
        : e.packageId == '2'
            ? 'Gold'
            : e.packageId == '3'
                ? 'Platinum'
                : '';
    String date = '                                ';

    if (e.createdAt != null && e.createdAt != '') {
      try {
        date =
            '${DateFormat().add_yMMMd().format(DateTime.parse(e.createdAt ?? ""))}\n${DateFormat().add_jm().format(DateTime.parse(e.createdAt ?? ""))}';
      } catch (e) {
        date = 'Unknown';
      }
    }
    String amount =
        (double.tryParse(e.packageAmt ?? '0') ?? 0).toStringAsFixed(2);
    // Color color1 = !used ? const Color(0xffd88c9a) : const Color(0xff368f8b);
    //color for monthly, gold and platinum
    Color monthlyColor = const Color(0xFFCC97D1);
    Color goldColor = const Color(0xFFF9CE83);
    Color platinumColor = const Color(0xFFE7C8C8);

    Color color1 = e.packageId == '1'
        ? monthlyColor
        : e.packageId == '2'
            ? goldColor
           : e.packageId == '3'
                ? platinumColor
                : Colors.grey.shade600;
    Color color2 = e.packageId == '1'
        ? const Color(0xFFD8CFF4)
        : e.packageId == '2'
            ? const Color.fromARGB(255, 230, 214, 188)
            : e.packageId == '3'
                ? const Color(0xFFC2C3C3)
                : Colors.white38;
    Color color3 = e.packageId == '1'
        ? const Color(0xFF96C5FF)
        : e.packageId == '2'
            ? const Color(0xFFFA8B8F)
            : e.packageId == '3'
                ? const Color(0xFF59F3CF)
                : Colors.blueGrey.shade200;
    Color usedColor = used
        ? const Color.fromARGB(255, 236, 232, 232)
        : const Color(0xff368f8b);

    return ClipPath(
      clipper: TicketPassClipper(
        holeRadius: 30,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        height: 150,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
                end: 10,
                top: 10,
                bottom: 10,
              ),
              width: 70,
              decoration: BoxDecoration(color: color1),
              child: RotatedBox(
                quarterTurns: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        bodyLargeText(e.packageName ?? '', context,
                            useGradient: false),
                        capText('($packageType)', context, useGradient: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //right part
            Expanded(
                child: Container(
              padding: const EdgeInsetsDirectional.only(
                start: 10,
                end: 20,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color2.darken(30), color3],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(amount,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          height10(),
                          AutoSizeText(e.epin ?? '',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                  width10(),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 15,
                                    color: Colors.pink,
                                  ),
                                  width5(),
                                  Column(
                                    children: [
                                      AutoSizeText(date,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // spacer
                          const Spacer(),
                          //used by
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const AutoSizeText('Used By : ',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              width10(),
                              Expanded(
                                child: AutoSizeText(e.usedBy ?? '',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          // spacer
                          const Spacer(),
                          // share icon button , copy icon button and redeam text button with icon color white, all in a row
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: used
                                      ? null
                                      : () async {
                                          String promoMessage = """
      🚀 Exciting News! 🚀
      
      Discover [Your App Name], the ultimate app for [Describe Your App's Purpose]! 📱
      
      🎉 Get started today and experience the future of [Your App's Functionality]. 🎁
      
      🌟 Key Features:
      ✅ [Feature 1]: [Highlight its benefits]
      ✅ [Feature 2]: [Highlight its benefits]
      ✅ [Feature 3]: [Highlight its benefits]
      
      🤝 Join us today and use my referral code: [${sl.get<AuthProvider>().userData.username ?? ''}] for amazing rewards!
      
      💰 Don't forget to redeem your exclusive voucher code: [${e.epin ?? ''}] for fantastic discounts! Hurry, it won't last long! ⏳
      
      📲 Download the app now to unlock a world of possibilities:
      👉 [${AppConstants().getDownloadUrlForIos()}] (iOS)
      👉 [${AppConstants().getDownloadUrlForAndroid()}] (Android)
      
      Spread the word and let's [Your App's Mission] together! 🙌
      #AwesomeApp #ReferralRewards #SaveBig
      """;
                                          final ByteData bytes =
                                              await rootBundle.load(
                                                  'assets/images/${Assets.appWebLogo}');
                                          final Uint8List list =
                                              bytes.buffer.asUint8List();
                                          print('image path: $list');
// _onShare method:
                                          final box = context.findRenderObject()
                                              as RenderBox?;
                                          Share.share(
                                            promoMessage,
                                            subject:
                                                'Check out this awesome app!',
                                            sharePositionOrigin: box!
                                                    .localToGlobal(
                                                        Offset.zero) &
                                                box.size,
                                          );
                                        },
                                  child: Icon(Icons.share_rounded,
                                      color: used
                                          ? Colors.transparent
                                          : Colors.white)),
                              width10(),
                              GestureDetector(
                                  onTap: () => Clipboard.setData(
                                          ClipboardData(text: e.epin ?? ''))
                                      .then((value) => Fluttertoast.showToast(
                                          msg: 'Voucher code copied!')),
                                  child: const Icon(Icons.copy_rounded,
                                      color: Colors.white)),
                              width10(),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    onPressed: !used
                                        ? () {
                                            Clipboard.setData(ClipboardData(
                                                    text: e.epin ?? ''))
                                                .then((value) =>
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Voucher code copied!'));
                                          }
                                        : null,
                                    child: AutoSizeText(
                                        !used ? "REDEEM" : 'REDEEMED',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: usedColor,
                                            // fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                // width10(),
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ))
          ],
        ),
      ),
    );

  }

  Padding buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () => buildShowModalBottomSheet(context),
                  child: bodyMedText('Create New Voucher', context,
                      textAlign: TextAlign.center),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.white24,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (context) => const CreateVoucherDialogWidget());
  }

  Column buildNoVouchers(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Expanded(child: assetSvg(Assets.gift, color: Colors.white)),
        Expanded(
          child: Center(
            child: titleLargeText('No Active Vouchers', context),
          ),
        ),
      ],
    );
  }
}

class _TabBarWidget extends StatefulWidget {
  const _TabBarWidget({
    required this.sectionHeight,
    required this.provider,
    required this.packages,
    required this.tabController,
  });

  final double sectionHeight;
  final VoucherProvider provider;
  final List<VoucherPackageModel> packages;
  final TabController tabController;

  @override
  State<_TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<_TabBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = widget.provider.currentIndex;
    int totalVouchers = widget.packages.length;
    int totalRenewal =
        widget.packages.where((element) => element.saleType == '2').length;
    int totalJoining =
        widget.packages.where((element) => element.saleType == '1').length;
    return Container(
      width: 50,
      height: widget.sectionHeight,
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.circular(5),
        // color: Colors.redAccent,
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.black12,
          //   blurRadius: 5,
          //   spreadRadius: 1,
          // )
        ],
      ),
      child: RotatedBox(
        quarterTurns: 3,
        child: Container(
          // color: redDark,
          width: 200,
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            controller: widget.tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: textGradiantColors
                      .map((e) => e.withOpacity(0.7))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white),
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            onTap: (index) {
              widget.provider.setCurrentIndex(index);
              widget.provider.carouselController!.animateToPage(
                  index == 0 ? 0 : totalJoining + 1,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn);
            },
            tabs: [
              Tab(
                child: Text(
                  'Joining ($totalJoining)',
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text(
                  'Renewal ($totalRenewal)',
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherCarousel extends StatelessWidget {
  VoucherCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VoucherProvider>(
      builder: (context, provider, child) {
        return CarouselSlider(
            carouselController: provider.carouselController,
            items: <Widget>[
              if (!provider.loadingVoucher)
                ...provider.packages.map((package) => GestureDetector(
                    onTap: () {
                      // provider.buyEventTicketsRequest(e.id ?? '');
                      // Get.to(BuyEventTicket(event: e));
                    },
                    child: ClipRRect(
                        // width: 300,
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(children: [
                          CachedNetworkImage(
                            imageUrl: package.giftImg ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SizedBox(
                                height: 150,
                                width: 100,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: appLogoColor.withOpacity(0.5)))),
                            errorWidget: (context, url, error) => SizedBox(
                              height: 250,
                              width: 150,
                              child:
                                  assetImages(Assets.noImage, fit: BoxFit.fill),
                            ),
                            cacheManager: CacheManager(Config(
                                "${AppConstants.packageID}_${package.giftImg ?? 'package.giftImg${package.name ?? ''}'}",
                                stalePeriod: const Duration(days: 7))),
                          ),
                        ])))),
              if (provider.loadingVoucher)
                ...[1, 2, 3, 4, 5, 6].map((e) => Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Skeleton(
                        width: 150,
                        textColor: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10))))
            ],
            options: CarouselOptions(
                height: 180,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                // enlargeFactor: 0.3,
                // onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
                onPageChanged: (page, reason) {
                  provider.setCurrentIndex(page);
                  if (provider.currentPackage != null) {
                    if (provider.currentPackage!.saleType == '1') {
                      provider.tabController.animateTo(0);
                    } else {
                      provider.tabController.animateTo(1);
                    }
                  }
                },
                onScrolled: (page) {
                  // print(page);
                }));
      },
    );
  }
}

class CreateVoucherDialogWidget extends StatefulWidget {
  const CreateVoucherDialogWidget({Key? key}) : super(key: key);

  @override
  State<CreateVoucherDialogWidget> createState() =>
      _CreateVoucherDialogWidgetState();
}

class _CreateVoucherDialogWidgetState extends State<CreateVoucherDialogWidget> {
  TextEditingController countController = TextEditingController(text: '1');

  int quantity = 1;
  String? paymentMode;
  String? cryptoType;
  decrement() => setState(() => quantity--);
  increment() => setState(() => quantity++);
  @override
  Widget build(BuildContext context) {
    return Consumer<VoucherProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
              color: mainColor,
              image: DecorationImage(
                  image: userAppBgImageProvider(context),
                  fit: BoxFit.cover,
                  opacity: 1),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.only(top: kToolbarHeight * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              height5(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 3,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2)))
                ],
              ),
              height20(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SizedBox(
                      height: 150,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (provider.currentPackage != null)
                              CachedNetworkImage(
                                imageUrl:
                                    provider.currentPackage!.giftImg ?? '',
                                placeholder: (context, url) => SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            color: appLogoColor
                                                .withOpacity(0.5)))),
                                errorWidget: (context, url, error) =>
                                    assetImages(Assets.noImage),
                                cacheManager: CacheManager(Config(
                                  "${AppConstants.packageID}_$e",
                                  stalePeriod: const Duration(days: 7),
                                  //one week cache period
                                )),
                              ),
                          ]),
                    ),
                    height20(),

                    height10(),

                    //payment mode
                    titleLargeText('Payment Methods', context,
                        color: Colors.white, fontWeight: FontWeight.w500),
                    height5(),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...provider.paymentTypes.entries.map(
                          (type) => ChoiceChip(
                            pressElevation: 5.0,
                            selectedColor: appLogoColor,
                            backgroundColor: Colors.grey[100],
                            label: Text(
                              type.value is String ? type.value : type.key,
                              style: TextStyle(
                                  color: paymentMode == type.key
                                      ? Colors.white
                                      : null),
                            ),
                            selected: paymentMode == type.key,
                            onSelected: (bool selected) {
                              setState(() {
                                paymentMode = selected ? type.key : null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    height10(),
                    //crypto type
                    if (paymentMode == 'Crypto')
                      Builder(builder: (context) {
                        var cryptoTypes = provider.paymentTypes.entries
                            .firstWhere((element) => element.key == 'Crypto')
                            .value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              titleLargeText('Crypto Type', context,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              height5(),
                              Wrap(
                                spacing: 10,
                                children: [
                                  ...cryptoTypes.entries.map(
                                    (type) => ChoiceChip(
                                      pressElevation: 5.0,
                                      selectedColor: greenLight,
                                      backgroundColor: Colors.grey[100],
                                      label: Text(
                                        type.value,
                                        style: TextStyle(
                                            color: cryptoType == type.key
                                                ? Colors.white
                                                : null),
                                      ),
                                      selected: cryptoType == type.key,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          cryptoType =
                                              selected ? type.key : null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),

                    //coupon code
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: provider.voucherCodeController,
                                readOnly: provider.couponVerified != null,
                                cursorColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Enter MCC Coupon Code',
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(5)),
                                    suffixIcon:
                                        buildCouponFieldSuffix(provider)),
                              ),
                            ),
                          ],
                        ),
                        height10(5),
                        if (provider.couponVerified != null)
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(
                                text: 'Coupon Applied: ',
                                style: TextStyle(color: Colors.green)),
                            TextSpan(
                                text: provider.voucherCodeController.text,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ])),
                        height10(16),
                      ],
                    ),

                    //discount note
                    if (provider.discount_note != null)
                      Column(
                        children: [
                          capText(
                            provider.discount_note!,
                            context,
                            useGradient: true,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                          height10(16),
                        ],
                      ),

                    // bodyLargeText('Package Type', context,
                    //     color: Colors.black, fontWeight: FontWeight.w500),
                    // height5(),
                    // Row(
                    //   children: [
                    //     Expanded(child: FormField<String>(
                    //       builder: (FormFieldState<String> state) {
                    //         return InputDecorator(
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(5.0),
                    //                 borderSide:
                    //                     BorderSide(color: Colors.black)),
                    //             enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(5.0),
                    //                 borderSide:
                    //                     BorderSide(color: Colors.black)),
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(5.0),
                    //                 borderSide:
                    //                     BorderSide(color: Colors.black)),
                    //             disabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(5.0),
                    //                 borderSide:
                    //                     BorderSide(color: Colors.black)),
                    //           ),
                    //           isEmpty: selectedType == '',
                    //           child: DropdownButtonHideUnderline(
                    //             child: provider.packageTypes.entries.isNotEmpty
                    //                 ? DropdownButton<String>(
                    //                     value: selectedType == ''
                    //                         ? provider
                    //                             .packageTypes.entries.first.key
                    //                         : selectedType,
                    //                     isDense: true,
                    //                     hint: Text('Select type'),
                    //                     alignment:
                    //                         AlignmentDirectional.bottomCenter,
                    //                     onChanged: (String? newValue) {
                    //                       setState(() {
                    //                         selectedType = newValue!;
                    //                         state.didChange(newValue);
                    //                       });
                    //                     },
                    //                     items: <DropdownMenuItem<String>>[
                    //                       ...provider.packageTypes.entries
                    //                           .toList()
                    //                           .map<DropdownMenuItem<String>>(
                    //                               (type) {
                    //                         return DropdownMenuItem<String>(
                    //                           value: type.key,
                    //                           child: Text(
                    //                             type.value,
                    //                             style: TextStyle(
                    //                                 color: Colors.black),
                    //                           ),
                    //                           onTap: () {
                    //                             setState(() {
                    //                               selectedType = type.key;
                    //                             });
                    //                           },
                    //                         );
                    //                       }).toList(),
                    //                     ],
                    //                     borderRadius: BorderRadius.circular(15),
                    //                     iconEnabledColor: Colors.black,
                    //                     style: TextStyle(color: Colors.black),
                    //                     menuMaxHeight: double.maxFinite,
                    //                     dropdownColor: Colors.white,
                    //                     focusColor: Colors.transparent,
                    //                     elevation: 10,
                    //                   )
                    //                 : Container(),
                    //           ),
                    //         );
                    //       },
                    //     )),
                    //   ],
                    // ),
                    // height5(),
                    // bodyLargeText('Joining Package', context,
                    //     color: Colors.black, fontWeight: FontWeight.w500),
                    // height5(),
                    // Row(
                    //   children: [
                    //     Expanded(child: Builder(builder: (context) {
                    //       print(' selected type = $selectedType');
                    //       print(' selected package = $selectedPackage');
                    //       List<VoucherPackageTypeModel> packages =
                    //           selectedType == '1'
                    //               ? provider.package1
                    //               : selectedType == '2'
                    //                   ? provider.package2
                    //                   : [];
                    //       return FormField<String>(
                    //         builder: (FormFieldState<String> state) {
                    //           return InputDecorator(
                    //             decoration: InputDecoration(
                    //               border: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   borderSide:
                    //                       BorderSide(color: Colors.black)),
                    //               enabledBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   borderSide:
                    //                       BorderSide(color: Colors.black)),
                    //               focusedBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   borderSide:
                    //                       BorderSide(color: Colors.black)),
                    //               disabledBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   borderSide:
                    //                       BorderSide(color: Colors.black)),
                    //             ),
                    //             isEmpty: selectedPackage == '',
                    //             child: DropdownButtonHideUnderline(
                    //               child: packages.isNotEmpty
                    //                   ? DropdownButton<String>(
                    //                       // selectedPackage == ''
                    //                       //   ? packages.first.id
                    //                       //   :
                    //                       value: selectedPackage,
                    //                       isDense: true,
                    //                       hint: Text('Select type'),
                    //                       alignment:
                    //                           AlignmentDirectional.bottomCenter,
                    //                       onChanged: (String? newValue) {
                    //                         setState(() {
                    //                           selectedPackage = newValue!;
                    //                           state.didChange(newValue);
                    //                         });
                    //                       },
                    //                       items: <DropdownMenuItem<String>>[
                    //                         ...packages
                    //                             .map<DropdownMenuItem<String>>(
                    //                                 (type) {
                    //                           return DropdownMenuItem<String>(
                    //                             value: type.id,
                    //                             child: Text(
                    //                               type.name ?? '',
                    //                               style: TextStyle(
                    //                                   color: Colors.black),
                    //                             ),
                    //                             onTap: () {
                    //                               setState(() {
                    //                                 selectedPackage = type.id;
                    //                               });
                    //                             },
                    //                           );
                    //                         }).toList(),
                    //                       ],
                    //                       borderRadius:
                    //                           BorderRadius.circular(15),
                    //                       iconEnabledColor: Colors.black,
                    //                       style: TextStyle(color: Colors.black),
                    //                       menuMaxHeight: double.maxFinite,
                    //                       dropdownColor: Colors.white,
                    //                       focusColor: Colors.transparent,
                    //                       elevation: 10,
                    //                     )
                    //                   : Container(),
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     })),
                    //   ],
                    // ),
                  ],
                ),
              ),
              height10(),

              //button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              // backgroundColor: redLight,
                              disabledBackgroundColor: Colors.grey,
                              disabledForegroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: paymentMode != null &&
                                  provider.loadingVerifyCoupon == false &&
                                  (paymentMode == 'Crypto'
                                      ? cryptoType != null
                                      : true)
                              ? () => provider.createVoucherSubmit(
                                  payment_type: paymentMode == 'Crypto'
                                      ? cryptoType!
                                      : paymentMode!,
                                  package_id:
                                      provider.currentPackage!.packageId!,
                                  sale_type: provider.currentPackage!.saleType!)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                                paymentMode == 'Card' || paymentMode == 'Crypto'
                                    ? 'Proceed'
                                    : paymentMode != null
                                        ? 'Make Payment'
                                        : 'Select Payment Mode'),
                          )),
                    ))
                  ],
                ),
              ),
              height30(),
            ],
          ),
        );
      },
    );
  }

  AnimatedContainer buildCouponFieldSuffix(VoucherProvider provider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: provider.loadingVerifyCoupon ? 60 : 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
            colors: textGradiantColors.map((e) => e.withOpacity(0.4)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: TextButton(
        onPressed: provider.loadingVerifyCoupon
            ? null
            : () => _handleCoupuon(provider),
        child: provider.loadingVerifyCoupon
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 25,
                    height: 25,
                    child: Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white)),
                  ),
                ],
              )
            : Text(
                provider.couponVerified == null ? 'Check' : 'Clear',
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  _handleCoupuon(VoucherProvider provider) {
    FocusScope.of(context).unfocus();
    bool couponAdded = provider.couponVerified != null;
    if (couponAdded) {
      provider.voucherCodeController.clear();
      provider.couponVerified = null;
    } else {
      if (provider.voucherCodeController.text.isNotEmpty) {
        if (provider.packages.isNotEmpty) {
          provider.verifyCoupon(provider.voucherCodeController.text);
        } else {
          Fluttertoast.showToast(msg: 'Please select a subscription pack');
        }
      } else {
        Fluttertoast.showToast(msg: 'Please enter coupon code');
      }
    }
    setState(() {});
  }
}

class TicketPassClipper extends CustomClipper<Path> {
  TicketPassClipper({this.position, this.holeRadius = 16, this.radius = 10});

  double? position;
  final double holeRadius;
  final double radius;

  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    var pos = position ?? 0.5;
    if (pos > 1) pos = 1;
    if (pos < 0) pos = 0;

    double hr = holeRadius / 2 + holeRadius * 0.0;

    double p1 = (h * pos) - hr;
    warningLog('p1 = $p1  ${(h * pos)}  $pos $h $holeRadius');

    final path = Path()
          ..lineTo(radius, 0.0)
          ..lineTo(w - radius, 0.0)
          ..quadraticBezierTo(w, 0.0, w, radius)
          // curve to top right
          ..lineTo(w, p1)
          ..quadraticBezierTo(w - hr, p1, w - hr, p1 + hr)
          ..quadraticBezierTo(w - hr, p1 + holeRadius, w, p1 + holeRadius)

          //
          ..lineTo(w, h - radius)
          ..quadraticBezierTo(w, h, w - radius, h)
          ..lineTo(radius, h)
          ..quadraticBezierTo(0.0, h, 0.0, h - radius)

          // curve to left
          ..lineTo(0, p1 + holeRadius)
          ..quadraticBezierTo(hr, p1 + holeRadius, hr, p1 + hr)
          ..quadraticBezierTo(hr, p1, 0, p1)

          //
          ..lineTo(0.0, radius)
          ..quadraticBezierTo(0.0, 0.0, radius, 0.0)

        //
        ;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => oldClipper != this;
}
