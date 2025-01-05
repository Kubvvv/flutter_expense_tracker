# **Projekt 2: Expense Tracker App**

A simple expense tracker application that allows users to manage their expenses, view weather information, and interact with a basic authentication system

## **Features**

- User Authentication: Login and register functionality for users.
- Expense Tracking: Users can add, update, and delete their expenses.
- Weather Display: Fetches and displays the current weather for Cieszyn, Poland.
- Responsive Design: Adapts to screen orientation (90% width in landscape).
- State Management: Uses Provider for managing user state.
- Dynamically updates the UI to reflect changes.

---

## **Technologies Used**

- **Flutter**: A UI toolkit for building natively compiled apps.
- **Dart**: The programming language used in Flutter development.

---

## **How to Run the App**

Follow these steps to run the project locally:

### **1. Prerequisites**

- Install Flutter on your system:
  - Follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install) for your operating system.
- Ensure you have an emulator or physical device ready:
  - For iOS: Install Xcode and set up an iOS simulator.
  - For Android: Install Android Studio or set up Android Debug Bridge (ADB).
- Install a code editor (e.g., VS Code or Android Studio).

---

### **2. Clone the Repository**

Clone the project repository to your local machine:

```bash
git clone https://github.com/yourusername/expense_tracker_project.git
cd expense_tracker_project
```

---

### **3. Install Dependencies**

Run the following command to fetch all the necessary dependencies:

```bash
flutter pub get
```

---

### **4. Run the App**

- Standard:

  ```bash
  flutter run
  ```

If you are using VS Code, you can press `F5` or click "Run" in the debug menu.

---

### **5. Features in the App**

Once the app is running:

1. **User Authentication**:
   - Login: Users can log in with their credentials.
   - Register: New users can register an account by providing a username and password.
   - Provider for User State: The app uses the Provider package for managing user state across screens.
2. **Expense Management**:
   - Add new expenses.
   - View all expenses in a list.
   - Delete expenses.
   - View total expenses.
3. **Weather Widget**:
   - The app fetches the current weather for Cieszyn, Poland.
   - Displays temperature and wind speed.
   - If there’s an error (e.g., no internet connection), it shows an error message in place of the weather data.
4. **Responsive Design**:
   - In landscape mode, the app content is constrained to 80% of the screen width to ensure a clean and readable layout.
   - In portrait mode, the content uses the full screen width.

### **6. Dependencies**

- flutter: For building the app.
- http: For making network requests to fetch weather data.
- provider: For state management.
- intl: For formatting dates (used in displaying expense dates).

---
