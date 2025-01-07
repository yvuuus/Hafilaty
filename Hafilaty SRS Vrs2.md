# Software Requirements Specification (SRS)

# 1\. Introduction 

## 1.1 Purpose 

The purpose of this document is to specify the software requirements for the Bus Tracking Application. This application helps bus passengers by providing real-time tracking of bus locations to reduce waiting times and improve convenience. The intended audience is the bus passengers.

## 1.2 Scope 

The Bus Tracking System will allow users (commuters, drivers, and administrators) to view live bus locations, check schedules, receive notifications, and manage bus operations efficiently.The system will be available as a mobile application.

## 1.3 Definitions, Acronyms, and Abbreviations

GPS: Global Positioning System   
ETA: Estimated Time of Arrival   
API: Application Programming Interface  
UI: User Interface

## 1.4 References

This section provides a list of resources and materials consulted during the development of the mobile bus tracking application:

### 1.4.1 Firebase Documentation
Firebase provides backend services for real-time database and user authentication. This documentation was used to configure and integrate Firebase into the app.
Link: https://firebase.google.com/docs

### 1.4.2 Google Maps API Documentation
The Google Maps API was used to display maps and enable navigation features in the application. This resource guided the integration of mapping services.
Link: https://developers.google.com/maps/documentation

### 1.4.3 Flask Documentation
Flask was utilized for creating and managing the backend services. This documentation provided guidance on Flask setup and usage.
Link: https://flask.palletsprojects.com/en/latest/

### 1.4.4 PHP Documentation
PHP was employed for server-side scripting and backend development. This reference helped with coding and troubleshooting.
Link: https://www.php.net/docs.php

### 1.4.5 Stack Overflow and Community Forums
Online technical forums were occasionally referred to for troubleshooting and finding solutions to implementation challenges.
Link: https://stackoverflow.com

### 1.4.6 Course Materials and Tutorials
Tutorials, course materials, and other online resources on Firebase, Google Maps API, Flask, and PHP contributed to the understanding and successful implementation of project features.

 PHP:
https://www.youtube.com/playlist?list=PLPRLhfAOx8T5lJGqAJEKeH3CmMroFXt8Y

 GOOGLE MAP API : 
 
https://www.youtube.com/watch?v=M7cOmiSly3Q

 FIREBASE: 
 
https://www.youtube.com/watch?v=FYcYVkTowRs&t=14s

## 1.5 Overview

This document outlines the functionality, features, user roles, and non-functional requirements of the **Bus Tracking System**. The system provides real-time bus tracking, ETAs.It also includes an administrator dashboard for managing bus fleets and drivers. The key users include commuters, bus drivers, and administrators, each with tailored interfaces. The non-functional requirements focus on system performance, scalability, usability, and security to ensure a smooth and reliable user experience.

# 2\. Overall Description

## 2.1 Product Perspective

The Bus Tracking System is designed to integrate seamlessly into the existing public transportation ecosystem.It will enhance the overall efficiency of bus operations by providing real-time location data, and scheduling information. The system will interact with a variety of existing hardware and software systems,including GPS tracking devices installed on buses, mobile and web applications for commuters, and administrative systems used by transportation authorities.

## 2.2 Product Features

1. #### **User Interface**

* Enabling users to Track the live location of buses using GPS and updating the location in real-time and displaying their current position on a map.  
* Enables users to create and manage personal accounts.  
* Allows saving of the most frequented places.  
* Provides real-time ETA for buses at designated stops.  
* Continuously updates the ETA based on live traffic conditions.


#### **2\. Driver Interface**

* Provides bus drivers with real-time route information, including live traffic updates, and schedule adjustments.  
* Displays the current route, next stops, and updated ETAs for the driver

#### **3\. Administrator Dashboard**

* Administrators can view all buses in the fleet on a map, showing their real-time locations, routes  
* Administrators can upload, edit, and manage bus schedules directly from the dashboard.  
* the ability to add new drivers and assign them to specific buses.

## 2.3 User Classes and Characteristics

#### **1\. Commuters (General Users)**

* **Description**: These are the end-users who use the system to track buses, view bus schedules.  
* **Technical Expertise**: Basic to moderate tech skills, familiar with using mobile apps .  
* **Access Rights**:  
  * Can view real-time bus locations and ETAs.  
  * Can search bus routes and schedules.  
  * No administrative control over the system.  
  * Can save their most most frequented places.

#### **2\. Bus Drivers**

* **Description**: Bus drivers interact with the system through a dedicated interface, receiving real-time updates on routes, traffic, and schedule changes.  
* **Technical Expertise**: Basic familiarity with driver apps or onboard devices.  
* **Access Rights**:  
  * Can view assigned routes and stops.  
  * Receive notifications on route changes or delays.  
  * Can communicate with administrators through the system.  
  * No access to commuter data or administrative functions.

#### **3\. Administrators (Fleet Managers)**

