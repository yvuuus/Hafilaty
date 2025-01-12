# Software Requirements Specification for <Hafilaty>

## 1. Introduction

### 1.1 Purpose
The purpose of this SRS is to outline the functional and non-functional requirements for the development of the Hafilaty Mobile Bus Tracking App. This application helps bus passengers by providing real-time tracking of bus locations to reduce waiting times and improve convenience. The intended audience includes bus passengers, bus drivers, and administrators.


### 1.2 Product Scope
The Hafilaty app is a bus tracking application designed to improve the commuting experience for passengers and enhance efficiency for bus agencies. The app aims to provide real-time tracking, route information, and communication between passengers, drivers, and the agency.

Key features include:

- For Passengers: Tracking buses in real-time, viewing routes, selecting destinations and pickup locations, managing user accounts (registration, login, logout, and password changes), and viewing their current location on the map.
- For Drivers: Updating trip statuses, confirming stops, viewing schedules, and managing driver accounts (login and logout).
- For Bus Agencies: Managing bus schedules, assigning routes, and maintaining driver accounts.
The app integrates with Google Maps for navigation and utilizes Firebase for real-time database updates to ensure data consistency and reliability.

This project aligns with the broader goal of leveraging technology to optimize public transportation, reduce wait times, and enhance the commuting experience for users.



### 1.3 Definitions, Acronyms, and Abbreviations
- **GPS**: Global Positioning System
- **ETA**: Estimated Time of Arrival
- **API**: Application Programming Interface
- **UI**: User Interface

### 1.4 References
This section provides a list of resources and materials consulted during the development of the mobile bus tracking application:

