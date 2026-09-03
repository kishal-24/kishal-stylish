# 🛍️ Kishal Stylish

A modern **fashion e-commerce mobile application** built using **Flutter and Dart**. The application provides a smooth shopping experience with product browsing, wishlist, cart management, address selection, checkout, order placement, and payment flow.

## 📱 Features

* 🏠 Modern home page
* 🔍 Product search and browsing
* 👕 Product details
* ❤️ Wishlist / favorite products
* 🛒 Add to cart
* ➕ Increase and decrease product quantity
* 💰 Automatic price and total calculation
* 📍 Personal and business delivery addresses
* 🔄 Switch between personal and business address
* 💾 Address persistence using SharedPreferences
* 📦 Checkout and shopping list
* 🧾 Order summary
* 💳 Payment page
* ✨ Loading and success animations
* 🔥 Firebase integration
* 📱 Android mobile application

## 🛠️ Technologies Used

* **Flutter**
* **Dart**
* **Firebase**
* **SharedPreferences**
* **Lottie Animations**
* **Google Fonts**
* **Image Picker**

## 📂 Project Structure

```text
lib/
├── main.dart
├── home.dart
├── checkout.dart
├── check.dart
├── Placeorderpage.dart
├── payment.dart
├── Product_detailspage.dart
├── cart_data.dart
├── wish.dart
└── bot.dart
```

> File names may change as the project continues to be developed.

## ⚙️ Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/kishal-24/kishal-stylish.git
```

### 2. Open the project

```bash
cd kishal-stylish
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

Connect an Android device or start an Android emulator, then run:

```bash
flutter run
```

## 🔥 Firebase

This project uses Firebase for application integration.

Firebase configuration files are required for running the project with Firebase services.

## 💾 Local Storage

The application uses **SharedPreferences** to store information such as:

* Personal address
* Business address
* Selected delivery address
* Address selection preference

This allows saved addresses to remain available when navigating between checkout and order pages.

## 🛒 Shopping Flow

```text
Home
  ↓
Product Details
  ↓
Add to Cart
  ↓
Cart / Checkout
  ↓
Select Delivery Address
  ↓
Place Order
  ↓
Payment
```

## 🎯 Future Improvements

* 🔐 User authentication
* 💳 Real payment gateway integration
* 📦 Order history
* 👤 User profile
* ☁️ Cloud-based cart and wishlist
* 🔔 Order notifications
* 🚚 Order tracking
* ⭐ Product reviews and ratings
* 🔎 Advanced product filtering

## 👨‍💻 Developer

**Kishal**

GitHub:
https://github.com/kishal-24

## 📄 License

This project is created for learning and development purposes.

---

⭐ If you find this project useful, consider giving the repository a star!