* **Description**: These are the users responsible for managing bus operations, including monitoring the fleet, managing schedules, and assigning routes to drivers.  
* **Technical Expertise**: Moderate to advanced technical skills; capable of using the Administrator Dashboard and handling multiple tools and features.  
* **Access Rights**:  
  * Full access to bus tracking and fleet management features.  
  * Can add, update, and manage bus schedules and routes.  
  * Can assign and monitor drivers, adjust routes, and send notifications.

#### **4\. System Administrators**

* **Description**: These users handle the technical backend of the system, managing server infrastructure, security, and system maintenance.  
* **Technical Expertise**: Advanced technical knowledge in system administration, server management, and security protocols.  
* **Access Rights**:  
  * Full administrative control over the system infrastructure.  
  * Responsible for ensuring system availability, scalability, and security.  
  * Can manage user permissions, perform system updates, and troubleshoot technical issues.

## 2.4 Operating Environment

#### **1\. Client-Side Environment**

* **Commuters (General Users)**:  
  * **Devices**: Smartphones and tablets.  
  * **Operating Systems**:  
    * **Android**: Version 8.0 (Oreo) or later.  
  * **Network**: Requires mobile network access (3G, 4G, or 5G) or Wi-Fi for real-time bus tracking, and schedule updates.

**2 Bus Drivers**:

* **Devices**: Mobile devices such as smartphones or tablets provided by the transit authority.  
* **Operating Systems**: Android (v8.0 or later)   
* **Network**: Mobile network (3G, 4G, 5G) or Wi-Fi for real-time updates on routes, schedules, and any changes from administrators.

**3.Administrators (Fleet Managers)**:

* **Devices**: Mobile tablets or smartphones.  
* **Operating Systems**: Android (v8.0 or later)   
* **Network**: Requires stable 4G/5G or Wi-Fi connection for accessing the Administrator Dashboard through a mobile app.

#### **4.GPS and Tracking Systems**

* **GPS Integration**: The app will integrate with GPS services on mobile devices to provide real-time tracking of buses.  
* **Network**: GPS data is transmitted through mobile networks (3G, 4G, 5G) to the backend, which processes the information and updates it in real time on the app for users and administrators.

#### **5\. Network Requirements**

* **Mobile Networks**:  
  * The app will depend on stable 3G, 4G, or 5G networks for real-time updates, particularly for commuter tracking and driver navigation.  
* **Wi-Fi**:  
  * Users can also connect via Wi-Fi when available, although the app is primarily designed for use on mobile networks, especially for commuters on the go.

## 2.6 Assumptions and Dependencies

* The accuracy of the bus location is dependent on the availability of reliable GPS data.  
* The application will depend on third-party map services and APIs (such as Google Maps API or OpenStreetMap API) for the map view, real-time data visualization, and bus location tracking.  
* The system will utilize an external **GPS tracking API** to retrieve real-time bus location data.  
* The application may require integration with a public transportation API (if available) for route and bus schedule data to complement real-time tracking.

# 3\. System Features

## 3.1 Feature 1: Bus Passenger Interface

* **Description**: The bus passenger interface allows users to track buses in real-time, search for routes, and save favorite locations.  
* **Inputs**:  
  * User's GPS location (auto-detected by the app).  
  * Destination entered into the search bar.  
* **Processing**:  
  * Retrieves real-time location of buses going to the selected destination.  
  * Finds the nearest bus stop based on the user's location.  
* **Outputs**:  
  * Displays available buses on a map, along with their real-time locations.  
  * Shows the nearest bus stop, along with estimated time of arrival (if available).  
* **Buttons and Functions**:  
  * **Search Bar**: Allows the user to input their destination. After entering the destination, the app suggests the buses that can reach the desired location.  
  * **Nearest Station Button**: Displays the nearest bus stop based on the user’s current GPS location.  
  * **Saved Places Button**: Displays a list of favorite places that the user has saved for easy access.  
  * **Map**: Shows the user’s current location and the real-time position of the buses.  
  * **Settings Button**: Provides access to account management (update username, password, personal info).  
* **Dependencies**:  
  * GPS tracking APIs for real-time location.  
  * Mapping API like Google Maps or OpenStreetMap.

## 3.2 Feature 2: Bus Driver Interface

* **Description**: The bus driver interface helps drivers view their schedule and the stops they need to pass in real-time.  
* **Inputs**:  
  * GPS location of the bus.  
  * Pre-assigned schedule from the agency (showing stops and times).  
* **Processing**:  
  * Tracks the driver’s current position and upcoming stops.  
  * Sends reminders to the driver for upcoming stops.  
* **Outputs**:  
  * Displays the route map with upcoming stops and the bus’s current location.  
  * Shows the schedule for the day.  
* **Buttons and Functions**:  
  * **Map**: Shows the driver's location in real-time, with marked stops and routes.  
  * **Schedule Button**: Allows the driver to view their assigned schedule, including stops and times.  
  * **Inbox Button** (Optional): Provides communication between the driver and the agency (could be added later if implemented).  
  * **Account Button**: Displays driver's account details (e.g., name, assigned route).  
  * **Settings Button**: Placeholder, no additional settings at the moment.  
