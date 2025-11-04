import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RewardedAd? _rewardedAd;
  bool _isAdReady = false;

  int userCoins = 0;
  bool _isLoading = true;
  List<String> ownedItems = [];
  String currentLevel = "Recluta";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRewardedAd();
    _loadUserData();
  }

  /// 🔹 Carga datos del usuario
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          userCoins = data['coins'] ?? 0;
          ownedItems = List<String>.from(data['ownedItems'] ?? []);
          currentLevel = (data['level'] ?? 'Recluta').toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error al cargar datos de usuario: $e");
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Actualiza datos en Firestore
  Future<void> _updateUserData({
    int? coins,
    List<String>? items,
    String? level,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final updateData = <String, dynamic>{};
      if (coins != null) updateData['coins'] = coins;
      if (items != null) updateData['ownedItems'] = List<String>.from(items);
      if (level != null) updateData['level'] = level;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updateData);
    } catch (e) {
      debugPrint("Error al actualizar usuario: $e");
    }
  }

  /// 🔹 Carga anuncio recompensado
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdReady = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Error al cargar anuncio: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  /// 🔹 Muestra anuncio y otorga monedas
  void _showRewardedAd(AppLocalizations loc) {
    if (_isAdReady && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          final newCoins = userCoins + 500;

          setState(() => userCoins = newCoins);
          await _updateUserData(coins: newCoins);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.rechargeSuccess),
              backgroundColor: Colors.green,
            ),
          );
        },
      );
      _loadRewardedAd();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.adLoading),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      _loadRewardedAd();
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    final accessories = [
      {
        'id': 'gripGloves',
        'name': '👑 ${loc.gripGloves}',
        'price': 250,
        'image': 'assets/store/gloves.png',
        'description': loc.accessoryDescription1,
      },
      {
        'id': 'powerBelt',
        'name': '🧞 ${loc.powerBelt}',
        'price': 500,
        'image': 'assets/store/belt.png',
        'description': loc.accessoryDescription2,
      },
      {
        'id': 'nonSlipBoots',
        'name': '🎮 ${loc.nonSlipBoots}',
        'price': 300,
        'image': 'assets/store/boots.png',
        'description': loc.accessoryDescription3,
      },
    ];

    final vipAvatars = [
      {
        'id': 'vip1',
        'name': loc.titanGold,
        'price': 1200,
        'image': 'assets/store/titan_gold.png',
        'description': loc.avatarDescription1,
      },
      {
        'id': 'vip2',
        'name': loc.cyberWarrior,
        'price': 1500,
        'image': 'assets/store/cyber_warrior.png',
        'description': loc.avatarDescription2,
      },
      {
        'id': 'vip3',
        'name': loc.masterPower,
        'price': 2000,
        'image': 'assets/store/master_power.png',
        'description': loc.avatarDescription3,
      },
    ];

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
        title: Text(
          loc.store,
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
              color: colorScheme.primary,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onBackground.withOpacity(0.6),
          tabs: [
            Tab(text: loc.accessories),
            Tab(text: loc.vipAvatars),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Barra superior con monedas
            Container(
              padding: const EdgeInsets.all(16),
              color: colorScheme.primary.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      loc.userCoinsLabel(userCoins.toString()),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showRewardedAd(loc),
                    icon: const Icon(Icons.play_circle_fill),
                    label: Text(loc.recharge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Cuerpo principal
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStoreGrid(accessories, colorScheme, theme, loc, false),
                  _buildStoreGrid(vipAvatars, colorScheme, theme, loc, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Grilla de productos
  Widget _buildStoreGrid(
    List<Map<String, dynamic>> items,
    ColorScheme colorScheme,
    ThemeData theme,
    AppLocalizations loc,
    bool isVip,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final alreadyOwned = ownedItems.contains(item['id']);
        final isActiveVip = isVip && currentLevel == item['id'];

        return _buildStoreCard(
          item,
          colorScheme,
          theme,
          loc,
          alreadyOwned,
          isVip,
          isActiveVip,
        );
      },
    );
  }

  /// 🔹 Tarjeta de producto
  Widget _buildStoreCard(
    Map<String, dynamic> item,
    ColorScheme colorScheme,
    ThemeData theme,
    AppLocalizations loc,
    bool alreadyOwned,
    bool isVip,
    bool isActiveVip,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    String buttonText;
    Color buttonColor;

    if (isVip) {
      if (isActiveVip) {
        buttonText = loc.deactivate;
        buttonColor = Colors.redAccent;
      } else if (alreadyOwned) {
        buttonText = loc.activate;
        buttonColor = Colors.green;
      } else {
        buttonText = loc.buy;
        buttonColor = colorScheme.primary;
      }
    } else {
      buttonText = alreadyOwned ? loc.purchaseCompleted : loc.buy;
      buttonColor = alreadyOwned ? Colors.grey : colorScheme.primary;
    }

    return Card(
      color: isDark ? const Color(0xFF1E1E24) : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.asset(
                item['image'],
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Text(
                item['description'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onBackground.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '💰 ${item['price']}',
              style: TextStyle(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: ElevatedButton(
                onPressed: () {
                  if (isVip) {
                    _handleVipAction(item, loc, alreadyOwned, isActiveVip);
                  } else if (!alreadyOwned) {
                    _handlePurchase(item, loc);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Compra normal
  void _handlePurchase(Map<String, dynamic> item, AppLocalizations loc) async {
    if (userCoins < item['price']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.notEnoughCoins),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newCoins = userCoins - (item['price'] as int);
    final updatedItems = [...ownedItems, item['id']];

    setState(() {
      userCoins = newCoins;
      ownedItems = List<String>.from(updatedItems);
    });

    await _updateUserData(
      coins: newCoins,
      items: List<String>.from(updatedItems),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.purchaseSuccess(item['name'])),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// 🔹 Manejo de VIPs
  void _handleVipAction(
      Map<String, dynamic> item, AppLocalizations loc, bool owned, bool active) async {
    final id = item['id'];

    if (active) {
      await _updateUserData(level: 'Recluta');
      setState(() => currentLevel = 'Recluta');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${item['name']} ${loc.deactivated}"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!owned) {
      if (userCoins < item['price']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.notEnoughCoins),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final newCoins = userCoins - (item['price'] as int);
      final updatedItems = [...ownedItems, id];

      await _updateUserData(
        coins: newCoins,
        items: List<String>.from(updatedItems),
        level: id,
      );

      setState(() {
        userCoins = newCoins;
        ownedItems = List<String>.from(updatedItems);
        currentLevel = id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.purchaseSuccess(item['name'])),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    await _updateUserData(level: id);
    setState(() => currentLevel = id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['name']} ${loc.activated}"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
