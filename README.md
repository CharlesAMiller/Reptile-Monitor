# reptile_monitor

## About
This is the mobile application portion of a proof-of-concept system for monitoring reptile enclosures. This monitoring system is my senior project submission for Cal Poly, and was completed during the 2020-2021 academic year. The project was advised by Dr. Theresa Migler and is in partial fulfillment of the requirements for the degree of B.S. .

The repository for the AWS backend of the proejct can be found [here](). The monitoring system's repository can be found [here]().

## Details
The application is based around three primary screens. The first of which serves as the dashboard for the monitored enclosure, displaying: up-to-date sensor data and live video footage from enclosure. The second screen delivers insights to the owner about the enclosure's conditions over time, through the usage of various charts. The third screen allows the user to specify the appropriate range of values for each sensor in the habitat - allowing the user to tailor their monitoring experience to their own animal's needs. These sensor ranges are also used in the AWS backend to send SMS alerts, if any deviations occur.

### Structure

* `lib/api` - Functions that are used to make API requests to the AWS backend and map the results to models.
* `lib/components` - More modular components that may be reused throughout a screen/layout.
* `lib/models` - The internal model representations of the 
* `lib/screens` - The primary screens with which the user interacts with. 
* `lib/main.dart` - The entrypoint of the application.

### Dependencies
This proejct relies on serveral dependencies to perform a number of tasks.
* [Sync Fusion Gauges](https://pub.dev/packages/syncfusion_flutter_gauges) - To display sensor information as gauges.
* [Sync Fusion Charts](https://pub.dev/packages/syncfusion_flutter_charts) - For displaying sensor data over time.
* [AWS Amplify](https://docs.amplify.aws/start/q/integration/flutter/) - For interacting with the AWS backend.

## Getting Started

In order to meaningfully use this repository, you will need to recreate some portion of the AWS cloud backend. Instructions for which can be found [here](). 

This project has only been tested on iOS: particularly on an iPhone SE (2nd Gen) and an emulated iPhone 12. And the below 
instructions are tailored to working with iOS devices.

### Prerequisites:
* Have installed [Flutter]() and performed the necessary taks prescribed by `flutter doctor`

### Setup
1. Clone the repository.
2. From the repo's root directory, run `flutter pub get`
3. From a terminal, navigate to the 'ios' folder and run `pod update`
4. Fill out the details found in the `amplifyconfiguration.example.dart` file. The [Amplify docs](https://docs.amplify.aws/start/getting-started/installation/q/integration/flutter/#install-and-configure-the-amplify-cli) may be useful for this. Once done, rename or copy the file to `amplifyconfiguration.dart`
5. Launch XCode and use it to open the Runner found in `ios/`. Build and run the project.
