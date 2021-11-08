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
Most fire departments are writing their reports manually. Because of that, a lot of information is getting lost in the process. 

On the market there currently is only one product from Rosenbauer, which is called EMEREC, that solves this problem. It is extremely expensive and is only available with their special tablet.

Last year, this team already worked on an application that would solve that and many more issues and we already developed an functioning product with SaferFire-1.0. A lot of the functions of Safer Fire-1.0 are lacking and many key features are still missing. Thats why we decided to redo our whole project.

## Conditions and Constraints
- Intuitiv design
- Save time during the operation missions
- Save paper
- Improve comradeship


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
