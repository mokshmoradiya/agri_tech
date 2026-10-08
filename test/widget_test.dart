import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agri_tech/screens/dashboard_screen.dart';
import 'package:agri_tech/screens/crop_detail_screen.dart';
import 'package:agri_tech/screens/my_crops_screen.dart';
import 'package:agri_tech/screens/crop_expense_calculator_screen.dart';
import 'package:agri_tech/screens/weather_screen.dart';
import 'package:agri_tech/widgets/app_top_bar.dart';
import 'package:agri_tech/widgets/custom_search_bar.dart';
import 'package:agri_tech/widgets/farmer_toolkit.dart';
import 'package:agri_tech/widgets/app_bottom_nav_bar.dart';
import 'package:agri_tech/screens/login_screen.dart';
import 'package:agri_tech/services/farmer_profile_repository.dart';
import 'package:agri_tech/widgets/edit_profile_modal.dart';
import 'package:agri_tech/widgets/change_password_modal.dart';

void main() {
  testWidgets('DashboardScreen and CropGuide flow works properly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    // Verify common topbar
    expect(find.byType(AppTopBar), findsOneWidget);
    expect(find.text('AgriTech'), findsWidgets);

    // Verify search bar
    expect(find.byType(CustomSearchBar), findsOneWidget);

    // Verify Weather glance card on Home page
    expect(find.textContaining('Anand, Gujarat • 29°C'), findsOneWidget);

    // Verify Farmer's Toolkit (including Weather, Calculator, My Crops)
    expect(find.byType(FarmerToolkit), findsOneWidget);
    expect(find.text("Farmer's Toolkit"), findsOneWidget);
    expect(find.text('Weather'), findsOneWidget);
    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('Crop Knowledge'), findsOneWidget);
    expect(find.text('My Crops'), findsOneWidget);

    // Verify My Sown Crops preview on home dashboard
    expect(find.text('My Sown Crops'), findsWidgets);

    // Verify Bottom Navigation Bar tabs
    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Crop Guide'), findsOneWidget);
    expect(find.text('AI Assistant'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap on Crop Guide tab
    await tester.tap(find.text('Crop Guide'));
    await tester.pumpAndSettle();

    // Verify Crop Knowledge Base elements
    expect(find.text('Crop Knowledge Base'), findsOneWidget);
    expect(find.text('Common Crops'), findsOneWidget);
    expect(find.text('Cotton'), findsOneWidget);
    expect(find.text('Wheat'), findsOneWidget);

    // Scroll into view & tap on Cotton
    await tester.ensureVisible(find.text('Cotton'));
    await tester.tap(find.text('Cotton'));
    await tester.pumpAndSettle();

    // Verify CropDetailScreen elements in English
    expect(find.byType(CropDetailScreen), findsOneWidget);
    expect(find.text('Introduction'), findsOneWidget);
    expect(find.text('Climate & Soil'), findsOneWidget);
    expect(find.textContaining('Harvest Duration'), findsWidgets);
    expect(find.textContaining('Irrigation Schedule'), findsWidgets);
    expect(find.textContaining('Fertilizer Schedule'), findsWidgets);
    expect(find.text('Basal Dose'), findsOneWidget);

    // Verify Bottom Navigation Bar is present inside CropDetailScreen
    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });

  testWidgets('Farmer Toolkit My Crops functionality opens and allows adding sown crop', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    // Tap on "My Crops" icon in Farmer's Toolkit
    expect(find.text('My Crops'), findsOneWidget);
    await tester.tap(find.text('My Crops'));
    await tester.pumpAndSettle();

    // Verify MyCropsScreen is displayed
    expect(find.byType(MyCropsScreen), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.text('My Sown Crops'), findsOneWidget);
    expect(find.text('Total Sown Land Area'), findsOneWidget);

    // Open "Add Sown Crop" modal
    await tester.tap(find.text('+ Add Sown Crop'));
    await tester.pumpAndSettle();

    // Verify Add Sown Crop modal elements
    expect(find.text('Add Sown Crop'), findsWidgets);
    expect(find.text('Register your sown crop'), findsOneWidget);
    expect(find.textContaining('Crop Name'), findsWidgets);
    expect(find.textContaining('Sowing Date'), findsWidgets);
    expect(find.textContaining('Cultivated Land Area'), findsWidgets);

    // Select Mustard from popular crop chips
    await tester.tap(find.text('Mustard'));
    await tester.pumpAndSettle();

    // Enter cultivated land area
    final areaField = find.widgetWithText(TextFormField, 'e.g. 4.5');
    await tester.enterText(areaField, '5.5');
    await tester.pumpAndSettle();

    // Submit the form
    await tester.tap(find.text('Save Sown Crop'));
    await tester.pumpAndSettle();

    // Verify Mustard is now listed in My Crops
    expect(find.text('Mustard'), findsOneWidget);
    expect(find.text('5.5 Acres'), findsOneWidget);
  });

  testWidgets('Farmer Toolkit Calculator opens Crop Expense and Labor Wage Calculator', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    // Tap on Calculator in Farmer's Toolkit
    expect(find.text('Calculator'), findsOneWidget);
    await tester.tap(find.text('Calculator'));
    await tester.pumpAndSettle();

    // Verify CropExpenseCalculatorScreen is displayed
    expect(find.byType(CropExpenseCalculatorScreen), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.text('Farm Cost & Calculator'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Labor Ledger'), findsOneWidget);
    expect(find.text('Cost Estimator'), findsOneWidget);

    // Verify expense categories: spray, fertilizer, labor
    expect(find.text('Spray'), findsWidgets);
    expect(find.text('Fertilizer'), findsWidgets);
    expect(find.text('Labor'), findsWidgets);

    // Switch to Labor Ledger tab
    await tester.tap(find.text('Labor Ledger'));
    await tester.pumpAndSettle();

    // Verify labor records and wage calculation
    expect(find.textContaining('Labor Entries'), findsOneWidget);
    expect(find.textContaining('Village Labor Group'), findsOneWidget);
    expect(find.textContaining('4 workers × ₹350 × 2 days'), findsOneWidget);
  });

  testWidgets('Farmer Toolkit Weather opens Agri Weather and Forecast Screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    // Tap on Weather in Farmer's Toolkit
    expect(find.text('Weather'), findsOneWidget);
    await tester.tap(find.text('Weather'));
    await tester.pumpAndSettle();

    // Verify WeatherScreen is displayed
    expect(find.byType(WeatherScreen), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.text('Agri Weather & Forecast'), findsOneWidget);
    expect(find.textContaining('Weather & Farm Advisories'), findsWidgets);

    // Verify key weather metrics
    expect(find.textContaining('Humidity'), findsWidgets);
    expect(find.textContaining('Wind'), findsWidgets);
    expect(find.textContaining('Rain'), findsWidgets);

    // Verify agricultural spray condition badge
    expect(find.textContaining('Favorable Spray Weather'), findsOneWidget);

    // Verify agricultural advisories
    expect(find.textContaining('Farm Weather Advisories'), findsOneWidget);
    expect(find.textContaining('Optimal Pesticide Spray Window'), findsOneWidget);
  });

  testWidgets('Bottom navigation tab tap from child screen switches Dashboard tab', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    // Navigate to WeatherScreen
    await tester.tap(find.text('Weather'));
    await tester.pumpAndSettle();
    expect(find.byType(WeatherScreen), findsOneWidget);

    // Tap on Crop Guide in bottom navigation bar
    await tester.tap(find.text('Crop Guide'));
    await tester.pumpAndSettle();

    // WeatherScreen should be popped and Dashboard switches to Crop Knowledge Base
    expect(find.text('Crop Knowledge Base'), findsOneWidget);
  });

  testWidgets('Farmer profile can be viewed, edited, password changed, and logged out', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    FarmerProfileRepository.instance.resetToDefault();

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );

    // Switch to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify default farmer profile details
    expect(find.text('Ramesh Patel'), findsOneWidget);
    expect(find.textContaining('Anand, Gujarat • 8.5 Acres'), findsOneWidget);
    expect(find.textContaining('KCC ID: GJ-AND-2024-8849'), findsOneWidget);

    // Verify Profile actions
    expect(find.text('Edit Farmer Profile'), findsWidgets);
    expect(find.text('Change Password'), findsWidgets);
    expect(find.text('Logout'), findsWidgets);

    // 1. EDIT PROFILE FLOW
    await tester.tap(find.widgetWithText(InkWell, 'Edit Farmer Profile').first);
    await tester.pumpAndSettle();

    expect(find.byType(EditProfileModal), findsOneWidget);
    expect(find.text('Edit Farmer Profile'), findsWidgets);

    // Edit Name
    final nameField = find.widgetWithText(TextFormField, 'Ramesh Patel');
    await tester.enterText(nameField, 'Suresh Patel');
    await tester.pumpAndSettle();

    // Save changes
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    // Verify updated profile name appears on dashboard
    expect(find.text('Suresh Patel'), findsOneWidget);

    // 2. CHANGE PASSWORD FLOW
    await tester.tap(find.widgetWithText(InkWell, 'Change Password').first);
    await tester.pumpAndSettle();

    expect(find.byType(ChangePasswordModal), findsOneWidget);
    expect(find.text('Change Password'), findsWidgets);

    // Close change password sheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // 3. LOGOUT FLOW
    await tester.tap(find.widgetWithText(InkWell, 'Logout').first);
    await tester.pumpAndSettle();

    // Verify Logout dialog
    expect(find.textContaining('Are you sure you want to log out'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Logout'), findsWidgets);

    // Tap confirm Logout in dialog
    final dialogLogoutButton = find.widgetWithText(ElevatedButton, 'Logout');
    await tester.tap(dialogLogoutButton);
    await tester.pumpAndSettle();

    // Verify redirected to LoginScreen
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Crop image assets exist and are loadable', (WidgetTester tester) async {
    final cottonData = await rootBundle.load('assets/images/cottan.jpeg');
    expect(cottonData.lengthInBytes, greaterThan(0));

    final riceData = await rootBundle.load('assets/images/rice.jpg');
    expect(riceData.lengthInBytes, greaterThan(0));

    final groundnutData = await rootBundle.load('assets/images/Groundnut.jpg');
    expect(groundnutData.lengthInBytes, greaterThan(0));

    final maizeData = await rootBundle.load('assets/images/maize.jpg');
    expect(maizeData.lengthInBytes, greaterThan(0));
  });
}

