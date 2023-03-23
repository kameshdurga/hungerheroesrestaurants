# hungerheroesrestaurants
Repo for hunger heroes restuarants service

## Introduction
This document provides the overview of hunger heroes restaurant mobile application developer guide. The goal of this application is to allow restaurant users to onboard their restaurant into Hunger heroes, menu items, etc., and to allow restaurant users to view and manage orders.

## Setup and installation
Install the following software:

### Xcode for Mac or iOS systems:
Go to the Mac App and install https://apps.apple.com/us/app/xcode/id497799835?mt=12

### Flutter:
Download the latest stable release of Flutter from the official website at https://flutter.dev/docs/get-started/install.
Follow the instructions.
Run flutter doctor in your terminal to verify that your Flutter installation is working correctly.

### Amplify:
Install the Amplify CLI by running the following command in your terminal: npm install -g @aws-amplify/cli.
Configure your Amplify CLI by running amplify configure. Follow the prompts to set up your AWS account credentials and region.
Once the CLI is configured, you can create a new Amplify project by running amplify init in your project directory.

### iOS Simulator for Mac:
Open Xcode and navigate to Xcode > Preferences in the menu bar.
Click on the "Components" tab and select the version of iOS Simulator you want to use.
Wait for the download and installation to complete.

### Visual Studio Code:
Download the latest stable release of Visual Studio Code from the official website at https://code.visualstudio.com/download.
Install the Flutter extension for Visual Studio Code by clicking on the extensions icon in the left sidebar, searching for "Flutter", and clicking on the "Install" button.
Install the Amplify Flutter extension for Visual Studio Code by clicking on the extensions icon in the left sidebar, searching for "Amplify Flutter", and clicking on the "Install" button.

## Technologies:
Flutter, Amplify, AWS, and lambda.

## System architecture
### UI:
#### Main.dart 
Main file is the starting point of the application.
#### lib/pages:
The screens of the app are located in the lib/pages directory. Each screen is a separate file that contains the code to display the user interface and handle user input. The screens are organized in a logical way to make it easy for developers to navigate and understand the codebase.

#### lib/models: 
Directory contains the data models for the app, which correspond to the Amplify models used in the backend. These models define the structure and properties of the data used by the app and are used to validate and manipulate data before it is sent to the backend or displayed on the user interface.
Backend:
#### lib/sevices: 
The backend code for the app is located in the lib/services directory. This code communicates with the backend services, such as authentication, data and image storage, using the Amplify library. The backend code is organized in a modular way to make it easy to add or modify functionality without affecting other parts of the app.

## How to run locally:
Run flutter run command from the project root or run as application from visual studio.
Ensure iOS simulator is up and running. I typically use iPhone13.

### Deployment and test:
There is no common Amplify studio to connect for now.

* Sign up for an AWS account if you don't already have one.

* Create an IAM user with the necessary permissions to access the AWS resources used by the Amplify backend, such as the Cognito user pool and API Gateway.

* Configure the AWS CLI on your local machine with the IAM user's access key ID and secret access key.

* Run amplify configure in your terminal or command prompt and follow the prompts to configure the Amplify CLI with your own AWS account credentials.

* In your Flutter project directory, run amplify init and follow the prompts to configure your local Amplify environment with your own AWS account settings.

* Once the local Amplify environment is set up, you can use the Amplify Flutter libraries to connect to the backend services using your own AWS credentials.

In summary, each developer will need to configure their own AWS credentials to connect to the backend services using the Amplify Flutter libraries. The amplifyconfiguration.dart file is included in the repository so that other developers can use it as a reference, but everyone will need to update it with their own AWS account settings in order to connect to the backend services.
