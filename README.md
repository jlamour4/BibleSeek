# BibleSeek

BibleSeek is a cross-platform mobile app designed to help users explore Bible verses by topics, enabling deeper study and meaningful engagement with scripture. The app provides an intuitive way to search for, organize, and vote on Bible verses under specific topics. Users can also share insights, add personal notes, and engage in discussions, fostering a social, interactive experience.

## Features

- **Verse Search by Topic**: Easily search for Bible verses grouped under various topics.
- **Upvoting System**: Vote on verses based on helpfulness and see which ones are the most valued by the community.
- **User Profiles**: Create accounts with details like name, email, username, and profile picture.
- **Favorites Page**: Save and revisit your favorite verses.
- **Commenting & Messaging**: Share insights on verses and communicate with other users.
- **Responsive Design**: Designed with a focus on smooth, engaging user experience for both iOS and Android.
- **Authentication with OAuth**: Secure login using Google, Facebook, or email.

## Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/) - enables cross-platform mobile development.
- **Backend**: Kotlin with [Spring Boot](https://spring.io/projects/spring-boot) - handles data processing and APIs.
- **Database**: MySQL - stores verses, topics, and user information.
- **Authentication**: OAuth for secure user authentication.

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio or Xcode (for mobile development)
- Kotlin and IntelliJ IDEA (for backend development)
- MySQL server

## Installation

### Prerequisites

- Flutter SDK installed
- Android Studio or Xcode (for mobile development)
- Access to the [BibleSeek backend repository](https://github.com/jlamour4/bibleseek_server)

### Setting Up the Frontend

1. **Clone this repository**:
        
    `git clone https://github.com/jlamour4/BibleSeek.git cd bible_seek`
    
2. **Run the Flutter App**:
    
    - Open the project in Visual Studio Code or Android Studio.
    - Connect your Android/iOS device or start an emulator.
    - Run the Flutter app:
        
        `flutter run`
        

For backend and database setup, refer to the [BibleSeek Server repository](https://github.com/jlamour4/bibleseek_server).

### Running on Android Device

To run BibleSeek on a personal Android device, ensure the device is connected, USB debugging is enabled, and Flutter recognizes the device:

`flutter devices flutter run -d <device-id>`

## Future Enhancement Ideas

- **Social Features**: Allow users to share verses and notes within a community.
- **In-app Purchases**: Ad-free experience, premium features.
- **Push Notifications**: Daily verses, reminders, and user messages.
- **Analytics**: Track user interactions for continuous improvement.

## License

This project is open-source under the MIT License - see the LICENSE file for details.

## Contact

For questions or feedback, reach out at jlamour4@gmail.com or connect on [LinkedIn](https://www.linkedin.com/in/jlamour4/)
