# VoipTwilio
Voip Twilio is a IOS Swift demo application to send and receive Voip calls with Twilio Voip Service Provider.

Run the application and change easily the constants for Twilio connectivity:
- username to identify the client : name of the current client. You can call a client "john" if you want that any instance call you with twilio identificator "client:john"
- twilio capability token url : web url of twilio deamon
- TwiML App Sid : sid your app in Twilio account
- Voip destination number: the number to call

![Screen](screen.png?raw=true "Screen")


This application is based on SwiftPhone project : https://github.com/devinrader/SwiftPhone
SwiftPhone is an implementation in Swift of the BasicPhone example application created by Twilio.
