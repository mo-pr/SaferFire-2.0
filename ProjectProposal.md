# Project Proposal
# SaferFire-2.0

### Team
- Alessandro Detta
- Nikos Hagenberger
- Moritz Preining
- Clemens Wolfmayr

## General
* Mobile Application
* Android
* iOS

## Initial Situation

At the moment, the documentation and transfer of information during operations is often very slow and it is not uncommon for important information to be lost. In addition, many fire departments still write incident reports by hand at the scene of the incident and type them into the appropriate system after the incident. 

Due to the aspects mentioned, it would be quite helpful to have a suitable tool that firstly simplifies and secondly accelerates and shortens precisely these processes. 

On the market there currently is only one product from Rosenbauer, which is called EMEREC, that solves this problem. It is extremely expensive and is only available with their special tablet.

## Conditions and Constraints
- specifications for the mission report
- Alarm data from state state firefighters association
- Data privacy regulations (license-plate-query & user-account)

## Project Objectives and System Concepts
- **Complete makeover of the existing Backend**
  - There was no separation between frontend and backend. It would be nearly impossible to implement our new ideas because the     code was written sloppy and there are many bugs.
- **Changing the design to a responsive design**
  - Currently the design is getting warped on devices with an display size, that is not matching our test device
- **Push Notifications**
  - When an alarm goes off, you should get a notification on your smartphone. 
- **Automated Statistics, Heatmaps**
  - The old statistic was only filled with demo data. In the new version we want to save the data from our app and make           statics from them. An example would be a heatmap, where regions with the most operation mission get highlighted.
- **Licence plate query**
  - It should be possible to make a query to the existing state database with our app
- **Rescue sheets**
- **Expanding from Upper Austria to Austria**
  - Currently we are only using the "Fire Department API" for Upper Austria. In the future it should be possible to have access to       all of the departments in Austria.
- **appointment calendar and news display**
  - Possibility to view and enter dates and news of his fire brigade

## Opportunities and Risks

#### Opportunities

With our software we want to help firefighters in austria to save time with the writing of protocols and with the coordination at the place of action. Since such software is currently only available at a relatively high price, we would like to offer an alternative with our app.

#### Risks

The biggest risks in our project are:
* technical difficulties
* App won't be used in real world

## Planning

#### Project Start:
    November 2021  
#### Project End:
    February 2023
    
#### Toolstack
* Flutter
* Dart
* SQL
* PHP
        
#### Milestones
Milestone | Features | Date
----------|----------|------
M1 | Info, Navigation, Protocol | Christmas 2021
M2 | Statistic, Breath-Protection | Half-Year 2022
M3 | Push-Notification, Rescue-Sheets | After Easter 2022
M4 | License-Plate-Query, Heatmap | Full-Year 2022
