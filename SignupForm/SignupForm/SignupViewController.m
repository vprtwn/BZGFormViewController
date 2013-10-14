//
//  SignupViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "SignupViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGMailgunEmailValidator.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"

#define MAILGUN_PUBLIC_KEY @"YOUR_PUBLIC_KEY"
#warning Add your Mailgun public key ^^^

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    
    self.usernameFieldCell = [[BZGFormFieldCell alloc] init];
    self.usernameFieldCell.label.text = NSLocalizedString(@"Username", nil);
    self.usernameFieldCell.textField.placeholder = NSLocalizedString(@"username", nil);
    self.usernameFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameFieldCell.textField.delegate = self;

    self.emailFieldCell = [[BZGFormFieldCell alloc] init];
    self.emailFieldCell.label.text = NSLocalizedString(@"Email", nil);
    self.emailFieldCell.textField.placeholder = NSLocalizedString(@"name@example.com", nil);
    self.emailFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailFieldCell.textField.delegate = self;

    self.passwordFieldCell = [[BZGFormFieldCell alloc] init];
    self.passwordFieldCell.label.text = NSLocalizedString(@"Password", nil);
    self.passwordFieldCell.textField.placeholder = NSLocalizedString(@"Required", nil);
    self.passwordFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordFieldCell.textField.secureTextEntry = YES;
    self.passwordFieldCell.textField.delegate = self;

    self.formFieldCells = [NSMutableArray arrayWithArray:@[self.usernameFieldCell,
                                                           self.emailFieldCell,
                                                           self.passwordFieldCell]];
    self.formSection = 0;

    self.emailValidator = [BZGMailgunEmailValidator validatorWithPublicKey:MAILGUN_PUBLIC_KEY operationQueue:[NSOperationQueue mainQueue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [super tableView:tableView numberOfRowsInSection:section];
    if (rowCount) {
        return rowCount;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell;
    } else {
        UITableViewCell *signupCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        signupCell.textLabel.text = @"Sign Up";
        signupCell.textLabel.textAlignment = NSTextAlignmentCenter;
        RAC(signupCell, selectionStyle) =
        [RACSignal combineLatest:@[[RACObserve(self.usernameFieldCell,validationState) skip:1],
                                   [RACObserve(self.emailFieldCell, validationState) skip:1],
                                   [RACObserve(self.passwordFieldCell, validationState) skip:1]]
         reduce:^NSNumber *(NSNumber *u, NSNumber *e, NSNumber *p){
             if (u.integerValue == BZGValidationStateValid
                 && e.integerValue == BZGValidationStateValid
                 && p.integerValue == BZGValidationStateValid) {
                 return @(UITableViewCellSelectionStyleDefault);
             } else {
                 return @(UITableViewCellEditingStyleNone);
             }
         }];

        RAC(signupCell.textLabel, textColor) =
        [RACSignal combineLatest:@[[RACObserve(self.usernameFieldCell,validationState) skip:1],
                                   [RACObserve(self.emailFieldCell, validationState) skip:1],
                                   [RACObserve(self.passwordFieldCell, validationState) skip:1]]
                          reduce:^UIColor *(NSNumber *u, NSNumber *e, NSNumber *p){
                              if (u.integerValue == BZGValidationStateValid
                                  && e.integerValue == BZGValidationStateValid
                                  && p.integerValue == BZGValidationStateValid) {
                                  return [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
                              } else {
                                  return [UIColor lightGrayColor];
                              }
                          }];

        return signupCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (height) {
        return height;
    } else {
        return 44;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) return;

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) return YES;

    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];

    // validation state should be None if the field is empty
    if (newText.length == 0) {
        cell.validationState = BZGValidationStateNone;
    }
    else if ([cell isEqual:self.usernameFieldCell]) {
        if (newText.length < 5) {
            cell.validationState = BZGValidationStateInvalid;
            cell.infoText = NSLocalizedString(@"Username must be at least 5 characters long.", nil);
        } else {
            cell.validationState = BZGValidationStateValid;
        }
    }
    else if ([cell isEqual:self.emailFieldCell]) {
        cell.validationState = BZGValidationStateNone;
    }
    else if ([cell isEqual:self.passwordFieldCell]) {
        if (newText.length < 8) {
            cell.validationState = BZGValidationStateInvalid;
            cell.infoText = NSLocalizedString(@"Password must be at least 8 characters long.", nil);
        } else {
            cell.validationState = BZGValidationStateValid;
        }
    }
    [self updateInfoCellBelowFormFieldCell:cell];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) return;

    // validation state should be None if the field is empty
    if (textField.text.length == 0) {
        cell.validationState = BZGValidationStateNone;
        [self updateInfoCellBelowFormFieldCell:cell];
        return;
    }

    if ([cell isEqual:self.emailFieldCell]) {
        cell.validationState = BZGValidationStateValidating;
        [self.emailValidator validateEmailAddress:self.emailFieldCell.textField.text
                                          success:^(BOOL isValid, NSString *didYouMean) {
                                              if (isValid) {
                                                  cell.validationState = BZGValidationStateValid;
                                              } else {
                                                  cell.validationState = BZGValidationStateInvalid;
                                                  cell.infoText = @"Email address is invalid.";
                                              }
                                              if (didYouMean) {
                                                  cell.validationState = BZGValidationStateWarning;
                                                  cell.infoText = [NSString stringWithFormat:@"Did you mean %@?", didYouMean];
                                              }
                                              [self updateInfoCellBelowFormFieldCell:cell];
                                          } failure:^(NSError *error) {
                                              cell.validationState = BZGValidationStateNone;
                                              [self updateInfoCellBelowFormFieldCell:cell];
                                          }];
        return;
    }

    [self updateInfoCellBelowFormFieldCell:cell];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) return NO;

    BZGFormFieldCell *nextCell = [self nextFormFieldCell:cell];
    if (!nextCell) {
        [cell.textField resignFirstResponder];
        return YES;
    }

    [nextCell.textField becomeFirstResponder];
    return YES;
}

@end
