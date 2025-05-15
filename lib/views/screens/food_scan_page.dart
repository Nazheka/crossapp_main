import 'dart:io';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:rive/rive.dart' as rive;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/viewmodels/daily_intake_view_model.dart';
import 'package:read_the_label/viewmodels/meal_analysis_view_model.dart';
import 'package:read_the_label/viewmodels/ui_view_model.dart';
import 'package:read_the_label/views/screens/ask_ai_page.dart';
import 'package:read_the_label/views/widgets/ask_ai_widget.dart';
import 'package:read_the_label/views/widgets/food_item_card.dart';
import 'package:read_the_label/views/widgets/food_item_card_shimmer.dart';
import 'package:read_the_label/views/widgets/product_image_capture_buttons.dart';
import 'package:read_the_label/views/widgets/total_nutrients_card.dart';
import 'package:read_the_label/views/widgets/total_nutrients_card_shimmer.dart';
import 'package:read_the_label/providers/connectivity_provider.dart';

class FoodScanPage extends StatefulWidget {
  const FoodScanPage({
    super.key,
  });

  @override
  State<FoodScanPage> createState() => _FoodScanPageState();
}

class _FoodScanPageState extends State<FoodScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Food'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 80,
          ),
          child: Consumer4<UiViewModel, MealAnalysisViewModel, DailyIntakeViewModel, ConnectivityProvider>(
            builder: (context, uiProvider, mealAnalysisProvider, dailyIntakeProvider, connectivityProvider, _) {
              final bool isOffline = !connectivityProvider.isConnected;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  // Scanning Section
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Column(
                      children: [
                        if (mealAnalysisProvider.foodImage != null)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(image: FileImage(mealAnalysisProvider.foodImage!)),
                              ),
                              if (uiProvider.loading)
                                const Positioned.fill(
                                  child: Center(child: CircularProgressIndicator()),
                                )
                            ],
                          )
                        else
                          Icon(
                            Icons.restaurant_outlined,
                            size: 70,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          isOffline
                              ? "You are offline. Please connect to the internet to analyze food."
                              : "Snap a picture of your meal or pick one from your gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FoodImageCaptureButtons(
                          onImageCapturePressed: isOffline
                              ? (source) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please connect to the internet to analyze food.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              : _handleFoodImageCapture,
                        ),
                      ],
                    ),
                  ),

                  //Loading animation
                  if (uiProvider.loading)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Analysis Results',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        const FoodItemCardShimmer(),
                        const FoodItemCardShimmer(),
                        const TotalNutrientsCardShimmer(),
                      ],
                    ),

                  // Results Section
                  if (mealAnalysisProvider.foodImage != null &&
                      mealAnalysisProvider.analyzedFoodItems.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Analysis Results',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        ...mealAnalysisProvider.analyzedFoodItems
                            .asMap()
                            .entries
                            .map((entry) => FoodItemCard(
                                  item: entry.value,
                                  index: entry.key,
                                )),
                        const TotalNutrientsCard(),
                        InkWell(
                          onTap: () {
                            print("Tap detected!");
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AskAiPage(
                                  mealName: mealAnalysisProvider.mealName,
                                  foodImage: mealAnalysisProvider.foodImage!,
                                ),
                              ),
                            );
                          },
                          child: const AskAiWidget(),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleFoodImageCapture(ImageSource source) async {
    final mealAnalysisProvider = Provider.of<MealAnalysisViewModel>(context, listen: false);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    
    if (!connectivityProvider.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect to the internet to analyze food.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: source);

    if (image != null) {
      mealAnalysisProvider.setFoodImage(File(image.path));
      await mealAnalysisProvider.analyzeFoodImage(
        imageFile: mealAnalysisProvider.foodImage!,
      );
    }
  }
}
