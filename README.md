BZGFormViewController
=====================

BZGFormViewController is a library for making dynamic forms.

![alt tag](https://raw.github.com/benzguo/BZGFormViewController/master/Screenshots/SignupForm.gif)

## Demo app
Navigate to /SignupForm, run `pod install`, and open `SignupForm.xcworkspace` to see the dynamic signup form used to make the above gif.

## Installation

Cocoapods, or copy the contents of /BZGFormViewController into your project.

## Quick start

First, subclass `BZGFormViewController`.
```objc
@interface SignupViewController : BZGFormViewController
```
Next, import "BZGFormFieldCell.h" and create a cell.
```objc
#import "BZGFormFieldCell.h"

// ...

self.usernameFieldCell = [BZGFormFieldCell new];
self.usernameFieldCell.label.text = @"Username";
self.usernameFieldCell.textField.placeholder = @"Username";
self.usernameFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
```
To validate text, first register as a delegate of the text field.
```objc
self.usernameFieldCell.textField.delegate = self;
```
To validate the text and update the cell whenever the field's text changes, use the cell's `shouldChangeTextBlock`.
```objc
self.usernameFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *newText) {
    if (newText.length < 5) {
        cell.validationState = BZGValidationStateInvalid;
    } else {
        cell.validationState = BZGValidationStateValid;
    }
    return YES;
};
```
Each `BZGFormFieldCell` has a `BZGFormInfoCell` property. If there's a validation error, you should set the info cell's text using `setText:`. To show the info cell, set `shouldShowInfoCell` to `YES`. Don't forget to hide the info cell when you have nothing to show.
```objc
self.usernameFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *newText) {
    if (newText.length < 5) {
        cell.validationState = BZGValidationStateInvalid;
        [cell.infoCell setText:@"Username must be at least 5 characters long."];
        cell.shouldShowInfoCell = YES;
    } else {
        cell.validationState = BZGValidationStateValid;
        cell.shouldShowInfoCell = NO;
    }
    return YES;
};
```
You can also use `didBeginEditingBlock`, `didEndEditingBlock`, and `shouldReturnBlock` for any logic you would usually put in `UITextFieldDelegate` methods. 










