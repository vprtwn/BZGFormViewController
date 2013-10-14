BZGFormViewController
=====================

BZGFormViewController is a lightweight UITableViewController subclass inspired by the dynamic form validation UX in Twitter's iOS app.

![alt tag](https://raw.github.com/benzguo/BZGFormViewController/master/Screenshots/1.png)

### Classes

+ **BZGFormFieldCell**: A UITableViewCell subclass for displaying form fields.
+ **BZGFormFieldInfoCell**: A UITableViewCell subclass for displaying form field info.
+ **BZGFormViewController**: A UITableViewController subclass that handles the display of form field cells and their corresponding form info cells.

### Installation

If you're using cocoapods, just add ```pod 'BZGFormViewController'``` to your Podfile. Otherwise, add the contents of ```BZGFormViewController``` to your project.

### Example project

For an example of how to subclass BZGFormViewController, check out the ```SignupViewController``` in the included project.
For email validation, you'll have to sign up for Mailgun and add your public API key to ```SignupViewController.m```.
When you're ready, ```pod install```, open the workspace, and run. All unit tests should be run from the example project.

### Links

[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)

[Mailgun email validation](http://blog.mailgun.com/post/free-email-validation-api-for-web-forms/)

[BZGMailgunEmailValidation](https://github.com/benzguo/BZGMailgunEmailValidation)