* **Dependencies**:  
  * GPS tracking to determine the driver's position.  
  * Pre-assigned schedule from the bus agency.

## 3.3 Feature 3: Bus Agency Interface

* **Description**: The agency interface enables the agency to manage bus drivers and their schedules. It also allows them to track the location of all buses in real-time.  
* **Inputs**:  
  * Information on each bus driver (e.g., name, route, availability).  
  * Data about each bus’s current location (via GPS).  
  * Schedules assigned to bus drivers.  
* **Processing**:  
  * Tracks all buses in real-time on a map.  
  * Allows for modification of driver schedules and routes.  
* **Outputs**:  
  * Shows the location of all buses on a map.  
  * Provides a list of all drivers, with options to add or delete drivers.  
  * Displays the schedules assigned to each bus driver.  
* **Buttons and Functions**:  
  * **Map**: Shows the real-time locations of all buses, allowing the agency to track their fleet.  
  * **Driver Management Button**: Provides a database of bus drivers where the agency can add, remove, or update driver details.  
  * **Schedule Button**: Allows the agency to assign or update schedules for bus drivers, showing each driver’s current or future assignments.  
  * **Settings Button**: Gives the agency access to account settings and other configurations.  
  * **Settings Button**: Allows the agency to manage their account details and fleet settings.  
* **Dependencies**:  
  * GPS tracking APIs to monitor the buses.  
  * Database system for driver information and schedules.

# 4\. External Interface Requirements

## 4.1 User Interfaces

**Commuters (General Users)**:

* **Mobile App Interface**: Simple, intuitive design focused on real-time tracking, route search, bus stop locations, and notifications.  
  * Home screen shows nearby buses and ETA.  
  * Menu for saved routes.  
  * Map-based view with real-time bus tracking.  
* **Key Features**:  
  * Real-time bus tracking.  
  * User-friendly map navigation for bus routes and stops.

**Bus Drivers**:

* **Driver App Interface**: A dedicated interface for drivers with navigation assistance and route management.  
  * Dashboard shows assigned routes, stops, and real-time updates.  
  * Route changes and notifications displayed for the driver in real-time.  
  * Easy-to-access buttons for communication with dispatch or fleet managers.

**Administrators (Fleet Managers)**:

* **Mobile Admin Dashboard**: Provides a more complex interface for managing bus fleets.  
  * Overview of buses, drivers, and routes in real time.  
  * Ability to assign routes, monitor bus status.  
  * Notifications and alerts sent to drivers or system users when needed.

## 4.2 Hardware Interfaces

The **Bus Tracking System** interfaces with various hardware components, primarily focusing on mobile devices and GPS equipment.

* **Mobile Devices**:  
  * The system relies on mobile hardware such as smartphones and tablets with GPS capabilities to track buses (drivers) and provide real-time updates (commuters).  
  * The app should support mobile devices running Android 8.0+.  
* **GPS Devices**:  
  * The system interfaces with onboard GPS hardware installed on buses. This hardware transmits real-time location data to the server for tracking purposes.  
  * The GPS equipment may be standalone or integrated into the driver’s mobile device.

## 4.3 Software Interfaces

The system interacts with several third-party software components and APIs to perform its core functionalities.

* **Third-Party APIs**:  
  * **Google Maps API (or equivalent)**: Used for map rendering, bus route visualization, and real-time location tracking.  
  * **GPS APIs**: To integrate location data from the device’s or bus’s GPS system.  
* **Database Systems**:  
  * The system interfaces with a cloud-based relational database ( MySQL or PostgreSQL) to store data such as bus schedules, user profiles, routes, and driver information.  
* **Authentication Services**:  
  * OAuth or JWT-based authentication is integrated for secure login and user account management.

## 4.4 Communication Interfaces

The system relies on various communication protocols and network connectivity to operate efficiently and provide real-time services.

* **Mobile Networks**:  
  * The application depends on 3G, 4G, and 5G networks for data transmission, ensuring real-time communication between the client (mobile devices) and the server (backend services).  
* **Wi-Fi**:  
  * Wi-Fi is supported as an additional communication option, particularly for users accessing the system in stationary environments (home or work).  
* **Communication Protocols**:  
  * **HTTP/HTTPS**: Secure communication between the client application and the server, ensuring encrypted data transmission.  
  * **WebSockets** (optional): Used for real-time communication, such as live bus tracking updates and push notifications.

# 5\. Non-Functional Requirements

## 5.1 Performance Requirements

 How fast should data update (e.g., refresh rate for live tracking)? (We don't know)

## 5.2 Security Requirements

Any security measures (e.g., data encryption, HTTPS). (We don't know)

## 5.3 Usability Requirements

The app should be intuitive and easy to use for all user groups, requiring minimal training or instructions.

## 5.4 Reliability Requirements

Uptime goals, expected failure rates.

## 5.5 Maintainability and Support Requirements

Should the app be easy to update? Any logging or monitoring needs?
