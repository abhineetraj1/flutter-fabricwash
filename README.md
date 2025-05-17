# FabricWash - B2C Laundry Application


https://github.com/user-attachments/assets/38a883a3-8556-4f50-9fd5-40f8898a590f



FabricWash is a B2C (Business-to-Consumer) laundry application that connects customers with a seamless laundry service. It provides both a Flutter mobile app for customers and an admin panel to manage orders and financials.

## Features

### 1. **Admin Panel**

* **Financial Dashboard**: View financial insights and track overall performance.
* **Order Management**: Manage orders, view, update, and keep track of customer requests.

### 2. **Flutter App**

* **Sign Up / Sign In**: Register and authenticate users for a personalized experience.
* **Order Management**:

  * Create new laundry orders
  * Cancel existing orders
  * View order history
  * Filter orders based on status, date, etc.
* **Account Management**: Update and edit personal details within the user profile.



## Execution

### 1. **Flutter App Setup**

To run the Flutter application, follow these steps:

1. Clean the Flutter build and clear cache:

   ```bash
   flutter clean
   ```

2. Download and install the dependencies:

   ```bash
   flutter pub get
   ```

3. Run the Flutter app:

   ```bash
   flutter run
   ```

### 2. **Server Setup**

To set up the backend server, follow these steps:

1. Navigate to the `server` directory:

   ```bash
   cd server
   ```

2. Install the required dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Start the Flask server:

   ```bash
   flask run
   ```


## Installation

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Python 3.x](https://www.python.org/downloads/)
* [Pip](https://pip.pypa.io/en/stable/)



## Developer

* [Abhineet Raj](https://github.com/abhineetraj1)


## Contributing

We welcome contributions! Feel free to fork the repository, make changes, and create pull requests.

1. Fork the repository
2. Clone your forked repository
3. Create a new branch: `git checkout -b feature-name`
4. Commit your changes: `git commit -m 'Add new feature'`
5. Push to your branch: `git push origin feature-name`
6. Create a pull request!
