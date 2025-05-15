import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/providers/connectivity_provider.dart';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:read_the_label/viewmodels/ui_view_model.dart';
import 'package:read_the_label/views/screens/food_scan_page.dart';
import 'package:read_the_label/views/screens/daily_intake_page.dart';
import 'package:read_the_label/views/screens/settings_page.dart';
import 'package:read_the_label/views/screens/profile_page.dart';
import 'package:read_the_label/views/widgets/offline_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.transparent),
          ),
        ),
        centerTitle: true,
        title: Consumer<UiViewModel>(
          builder: (context, uiProvider, _) {
            return Text(
              [
                'Scan Food',
                'Daily Intake',
                'Settings'
              ][uiProvider.currentIndex],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Theme.of(context).colorScheme.surface,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Consumer<UiViewModel>(
                      builder: (context, uiProvider, _) {
                        return IndexedStack(
                          key: ValueKey<int>(uiProvider.currentIndex),
                          index: uiProvider.currentIndex,
                          children: [
                            AnimatedOpacity(
                              opacity: uiProvider.currentIndex == 0 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const FoodScanPage(),
                            ),
                            AnimatedOpacity(
                              opacity: uiProvider.currentIndex == 1 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const DailyIntakePage(),
                            ),
                            AnimatedOpacity(
                              opacity: uiProvider.currentIndex == 2 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const SettingsPage(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: kBottomNavigationBarHeight + 12,
            child: const OfflineBanner(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<UiViewModel>(
      builder: (context, uiProvider, _) {
        return Container(
          color: Theme.of(context).colorScheme.cardBackground,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: BottomNavigationBar(
                elevation: 0,
                selectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                backgroundColor: Colors.transparent,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey,
                currentIndex: uiProvider.currentIndex,
                onTap: (index) {
                  uiProvider.updateCurrentIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.food_bank),
                    label: 'Scan Food',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart),
                    label: 'Daily Intake',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
