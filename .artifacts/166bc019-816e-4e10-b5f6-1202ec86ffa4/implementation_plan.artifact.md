# Project Reorganization Plan

This plan aims to reorganize the project into a professional, scalable Flutter structure, fix naming inconsistencies, and standardize imports.

## User Review Required

> [!IMPORTANT]
> - The package name will be changed from `untitled` to `stylish` in `pubspec.yaml`. This will require updating all imports throughout the project.
> - Some files will be renamed to follow Dart's `snake_case` convention (e.g., `Placeorderpage.dart` to `place_order_page.dart`).
> - The `widget/product_detailspage.dart` will be moved to `screens/` as it represents a full page.

## Proposed Changes

### Configuration
#### [MODIFY] [pubspec.yaml](file:///C:/Users/ELCOT/kishal-stylish/pubspec.yaml)
- Change `name: untitled` to `name: stylish`.

---

### Data Layer (Consolidation)
Move network, models, and business logic services into a unified `data/` folder.

#### [NEW] `lib/data/api/` (Move from `lib/api/`)
#### [NEW] `lib/data/models/` (Move from `lib/models/`)
#### [NEW] `lib/data/services/` (Move from `lib/services/`)

---

### State Management
#### [NEW] `lib/providers/` (Rename from `lib/provider/`)

---

### UI Components
#### [NEW] `lib/widgets/` (Rename from `lib/widget/`)
- Note: `product_detailspage.dart` will be moved out of here.

---

### Screens
#### [MODIFY] `lib/screens/`
- Move `lib/widget/product_detailspage.dart` to `lib/screens/product_details_page.dart`.
- Rename `Placeorderpage.dart` to `place_order_page.dart`.

---

### Import Standardization
- Update all files to use `package:stylish/...` instead of `package:untitled/...` or complex relative paths.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure all imports are resolved correctly.
- Run `flutter test` (if any exist) to verify basic functionality.

### Manual Verification
- Verify that the app builds and runs successfully in the emulator.
- Check that navigation between screens (like Wishlist to Product Details) still works.
