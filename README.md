BZGFormViewController
=====================

*Started this mostly as an experiment in cloning the Twitter-for-iOS signup form. 
When I added [JVFloatLabeledTextField](https://github.com/jverdi/JVFloatLabeledTextField) it reached an unprecedented level of hotness, so I made the repo private.
If we think this is worth open sourcing later, I'd be down for re-namespacing everything and adding it to Venmo's public github.*

BZGFormViewController is a lightweight UITableViewController subclass inspired by the dynamic form validation UX in Twitter's iOS app.

![alt tag](https://raw.github.com/benzguo/BZGFormViewController/master/Screenshots/1.png)

### Classes

+ **BZGFormFieldCell**: A `UITableViewCell` subclass for displaying form fields.
+ **BZGFloatingPlaceholderFormFieldCell**: A subclass of `BZGFormFieldCell` with a [JVFloatLabeledTextField](https://github.com/jverdi/JVFloatLabeledTextField)
+ **BZGFormFieldInfoCell**: A `UITableViewCell` subclass for displaying form field info.
+ **BZGFormViewController**: A `UITableViewController` subclass that handles the display of form field cells and their corresponding form info cells.

### Installation

If you're using cocoapods, just add ```pod 'BZGFormViewController'``` to your Podfile.
Otherwise, add the contents of ```BZGFormViewController``` to your project.

### Example project

For an example of how to subclass `BZGFormViewController`, check out the ```SignupViewController``` in the included project.
For email validation, you'll have to sign up for Mailgun and add your public API key to ```SignupViewController.m```.
When you're ready, ```pod install```, open the workspace, and run. All unit tests should be run from the example project.

### Links

[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)

[Mailgun email validation](http://blog.mailgun.com/post/free-email-validation-api-for-web-forms/)

[BZGMailgunEmailValidation](https://github.com/benzguo/BZGMailgunEmailValidation)


