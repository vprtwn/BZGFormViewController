BZGFormViewController [![Build Status](https://travis-ci.org/benzguo/BZGFormViewController.png?branch=master)](https://travis-ci.org/benzguo/BZGFormViewController)
=====================

BZGFormViewController is a simple library for making dynamic forms.

![alt tag](https://raw.github.com/benzguo/BZGFormViewController/master/Screenshots/SignupForm.gif)

## Demo app
Navigate to /SignupForm, run `pod install`, and open `SignupForm.xcworkspace` to see the signup form above in action.

## Installation

Cocoapods, or copy the contents of /BZGFormViewController into your project.

## Quick start

First, subclass `BZGFormViewController`.
```objc
@interface SignupViewController : BZGFormViewController
```
Next, import "BZGTextFieldCell.h" and create a cell.
```objc
#import "BZGTextFieldCell.h"

// ...

self.usernameCell = [BZGTextFieldCell new];
self.usernameCell.label.text = @"Username";
self.usernameCell.textField.placeholder = @"Username";
self.usernameCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
```
To validate text and update the cell when the cell's text changes, use the cell's `shouldChangeTextBlock`.
```objc
self.usernameCell.textField.delegate = self;
self.usernameCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *newText) {
    if (newText.length < 5) {
        cell.validationState = BZGValidationStateInvalid;
    } else {
        cell.validationState = BZGValidationStateValid;
    }
    return YES;
};
```
Each `BZGTextFieldCell` contains a `BZGInfoCell`. The info cell will be displayed if the cell's `validationState` is `BZGValidationStateInvalid` or `BZGValidationStateWarning`. You can set the info cell's text using `setText:`.
```objc
self.usernameFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *newText) {
    if (newText.length < 5) {
        cell.validationState = BZGValidationStateInvalid;
        [cell.infoCell setText:@"Username must be at least 5 characters long."];
    } else {
        cell.validationState = BZGValidationStateValid;
    }
    return YES;
};
```
You should use `BZGTextFieldCell`'s `shouldChangeTextBlock`, `didBeginEditingBlock`, `didEndEditingBlock`, and `shouldReturnBlock` for validation and any logic you would usually put in `UITextFieldDelegate` methods.

`BZGFormViewController` automatically scrolls the tableview when you begin editing a text field and moves to the next field when you hit return.

After you've configured your cells, set `formCells` to an array containing your form's cells.
```objc
self.formCells = [NSMutableArray arrayWithArray:@[self.usernameFieldCell,
                                                  self.emailFieldCell,
                                                  self.passwordFieldCell]];
```
If you're using a table view with multiple sections, you should specify the section your form should appear in.
```objc
self.formSection = 0
```
Finally, override the `UITableViewDataSource` methods. Be sure to use the values from `super` for the table view's form section.
```objc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.formSection) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return self.signupCell;
    }
}
```

## Contributing
Please write tests and make sure existing tests pass. Tests can be run from the demo project in `/SignupForm`. See the [Roadmap](https://github.com/benzguo/BZGFormViewController/wiki/Roadmap) for planned improvements.

