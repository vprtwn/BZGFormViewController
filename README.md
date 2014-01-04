BZGFormViewController
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
Next, import "BZGFormFieldCell.h" and create a cell.
```objc
#import "BZGFormFieldCell.h"

// ...

self.usernameFieldCell = [BZGFormFieldCell new];
self.usernameFieldCell.label.text = @"Username";
self.usernameFieldCell.textField.placeholder = @"Username";
self.usernameFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
```
To validate text and update the cell whenever the field's text changes, use the cell's `shouldChangeTextBlock`.
```objc
self.usernameFieldCell.textField.delegate = self;
self.usernameFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *newText) {
    if (newText.length < 5) {
        cell.validationState = BZGValidationStateInvalid;
    } else {
        cell.validationState = BZGValidationStateValid;
    }
    return YES;
};
```
Each `BZGFormFieldCell` has a `BZGFormInfoCell` property. If validation fails, you should set the info cell's text using `setText:`. To show the info cell, set `shouldShowInfoCell` to `YES`. Don't forget to hide the info cell when you have nothing to show.
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
You should use `shouldChangeTextBlock`, `didBeginEditingBlock`, `didEndEditingBlock`, and `shouldReturnBlock` for validation and any logic you would usually put in `UITextFieldDelegate` methods. 

`BZGFormViewController` automatically scrolls the tableview when you begin editing a field and jumps to the next field when you hit return.

After you've configured your cells, set `formFieldCells` to an array containing your form's cells.
```objc
self.formFieldCells = [NSMutableArray arrayWithArray:@[self.usernameFieldCell,
                                                       self.emailFieldCell,
                                                       self.passwordFieldCell]];
```
If you're using a table view with multiple sections, specify the section your form (i.e. the cells in `self.formFieldCells`) should appear in.
```objc
self.formSection = 0
```
Finally, override the `UITableViewDataSource` methods. Be sure to use the values from `super` when you're dealing with the table view's form section.
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
## Configuration
If you want to customize things like fonts and colors, first try [forking](https://help.github.com/articles/fork-a-repo) and editing `/BZGFormViewController/Constants.h`. If there's anything you can't configure from there, please submit an issue (or pull request)!

## Contributing
Please write tests and make sure existing tests still pass. I'll add Travis soon, but for now, run tests from the demo project in `/SignupForm`. See the [Roadmap](https://github.com/benzguo/BZGFormViewController/wiki/Roadmap) for planned improvements.

