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

Mention any external documents, regulations, or standards used in developing the software.

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

* **Live Map View**: Administrators can view all buses in the fleet on a map, showing their real-time locations, routes  
* **Create/Modify Schedules**: Administrators can upload, edit, and manage bus schedules directly from the dashboard.  
* the ability to add new drivers and assigning them to specific buses

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
* The application will depend on third-party map services and APIs (such as Google Maps API) for the map view, real-time data visualization, and bus location tracking.  
* The system will utilize an external **GPS tracking API** to retrieve real-time bus location data.  
* The application may require integration with a public transportation API (if available) for route and bus schedule data to complement real-time tracking.

\---

# 3\. System Features

## 3.1 Feature 1: \[Name\]

\- **Description**: Briefly explain the functionality of the feature.  
\- **Inputs**: List the inputs required for this feature.  
\- **Processing**: Describe how the input will be processed.  
\- **Outputs**: Mention the expected outputs.  
\- **Dependencies**: Any systems or components this feature relies on.

## 3.2 Feature 2: \[Name\]

\- Repeat the structure for each feature in the project.

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

Define performance benchmarks or expectations.

## 5.2 Security Requirements

Mention any security measures (e.g., encryption, access control).

## 5.3 Usability Requirements

Describe the expected ease of use and user experience.

## 5.4 Reliability Requirements

Specify uptime, failure rates, or redundancy.

## 5.5 Maintainability and Support Requirements

Outline maintainability standards and support expectations.

## 5.6 Other Non-Functional Requirements

Any other non-functional requirements (e.g., scalability, portability).
allo test
\---

# 6\. Other Requirements

If applicable, include any additional requirements that don’t fit in the categories above.

