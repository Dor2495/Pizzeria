# Pizzeria iOS App

A SwiftUI app for ordering pizza and other menu items from your favorite pizzeria.

## Overview

Pizzeria is a modern iOS app that allows users to browse a restaurant's menu, add items to a cart, and place orders. Built entirely with SwiftUI, the app provides a smooth and intuitive experience for ordering food from a local pizzeria.

## Features

- **Menu Browsing**: View the complete menu organized by categories
- **Shopping Cart**: Add items to cart, view quantity, and see total price
- **Order Placement**: Submit orders to the server
- **Real-time Feedback**: Visual indicators for loading states and successful actions
- **Restaurant Information**: View details about the pizzeria

## Technical Details

### Architecture

The app follows a straightforward architecture:

- **Models**: Define the data structures for menu items and restaurant information
- **Views**: SwiftUI components for displaying UI elements
- **APIClient**: Handles network communication and state management

### Key Components

- **ContentView.swift**: Main view controller that displays the menu
- **CartView.swift**: Manages the shopping cart and checkout process
- **APIClient.swift**: Handles all API communication with the server
- **Model/*.swift**: Data models for menu items and restaurant information
- **Views/*.swift**: Reusable UI components like banners and custom rows

### Networking

The app communicates with a Swift server running on localhost:8080 with endpoints:
- `GET /pizza` - Retrieves restaurant information
- `GET /menu` - Fetches the menu categories and items
- `POST /order` - Submits orders to the server

## Getting Started

### Prerequisites

- Xcode 14.0 or later
- iOS 16.0 or later
- Swift 5.0 or later
- The companion Swift server running on localhost:8080

### Running the App

1. Open `Pizzeria.xcodeproj` in Xcode
2. Ensure the Swift server is running on port 8080
3. Select a simulator or device
4. Build and run the app (⌘R)

## Usage

1. **Browse Menu**: Scroll through the menu to view available items
2. **Add to Cart**: Swipe left on an item and tap the cart icon to add it to your cart
3. **View Cart**: Tap the cart icon in the top-right corner to view your cart
4. **Checkout**: Tap "Checkout" to place your order
5. **Pull to Refresh**: Pull down on the menu to refresh the data

## Implementation Details

- Uses modern Swift concurrency (`async/await`) for network requests
- Implements `@StateObject` and `@Binding` for state management
- Uses SwiftUI's `List` and `NavigationStack` for navigation
- Features custom UI components like `Banner` for notifications
- Includes loading indicators during network operations
- Groups identical items in the cart for better usability
