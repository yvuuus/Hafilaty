# Software Requirements Specification (SRS)

## 1. Introduction
This document provides a detailed description of the software requirements for the Hafilaty Mobile Bus Tracking App, aimed at providing real-time bus tracking and management features for both passengers and bus drivers.

### 1.1 Purpose
The purpose of this SRS is to outline the functional and non-functional requirements for the development of the Hafilaty Mobile Bus Tracking App. This application helps bus passengers by providing real-time tracking of bus locations to reduce waiting times and improve convenience. The intended audience is the bus passengers.

### 1.2 Scope
The Hafilaty app will include features for:

- Passengers to track buses, view routes, choose destination, choose pickup location, login, logout, register, change password, view their location on the map, and track the driver.
- Bus drivers to update statuses, confirm stops, and view schedules, login, logout.
- Integration with Google Maps for navigation.
- Firebase for real-time database updates.

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

  PHP:  
  [YouTube PHP Playlist](https://www.youtube.com/playlist?list=PLPRLhfAOx8T5lJGqAJEKeH3CmMroFXt8Y)

  GOOGLE MAP API:  
  [YouTube Google Map API Tutorial](https://www.youtube.com/watch?v=M7cOmiSly3Q)

  FIREBASE:  
  [YouTube Firebase Tutorial](https://www.youtube.com/watch?v=FYcYVkTowRs&t=14s)

### 1.5 Overview
This document outlines the functionality, features, user roles, and non-functional requirements of the **Bus Tracking System**. The system provides real-time bus tracking, ETAs. It also includes an administrator dashboard for managing bus fleets and drivers. The key users include commuters, bus drivers, and administrators, each with tailored interfaces. The non-functional requirements focus on system performance, scalability, usability, and security to ensure a smooth and reliable user experience.

## 2. Overall Description

### 2.1 Product Perspective
The Bus Tracking System is designed to integrate seamlessly into the existing public transportation ecosystem. It will enhance the overall efficiency of bus operations by providing real-time location data, and scheduling information. The system will interact with a variety of existing hardware and software systems, including GPS tracking devices installed on buses, mobile and web applications for commuters, and administrative systems used by transportation authorities.

### 2.2 Product Features

#### **User Interface**

- Enabling users to Track the live location of buses using GPS and updating the location in real-time and displaying their current position on a map and the estimated arrival time from pickup location to destination 
- Enables users to create and manage personal accounts.  
- Allows saving of the most frequented places.  
- Provides real-time ETA for buses at designated stops.  
- Continuously updates the ETA based on live traffic conditions.

#### **Driver Interface**

- Provides bus drivers with real-time route information, including live traffic updates, and schedule adjustments.  
- Displays the current route, next stops, and updated ETAs for the driver.

#### **Administrator Dashboard**

- Administrators can view all buses in the fleet on a map, showing their real-time locations, routes  
- Administrators can upload, edit, and manage bus schedules directly from the dashboard.  
- Ability to add new drivers and assign them to specific buses.

### 2.3 User Classes and Characteristics

#### **Commuters (General Users)**

- **Description**: These are the end-users who use the system to track buses, view bus schedules.  
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
  - **Network**: Requires mobile network access (3G, 4G, or 5G) or Wi-Fi for real-time bus tracking, and schedule updates.

- **Bus Drivers**:
  - **Devices**: Mobile devices such as smartphones or tablets provided by the transit authority.  
  - **Operating Systems**: Android (v8.0 or later).   
  - **Network**: Mobile network (3G, 4G, 5G) or Wi-Fi for real-time updates on routes, schedules, and any changes from administrators.

- **Administrators (Fleet Managers)**:
  - **Devices**: Laptops or computers.  
  - **Operating Systems**: windows 10 or later .   
  - **Network**: Requires stable 4G/5G or Wi-Fi connection for accessing the Administrator Dashboard through a mobile app.

#### **GPS and Tracking Systems**

- **GPS Integration**: The app will integrate with GPS services on mobile devices to provide real-time tracking of buses.  
- **Network**: GPS data is transmitted through mobile networks (3G, 4G, 5G) to the backend, which processes the information and updates it in real time on the app for users and administrators.

#### **Network Requirements**

- **Mobile Networks**:
  - The app will depend on stable 3G, 4G, or 5G networks for real-time updates, particularly for commuter tracking and driver navigation.  
- **Wi-Fi**:
  - Users can also connect via Wi-Fi when available, although the app is primarily designed for use on mobile networks, especially for commuters on the go.

### 2.6 Assumptions and Dependencies

- The accuracy of the bus location is dependent on the availability of reliable GPS data.  
- The application will depend on third-party map services and APIs (such as Google Maps API or OpenStreetMap API) for the map view, real-time data visualization, and bus location tracking.  
- The system will utilize an external **GPS tracking API** to retrieve real-time bus location data.  
- The application may require integration with a public transportation API (if available) for route and bus schedule data to complement real-time tracking.

## 3. System Features

### 3.1 Feature: Bus Tracking

**Description**: Allows passengers to track the live location of buses in real-time on a map.

**Functional Requirements**:
- **Real-Time Location Updates**:  
  The app fetches the bus’s current GPS coordinates every 5 seconds. The map updates automatically to display the new bus location.
  
- **Tracking on the Map**:  
  When a user taps on a bus icon, a popup will display additional information about the bus, such as the route, next stop, and ETA.
  
- **Estimated Time of Arrival (ETA)**:  
  The ETA is calculated dynamically based on real-time traffic and bus location data. The app will refresh the ETA every 30 seconds or whenever a significant change in the bus’s position is detected.

- **Notifications**:  
  Push notifications will be sent when a bus is within 5 minutes of the selected stop. If there are any delays exceeding 10 minutes, the app will send a delay notification.

- **User Interaction with the Map**:  
  Users can zoom in/out and move the map to see other buses. Multiple bus routes can be displayed at once, with each bus color-coded based on its status (on-time, delayed).

---

###
