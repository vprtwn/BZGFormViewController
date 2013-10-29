//
//  SignupViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "SignupViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGFormInfoCell.h"
#import "BZGFloatingLabelFormFieldCell.h"
#import "BZGMailgunEmailValidator.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"

#define MAILGUN_PUBLIC_KEY @"pubkey-66-yxtny6wvph09k953go8jvyur4muc0"
#warning Add your Mailgun public key ^^^

@interface SignupViewController ()

@property (strong, nonatomic) UITableViewCell *signupCell;

@end

@implementation SignupViewController

- (void)configureTableView
{
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.usernameFieldCell = [[BZGFloatingLabelFormFieldCell alloc] init];
    self.usernameFieldCell.textField.placeholder = NSLocalizedString(@"Username", nil);
    self.usernameFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameFieldCell.textField.delegate = self;

    self.emailFieldCell = [[BZGFloatingLabelFormFieldCell alloc] init];
    self.emailFieldCell.textField.placeholder = NSLocalizedString(@"Email", nil);
    self.emailFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailFieldCell.textField.delegate = self;

    self.passwordFieldCell = [[BZGFloatingLabelFormFieldCell alloc] init];
    self.passwordFieldCell.textField.placeholder = NSLocalizedString(@"Password", nil);
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
        return self.signupCell;
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
        
        RAC(cell.textLabel, textColor) =
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
        self.usernameFieldCell.validationState = BZGValidationStateNone;
        self.emailFieldCell.validationState = BZGValidationStateNone;
        self.passwordFieldCell.validationState = BZGValidationStateNone;
    }
    return cell;
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

    // validation state should be None if the field is empty.
    if (newText.length == 0) {
        cell.validationState = BZGValidationStateNone;
        cell.shouldShowInfoCell = NO;
    }
    else if ([cell isEqual:self.usernameFieldCell]) {
        if (newText.length < 5) {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Username must be at least 5 characters long."];
            cell.shouldShowInfoCell = YES;
        } else {
            cell.validationState = BZGValidationStateValid;
            cell.shouldShowInfoCell = NO;
        }
    }
    else if ([cell isEqual:self.emailFieldCell]) {
        cell.validationState = BZGValidationStateNone;
        cell.shouldShowInfoCell = NO;
    }
    else if ([cell isEqual:self.passwordFieldCell]) {
        // because this is a secure text field, reset the validation state every time.
        cell.validationState = BZGValidationStateNone;
        if (newText.length < 8) {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Password must be at least 8 characters long."];
            cell.shouldShowInfoCell = YES;
        } else {
            cell.validationState = BZGValidationStateValid;
            cell.shouldShowInfoCell = NO;
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
                                                  cell.shouldShowInfoCell = NO;
                                              } else {
                                                  cell.validationState = BZGValidationStateInvalid;
                                                  [cell.infoCell setText:@"Email address is invalid."];
                                                  cell.shouldShowInfoCell = YES;
                                              }
                                              if (didYouMean) {
                                                  [cell.infoCell setText:[NSString stringWithFormat:@"Did you mean %@?", didYouMean]];
                                                  @weakify(cell);
                                                  @weakify(self);
                                                  [cell.infoCell setTapGestureBlock:^BOOL{
                                                      @strongify(cell);
                                                      @strongify(self);
                                                      [cell.textField setText:didYouMean];
                                                      [self textFieldDidEndEditing:cell.textField];
                                                  }];
                                                  cell.shouldShowInfoCell = YES;
                                              }
                                              [self updateInfoCellBelowFormFieldCell:cell];
                                          } failure:^(NSError *error) {
                                              cell.validationState = BZGValidationStateNone;
                                              cell.shouldShowInfoCell = NO;
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
