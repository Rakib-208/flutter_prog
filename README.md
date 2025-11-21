# Sandwich Shop Flutter App

A simple Flutter application simulating a sandwich ordering interface. Users can:
- Adjust sandwich quantity (bounded by a max).
- Toggle size (six-inch vs footlong).
- Select bread type via dropdown.
- Add custom notes (e.g., ingredient preferences).
- View dynamic emoji representation per sandwich.
- See live updates reflected in UI and covered by widget/unit tests.

## Features

- Quantity counter with upper and lower bounds.
- Size toggle (Switch).
- Bread selection (DropdownMenu).
- Notes input (TextField).
- Reusable StyledButton widget.
- Order summary (quantity, size, bread, notes).
- Fully tested repository logic and widgets.

## Installation & Setup

### Prerequisites
- OS: Windows, macOS, or Linux
- Flutter SDK (stable) installed (https://docs.flutter.dev/get-started/install)
- Dart (bundled with Flutter)
- Android Studio or VS Code (optional)
- Xcode (for iOS builds on macOS)

### Clone Repository
```bash
git clone https://github.com/your-username/flutter_prog.git
cd flutter_prog
```

### Install Dependencies
```bash
flutter pub get
```

### Run App
```bash
flutter run
```
(Select a device/emulator first: `flutter devices`)

### Run Tests
```bash
flutter test
```

## Usage

1. Launch the app (default max quantity: 5 on home screen).
2. Add sandwiches with the Add button until limit reached.
3. Remove sandwiches with the Remove button (won’t go below 0).
4. Toggle size using the central switch.
5. Choose bread from dropdown (white, wheat, multigrain, rye).
6. Enter a note (updates live below).
7. Observe sandwich emoji count scaling with quantity.

### Configuration
To change max quantity:
```dart
home: OrderScreen(maxQuantity: 10)
```

### Screenshots (place assets under `assets/screenshots/`)
![Home Screen](assets/screenshots/home.png)
![Bread Selection](assets/screenshots/bread_dropdown.png)
![Quantity Updated](assets/screenshots/quantity.png)

(Replace with real images.)

## Project Structure

```
lib/
  main.dart                // App root, UI, enum, StyledButton, screen & display widgets
  views/app_styles.dart    // Central text styles
  repositories/order_repository.dart // Business logic for quantity
test/
  repositories/order_repository_test.dart // Unit tests for logic
  views/widget_test.dart   // Widget tests (UI behavior & interaction)
```

### Key Components
- OrderRepository: Encapsulates quantity logic (increment/decrement with guards).
- OrderScreen: Stateful UI managing user interactions.
- OrderItemDisplay: Displays order summary details.
- StyledButton: Reusable elevated button with icon + label.

### Technologies & Tools
- Flutter (Material)
- Dart
- flutter_test (unit & widget testing)

## Tests

Covered:
- Repository initial state, increment/decrement bounds.
- Widget rendering (title, quantity, emojis).
- Interaction (buttons, dropdown, switch, textfield).
- StyledButton presence and structure.

Run all:
```bash
flutter test
```

## Known Issues / Limitations

- No backend persistence (in-memory only).
- Enum bread names are raw (could be localized).
- No accessibility audit (e.g., semantics).
- StyledButton styles partially duplicated (could refactor with shared theme).

## Future Improvements

- Persist orders (sqflite / hive / cloud).
- Add ingredient customization modal.
- Dark mode theming.
- Localization (intl).
- State management (Provider / Riverpod).
- CI pipeline (GitHub Actions).

## Contributing

1. Fork repository.
2. Create feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit changes:
   ```bash
   git commit -m "Add feature"
   ```
4. Push:
   ```bash
   git push origin feature/your-feature
   ```
5. Open Pull Request.

Follow:
- Meaningful commit messages.
- Include tests for new logic.
- Run `flutter analyze` before PR.

## Contact

Author: Your Name  
Email: your.email@example.com  
GitHub: https://github.com/your-username  
LinkedIn: https://www.linkedin.com/in/your-profile

(Replace placeholders.)

---
Happy coding!
