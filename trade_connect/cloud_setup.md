For my TradeConnect application, I chose Google Firebase as my cloud service. I chose Firebase because it works well with Flutter applications and provides tools for user authentication and cloud database storage. Firebase also makes it easier to manage user accounts and store information without having to build my own backend server.

The two main Firebase services used in TradeConnect are:

Firebase Authentication which handles user registration, logging in and logging out.

Cloud Firestore which provides cloud database storage for user information and trading activity.

I chose Firebase because it is easy to connect with Flutter and allows the application to grow as more users join.


2. Setup Steps

The following steps were used to connect Firebase to my TradeConnect application:

Created a new project in the Firebase Console.

Added my Flutter application to the Firebase project.

Configured Firebase for the Android application using FlutterFire.

Added the Firebase packages to the project's pubspec.yaml file:

firebase_core

firebase_auth

cloud_firestore

Initialized Firebase in the application's main.dart file using Firebase.initializeApp().

Created an authentication service to handle registering, logging in, and logging out users.

Created an authentication gate (AuthGate) to check whether a user is logged in before allowing access to the main application.

Created a Cloud Firestore database through the Firebase Console.

Configured Firestore security rules to restrict access to authenticated users and their own data.


3. How User Accounts Work

TradeConnect uses Firebase Authentication to manage user accounts.

Users can create an account using their email address and password. Firebase Authentication securely handles the registration process and stores the account credentials.

When a user logs in, Firebase verifies their credentials and provides their account with a unique User ID (UID).

The application uses an AuthGate to check the user's authentication status. If the user is logged in, they can access the main TradeConnect application. If they are not logged in, they are directed to the login screen.

Users can also log out of their accounts, which returns them to the login screen.


4. Where and How User Data Is Stored

TradeConnect uses Cloud Firestore to store user information and trading activity in the cloud.

Each user has their own collection based on their Firebase Authentication UID.

Each trade document can contain information such as:

Stock or market symbol

Trade direction (Long or Short)

Trade quantity

Date and time the trade was created

This organization keeps each user's trading activity separate. It also allows the application to retrieve the correct user's information after they log back into their account.


5. How Access Rules Keep User Data Private

TradeConnect uses Firebase Cloud Firestore Security Rules to protect user information.

The rules require users to be authenticated before accessing the database. They also compare the Firebase Authentication UID with the user ID in the database path.

For example, a user with UID User_UID_123 can only access information stored under their own user document.

The security rules use the following checks:

allow read, write: if request.auth != null
                   && request.auth.uid == userId;
