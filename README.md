## Disclaimer
The project is currently in the process of a gradual refactoring. We are transitioning from `CoreData` to `SwiftData` due to numerous issues in the previous implementation. Additionally, improvements to the navigation system (utilizing the latest `NavigationStack`) and various UI-related fixes are underway. As a result, some of the information below may not accurately reflect the current state of the application. The `README` will be updated to align with the latest changes once the refactoring reaches a stable and consistent state.

## Overview
The first time you download the app, you are invited through the on-boarding to insert your car's data such as brand, model and fuel type.
Everytime you make a purchase related to your car you can report it by inserting data through a modal sheet, where you can choose between a variety of categories and options, as well as changing the date of the expense. This will allow the system to create statistics in real time, to increase your awareness of your spendings throughout the year. Additionally, we have built a **Document** section to let you save your car documents all in one place and an **Important Numbers** section for saving numbers to reach straight away, in case any unpredictable event occurs. 

Do you find annoying have to remember when you need to overhaul the car? Or if you need to change the tires? I believe so, same as for most of us, that's why we implemented a notification feature!

## Features
- Add your car details
- Add an expense, odometer count, notification reminder
- Add document 
- Add numbers
- Expense view
- Statistics about odometer, vehicle efficiency, and costs
- Modify and change your car details as well as you expenses details


## Frameworks & Technologies
We used **SwiftUI** to create the user interface, **Swift** as main programming language and **CoreData** to save our user's persistent data.
The design pattern we adopted is **MVVM** with different view models for handling CoreData access, the statistics, categories and fuel type...

## Screenshots

<img src="https://user-images.githubusercontent.com/94223094/169893103-be24dbd0-4efd-4f70-8f96-eb3e595ff5ec.gif" width="280" height="570"/>   <img src="https://user-images.githubusercontent.com/94223094/169893079-7e227b06-69ef-42ff-8b46-56c2ecdda6ec.gif" width="280" height="570"/>

## Tuist
To be able to generate the .xcodeproj , install [Tuist](https://docs.tuist.dev/en/guides/quick-start/install-tuist) and run tuist generate in the CLI

## Special thanks & Contributions
This project has been developed during the Apple Developer Academy 2021 in team with [Asya Tealdi](https://github.com/AsyaTea), [Ivan Voloshchuk](https://github.com/IV0000), [Francesco Puzone](https://github.com/morbuen) and [Anna Antonova](https://github.com/Oneanya21). <br>
If you want to contribute to the project, feel free to open issues and PRs.
