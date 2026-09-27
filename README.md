==================================================
                 EXPENSE TRACKER
==================================================

A simple personal expense tracking application 
built with Flutter, Firebase, and Riverpod.


1. PROJECT SETUP INSTRUCTIONS
--------------------------------------------------
Step 1: Install Prerequisites
  - Make sure Flutter SDK (>= 3.13.2) and Dart are installed.
  - Make sure an Android emulator, physical device, or Chrome is available.

Step 2: Install Packages
  Open a terminal in the project folder and run:
    flutter pub get

Step 3: Firebase Configuration
  - Create a project at https://console.firebase.google.com/
  - Enable "Email/Password" sign-in under Authentication.
  - Enable "Cloud Firestore" database.
  - Connect your app by running:
    flutterfire configure

Step 4: Run the App
  In the project root, execute:
    flutter run


2. FEATURES IMPLEMENTED
--------------------------------------------------
- User Authentication:
  * Register with email and password.
  * Log in with existing credentials.
  * Sign out from the dashboard.
  * Personal data isolation per user.

- Expense Management (CRUD):
  * Add new expenses (Title, Amount, Category, Date, and Note).
  * Edit existing expenses by tapping on them.
  * Delete expenses with a confirmation prompt.
  * Real-time sync with Cloud Firestore.

- Summary & Analytics:
  * Monthly total expense card.
  * Category breakdown pie chart (Food, Transport, Bills, Health, etc.).

- Search & Filter:
  * Search expenses by title or note.
  * Filter list by category chips.

- UI / Themes:
  * Toggle between Light and Dark mode.


3. TECHNOLOGIES & PACKAGES USED
--------------------------------------------------
- Flutter & Dart: Framework and programming language.
- flutter_riverpod (v3.4.3): State management.
- firebase_core (v4.15.0): Firebase initialization.
- firebase_auth (v6.7.0): User authentication.
- cloud_firestore (v6.10.0): Real-time database.
- fl_chart (v1.2.0): Pie chart visualization.
- intl (v0.20.3): Date and currency formatting.


4. AI TOOLS USED
--------------------------------------------------
- Google Gemini:
  * Project architecture design.
  * Writing Riverpod providers and Firestore services.
  * Form validation and UI layout assistance.
  * Generating project documentation.
==================================================