#### 1.4.1 Firebase Documentation
- Firebase provides backend services for real-time database and user authentication. This documentation was used to configure and integrate Firebase into the app.  
  Link: [Firebase Documentation](https://firebase.google.com/docs)

#### 1.4.2 Google Maps API Documentation
- The Google Maps API was used to display maps and enable navigation features in the application. This resource guided the integration of mapping services.  
  Link: [Google Maps API Documentation](https://developers.google.com/maps/documentation)

#### 1.4.3 Flask Documentation
- Flask was utilized for creating and managing the backend services. This documentation provided guidance on Flask setup and usage.  
  Link: [Flask Documentation](https://flask.palletsprojects.com/en/latest/)

#### 1.4.4 PHP Documentation
- PHP was employed for server-side scripting and backend development. This reference helped with coding and troubleshooting.  
  Link: [PHP Documentation](https://www.php.net/docs.php)

#### 1.4.5 Stack Overflow and Community Forums
- Online technical forums were occasionally referred to for troubleshooting and finding solutions to implementation challenges.  
  Link: [Stack Overflow](https://stackoverflow.com)

#### 1.4.6 Course Materials and Tutorials
- Tutorials, course materials, and other online resources on Firebase, Google Maps API, Flask, and PHP contributed to the understanding and successful implementation of project features.

  **PHP**:  
  [YouTube PHP Playlist](https://www.youtube.com/playlist?list=PLPRLhfAOx8T5lJGqAJEKeH3CmMroFXt8Y)

  **Google Map API**:  
  [YouTube Google Map API Tutorial](https://www.youtube.com/watch?v=M7cOmiSly3Q)

  **Firebase**:  
  [YouTube Firebase Tutorial](https://www.youtube.com/watch?v=FYcYVkTowRs&t=14s)

### 1.5 Overview
This document outlines the functionality, features, user roles, and non-functional requirements of the **Bus Tracking System**. The system provides real-time bus tracking and ETAs. It also includes an administrator dashboard for managing bus fleets and drivers. The key users include commuters, bus drivers, and administrators, each with tailored interfaces. The non-functional requirements focus on system performance, scalability, usability, and security to ensure a smooth and reliable user experience.

## 2. Overall Description

### 2.1 Product Perspective
The Bus Tracking System is designed to integrate seamlessly into the existing public transportation ecosystem. It will enhance the overall efficiency of bus operations by providing real-time location data, and scheduling information. The system will interact with a variety of existing hardware and software systems, including GPS tracking devices installed on buses, mobile and web applications for commuters, and administrative systems used by transportation authorities.

### 2.2 Product Features

#### **User Interface**

- Enable users to track the live location of buses using GPS, updating the location in real-time, and displaying their current position on a map with the estimated arrival time from the pickup location to the destination.
- Enable users to create and manage personal accounts.
- Provide real-time ETA for buses at designated stops.
- Continuously update the ETA based on live traffic conditions.

#### **Driver Interface**

- Enable  to  manage personal accounts.
- Provide bus drivers with real-time route information, including live traffic updates and schedule adjustments.
- Display the current route, next stops, and updated ETAs for the driver.

#### **Administrator Dashboard**

- Allow administrators to view all buses in the fleet on a map, showing their real-time locations and routes.
- Enable administrators to upload, edit, and manage bus schedules directly from the dashboard.
- Allow the ability to add new drivers and assign them to specific buses.

### 2.3 User Classes and Characteristics

#### **Commuters (General Users)**

- **Description**: These are the end-users who use the system to track buses and view bus schedules.
- **Technical Expertise**: Basic to moderate tech skills, familiar with using mobile apps.
- **Access Rights**:
  - Can view real-time bus locations and ETAs.
  - Can search bus routes and schedules.
  - No administrative control over the system.

#### **Bus Drivers**

- **Description**: Bus drivers interact with the system through a dedicated interface, receiving real-time updates on routes, traffic, and schedule changes.
- **Technical Expertise**: Basic familiarity with driver apps or onboard devices.
- **Access Rights**:
  - Can view assigned routes and stops.
  - Receive notifications on route changes or delays.
  - Can communicate with administrators through the system.
  - No access to commuter data or administrative functions.

#### **Administrators (Fleet Managers)**

- **Description**: These are the users responsible for managing bus operations, including monitoring the fleet, managing schedules, and assigning routes to drivers.
- **Technical Expertise**: Moderate to advanced technical skills; capable of using the Administrator Dashboard and handling multiple tools and features.
- **Access Rights**:
  - Full access to bus tracking and fleet management features.
  - Can add, update, and manage bus schedules and routes.
  - Can assign and monitor drivers, adjust routes, and send notifications.

#### **System Administrators**

- **Description**: These users handle the technical backend of the system, managing server infrastructure, security, and system maintenance.
- **Technical Expertise**: Advanced technical knowledge in system administration, server management, and security protocols.
- **Access Rights**:
  - Full administrative control over the system infrastructure.
  - Responsible for ensuring system availability, scalability, and security.
  - Can manage user permissions, perform system updates, and troubleshoot technical issues.

### 2.4 Operating Environment

#### **Client-Side Environment**

- **Commuters (General Users)**:
  - **Devices**: Smartphones and tablets.
  - **Operating Systems**:
    - **Android**: Version 8.0 (Oreo) or later.
  - **Network**: Requires mobile network access (3G, 4G, or 5G) or Wi-Fi for real-time bus tracking and schedule updates.

- **Bus Drivers**:
  - **Devices**: Mobile devices such as smartphones or tablets provided by the transit authority.
  - **Operating Systems**: Android (version 8.0 or later).
  - **Network**: Mobile network (3G, 4G, 5G) or Wi-Fi for real-time updates on routes, schedules, and any changes from administrators.

- **Administrators (Fleet Managers)**:
  - **Devices**: Laptops or computers.
  - **Operating Systems**: Windows 10 or later.
  - **Network**: Requires stable 4G/5G or Wi-Fi connection for accessing the Administrator Dashboard through a web browser.

#### **GPS and Tracking Systems**

- **GPS Integration**: The app will integrate with GPS services on mobile devices to provide real-time tracking of buses.
- **Network**: GPS data is transmitted through mobile networks (3G, 4G, 5G) to the backend, which processes the information and updates it in real-time on the app for users and administrators.

#### **Network Requirements**

- **Mobile Networks**:
  - The app will depend on stable 3G, 4G, or 5G networks for real-time updates, particularly for commuter tracking and driver navigation.
- **Wi-Fi**:
  - Users can also connect via Wi-Fi when available, although the app is primarily designed for use on mobile networks, especially for commuters on the go.

### 2.5 Assumptions and Dependencies

- The accuracy of the bus location is dependent on the availability of reliable GPS data.
- The application will depend on third-party map services and APIs (such as Google Maps API or OpenStreetMap API) for the map view, real-time data visualization, and bus location tracking.
- The system will utilize an external **GPS tracking API** to retrieve real-time bus location data.
- The application may require integration with a public transportation API (if available) for route and bus schedule data to complement real-time tracking.

## 3. System Features

### 3.1 Feature: User Authentication

#### 3.1.1 **User Login**
**Description**: The user will be able to log into their account using their credentials (email and password).
- **Functional Requirements**:
  - Users must enter valid credentials to log in.
  - The system will authenticate using Firebase Authentication.
  - If login is successful, users are redirected to the home screen.

#### 3.1.2 **User Logout**
**Description**: The user will be able to log out of their account from the app.
- **Functional Requirements**:
  - Users can log out from the app, which clears their session and returns them to the login screen.

#### 3.1.3 **User Registration**
**Description**: New users will be able to create an account by providing their email and creating a password.
- **Functional Requirements**:
  - Users need to provide a valid email and password to register.
  - A confirmation email will be sent for account verification.

#### 3.1.4 **Password Reset**
**Description**: Users can reset their passwords if they forget them.
- **Functional Requirements**:
  - Users must provide their registered email.
  - A password reset link will be sent to the email provided.

### 3.2 Feature: Driver Authentication

#### 3.2.1 **Driver Login**
**Description**: The bus driver will be able to log into their account using their credentials (email and password).
- **Functional Requirements**:
  - Drivers must enter valid credentials to log in.
  - The system will authenticate using Firebase Authentication.
  - If login is successful, drivers are redirected to the driver dashboard.

#### 3.2.2 **Driver Logout**
**Description**: The driver will be able to log out of their account from the app.
- **Functional Requirements**:
  - Drivers can log out from the app, which clears their session and returns them to the login screen.

#### 3.2.3 **Driver Registration**
**Description**: New drivers can register by providing necessary credentials.
- **Functional Requirements**:
  - Drivers need to provide their email and password to register.
  - Admin will verify their credentials before granting full access.

### 3.3 Feature: Bus Tracking
**Description**: Allows passengers to track the live location of buses in real-time on a map.

**Functional Requirements**:
- **Real-Time Location Updates**:
  - The app fetches the bus’s current GPS coordinates every 5 seconds. The map updates automatically to display the new bus location.

- **Tracking on the Map**:
  - When a user taps on a bus icon, a popup will display additional information about the bus, such as the route, next stop, and ETA.

- **Estimated Time of Arrival (ETA)**:
  - The ETA is calculated dynamically based on real-time traffic and bus location data. The app will refresh the ETA every 30 seconds or whenever a significant change in the bus’s position is detected.

- **Notifications**:
  - Push notifications will be sent when a bus is within 5 minutes of the selected stop. If there are any delays exceeding 10 minutes, the app will send a delay notification.

- **User Interaction with the Map**:
  - Users can zoom in/out and move the map to see other buses. Multiple bus routes can be displayed at once, with each bus color-coded based on its status (on-time, delayed).

## 4. External Interface Requirements

### 4.1 User Interfaces

#### 4.1.1 **Commuter Interface**
- **Home Screen**: Displaying a map with real-time bus locations, search bar for routes, and user profile access.
- **Bus Route Search**: Allows users to search and view details of specific bus routes.
- **Bus Details Popup**: Shows detailed information about a selected bus (route, ETA, next stop).
- **Profile Screen**: Allows users to view and edit their personal information and settings.

#### 4.1.2 **Driver Interface**
- **Dashboard**: Shows the driver's current route, next stops, and real-time traffic updates.
- **Route Updates**: Displays notifications about route changes or delays.
- **Communication**: Allows drivers to communicate with administrators for support or updates.

#### 4.1.3 **Administrator Dashboard**
- **Fleet Map**: Displays all buses in the fleet with real-time locations.
- **Schedule Management**: Interface for uploading, editing, and managing bus schedules.
- **Driver Management**: Allows administrators to add new drivers, assign buses, and view driver statuses.

### 4.2 Hardware Interfaces
- **GPS Devices**: Integration with GPS devices installed on buses to provide location data.
- **Mobile Devices**: Smartphones and tablets for commuters and drivers.

### 4.3 Software Interfaces
- **Firebase**: For real-time database updates and user authentication.
- **Google Maps API**: For displaying maps, navigation features, and real-time traffic data.
- **Backend Services**: Developed using Flask and PHP for handling server-side logic and database interactions.

### 4.4 Communications Interfaces
- **Mobile Networks**: 3G, 4G, 5G for real-time updates and communication.
- **Wi-Fi**: For data transmission when available.

## 5. Non-Functional Requirements

### 5.1 Performance Requirements
- **Response Time**: The app should respond to user actions within 2 seconds.
- **Update Frequency**: Real-time bus locations should be updated every 5 seconds.
- **Scalability**: The system should handle up to 10,000 concurrent users without performance degradation.

### 5.2 Reliability Requirements
- **Uptime**: The system should have an uptime of 99.9%, excluding scheduled maintenance.
- **Error Handling**: The system should gracefully handle errors and provide meaningful messages to users.

### 5.3 Security Requirements
- **Data Encryption**: All data transmitted between the app and server should be encrypted using SSL/TLS.
- **Authentication**: Secure user authentication using Firebase Authentication.
- **Access Control**: Role-based access control to ensure only authorized users can access specific features.

### 5.4 Usability Requirements
- **User-Friendly Interface**: The app should have an intuitive and easy-to-navigate interface.
- **Accessibility**: The app should be accessible to users with disabilities, following WCAG 2.1 guidelines.

### 5.5 Maintainability Requirements
- **Modular Design**: The system should be designed in a modular way to facilitate easy updates and maintenance.
- **Documentation**: Comprehensive documentation should be provided for developers and administrators.

### 5.6 Portability Requirements
- **Platform Support**: The app should be compatible with Android (version 8.0 or later) and accessible via web browsers for administrators.

## 6. Other Requirements

### 6.1 Legal Requirements
- **Data Privacy**: Compliance with data privacy regulations such as GDPR.

### 6.2 Ethical Requirements
- **User Consent**: Obtain user consent for tracking and data collection.

### 6.3 Environmental Requirements
- **Energy Efficiency**: The app should minimize battery consumption on mobile devices.

---

This Software Requirements Specification (SRS) document provides a comprehensive guide for the development of the Hafilaty Mobile Bus Tracking App. It covers all aspects from user authentication to real-time bus tracking and administrative functionalities, ensuring a robust and user-friendly application.
