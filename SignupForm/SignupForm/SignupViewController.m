//
//  SignupViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "SignupViewController.h"
#import "BZGTextFieldCell.h"
#import "BZGPhoneTextFieldCell.h"
#import "BZGMailgunEmailValidator.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"
#import "Constants.h"

static NSString *const MAILGUN_PUBLIC_KEY = @"pubkey-501jygdalut926-6mb1ozo8ay9crlc28";

typedef NS_ENUM(NSInteger, SignupViewControllerSection) {
    SignupViewControllerSectionPrimaryInfo,
    SignupViewControllerSectionSecondaryInfo,
    SignupViewControllerSectionSignUpButton,
    SignupViewControllerSectionCount
};

@interface SignupViewController ()

@property (strong, nonatomic) UITableViewCell *signupCell;

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUsernameCell];
    [self configureEmailCell];
    [self configurePhoneCell];
    [self configurePasswordCell];

    [self addFormCells:@[self.usernameCell, self.emailCell, self.passwordCell] atSection:SignupViewControllerSectionPrimaryInfo];
    [self addFormCells:@[self.phoneCell] atSection:SignupViewControllerSectionSecondaryInfo];
    self.emailValidator = [BZGMailgunEmailValidator validatorWithPublicKey:MAILGUN_PUBLIC_KEY];
    self.showsKeyboardControl = YES;
    self.title = @"BZGFormViewController";
    self.tableView.tableFooterView = [UIView new];
    
    [self.usernameCell becomeFirstResponder];
}

- (void)configureUsernameCell
{
    self.usernameCell = [BZGTextFieldCell new];
    self.usernameCell.label.text = @"Username";
    self.usernameCell.textField.placeholder = @"username";
    self.usernameCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameCell.shouldChangeTextBlock = ^BOOL(BZGTextFieldCell *cell, NSString *newText) {
        if (newText.length < 5) {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Username must be at least 5 characters long."];
        } else {
            cell.validationState = BZGValidationStateValid;
        }
        return YES;
    };
}

- (void)configureEmailCell
{
    self.emailCell = [BZGTextFieldCell new];
    self.emailCell.label.text = @"Email";
    self.emailCell.textField.placeholder = @"name@example.com";
    self.emailCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    @weakify(self)
    self.emailCell.didEndEditingBlock = ^(BZGTextFieldCell *cell, NSString *text) {
        @strongify(self);
        if (text.length == 0) {
            cell.validationState = BZGValidationStateNone;
            [self updateInfoCellBelowFormCell:cell];
            return;
        }
        cell.validationState = BZGValidationStateValidating;
        [self.emailValidator validateEmailAddress:self.emailCell.textField.text
                                          success:^(BOOL isValid, NSString *didYouMean) {
            if (isValid) {
                cell.validationState = BZGValidationStateValid;
            } else {
                cell.validationState = BZGValidationStateInvalid;
                [cell.infoCell setText:@"Email address is invalid."];
            }
            if (didYouMean) {
                cell.validationState = BZGValidationStateWarning;
                [cell.infoCell setText:[NSString stringWithFormat:@"Did you mean %@?", didYouMean]];
                @weakify(cell);
                @weakify(self);
                [cell.infoCell setTapGestureBlock:^{
                    @strongify(cell);
                    @strongify(self);
                    [cell.textField setText:didYouMean];
                    [self textFieldDidEndEditing:cell.textField];
                }];
            } else {
                [cell.infoCell setTapGestureBlock:nil];
            }
            [self updateInfoCellBelowFormCell:cell];
        } failure:^(NSError *error) {
            cell.validationState = BZGValidationStateNone;
            [self updateInfoCellBelowFormCell:cell];
        }];
    };
}

- (void)configurePhoneCell
{
    self.phoneCell = [BZGPhoneTextFieldCell new];
    self.phoneCell.label.text = @"Phone";
    self.phoneCell.textField.placeholder = @"(555) 555-2016";
}

- (void)configurePasswordCell
{
    self.passwordCell = [BZGTextFieldCell new];
    self.passwordCell.label.text = @"Password";
    self.passwordCell.textField.placeholder = @"••••••••";
    self.passwordCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordCell.textField.secureTextEntry = YES;
    self.passwordCell.shouldChangeTextBlock = ^BOOL(BZGTextFieldCell *cell, NSString *text) {
        cell.validationState = BZGValidationStateNone;
        if (text.length < 8) {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Password must be at least 8 characters long."];
        } else {
            cell.validationState = BZGValidationStateValid;
        }
        return YES;
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SignupViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SignupViewControllerSectionSignUpButton) {
        return 1;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SignupViewControllerSectionSignUpButton) {
        return self.signupCell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)signupCell
{
    UITableViewCell *cell = _signupCell;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Sign Up";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        RAC(cell, selectionStyle) =
        [RACObserve(self, isValid) map:^NSNumber *(NSNumber *isValid) {
            return isValid.boolValue ? @(UITableViewCellSelectionStyleDefault) : @(UITableViewCellSelectionStyleNone);
        }];

        RAC(cell.textLabel, textColor) =
        [RACObserve(self, isValid) map:^UIColor *(NSNumber *isValid) {
            return isValid.boolValue ? BZG_BLUE_COLOR : [UIColor lightGrayColor];
        }];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SignupViewControllerSectionSignUpButton) {
        return 44;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == SignupViewControllerSectionSecondaryInfo) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        label.text = @"Secondary Info";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SignupViewControllerSectionSecondaryInfo) {
        return 50;
    } else {
        return 0;
    }
}

@end
