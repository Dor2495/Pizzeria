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

## Server Integration

The app integrates with a Swifter-based HTTP server (`main.swift`) through JSON data exchange:

### Server Endpoints

1. **GET /pizza**
   - Returns restaurant information (name, address, contact details, opening hours)
   - Maps to the `Pizzeria` model in the iOS app
   - Example response:
   ```json
   {
     "name": "Bella Napoli",
     "address": "123 Main Street, Springfield",
     "phone": "+1-555-123-4567",
     "email": "contact@bellanapoli.com",
     "website": "https://www.bellanapoli.com",
     "opening_hours": {
       "monday": "11:00 - 22:00",
       "tuesday": "11:00 - 22:00",
       "wednesday": "11:00 - 22:00",
       "thursday": "11:00 - 22:00",
       "friday": "11:00 - 23:00",
       "saturday": "12:00 - 23:00",
       "sunday": "12:00 - 21:00"
     }
   }
   ```

2. **GET /menu**
   - Returns the complete menu organized by categories
   - Maps to `MenuResponse` -> `[Category]` -> `[MenuItem]` in the iOS app
   - Example response:
   ```json
   {
     "categories": [
       {
         "name": "Pizzas",
         "items": [
           {
             "id": 1,
             "name": "Margherita",
             "description": "Classic pizza with tomato sauce, mozzarella, and basil",
             "price": 9.99,
             "vegetarian": true
           },
           ... more items ...
         ]
       },
       ... more categories ...
     ]
   }
   ```

3. **POST /order**
   - Accepts an array of menu items as the order
   - iOS app sends `[MenuItem]` as JSON array
   - Server stores the most recent order in memory
   - Example request:
   ```json
   [
     {
       "id": 1,
       "name": "Margherita",
       "description": "Classic pizza with tomato sauce, mozzarella, and basil",
       "price": 9.99,
       "vegetarian": true
     },
     ... more items ...
   ]
   ```

4. **GET /orders** (Web Interface)
   - Displays the most recent order in an HTML table
   - Not used by the iOS app but useful for testing/debugging
   - Open http://localhost:8080/orders in a browser to view the latest order

### Integration Points in iOS App

The `APIClient.swift` class handles all communication with the server:

1. **Base URL Configuration**:
   ```swift
   let port = 8080
   var baseURLString: String = "http://localhost:\(port)/"
   ```

2. **Fetching Restaurant Info**:
   ```swift
   func getPizerriaInfo() async {
       guard let url = URL(string: "\(baseURLString)pizza") else { return }
       let (data, _) = try await URLSession.shared.data(from: url)
       pizzeria = try JSONDecoder().decode(Pizzeria.self, from: data)
   }
   ```

3. **Fetching Menu**:
   ```swift
   func getMenu() async {
       guard let url = URL(string: "\(baseURLString)menu") else { return }
       let (data, _) = try await URLSession.shared.data(from: url)
       let menuRespomseModel = try JSONDecoder().decode(MenuResponse.self, from: data)
       menu = menuRespomseModel.categories
   }
   ```

4. **Submitting Orders**:
   ```swift
   func checkout(cart: [MenuItem]) async {
       guard let url = URL(string: "\(baseURLString)order") else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = try JSONEncoder().encode(cart)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       let (data, _) = try await URLSession.shared.data(for: request)
   }
   ```

### Testing the Integration

1. Start the server:
   ```
   cd swift-server/SwiftServer
   swift run
   ```
   
2. Run the iOS app in the simulator or on a device
   
3. The app should automatically connect to the server, fetch data, and allow order placement
   
4. View submitted orders at http://localhost:8080/orders

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
