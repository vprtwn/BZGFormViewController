//
//  SignupViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "SignupViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGFormInfoCell.h"
#import "BZGMailgunEmailValidator.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"

//#define MAILGUN_PUBLIC_KEY @""
static NSString *const MAILGUN_PUBLIC_KEY = @"";
#warning Add your Mailgun public key ^^^

@interface SignupViewController ()

@property (strong, nonatomic) UITableViewCell *signupCell;

@end

@implementation SignupViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUsernameFieldCell];
    [self configureEmailFieldCell];
    [self configurePasswordFieldCell];

    self.formFieldCells = [NSMutableArray arrayWithArray:@[self.usernameFieldCell,
                                                           self.emailFieldCell,
                                                           self.passwordFieldCell]];
    self.formSection = 0;
    self.emailValidator = [BZGMailgunEmailValidator validatorWithPublicKey:MAILGUN_PUBLIC_KEY];
}

- (void)configureUsernameFieldCell
{
    self.usernameFieldCell = [[BZGFormFieldCell alloc] init];
    self.usernameFieldCell.label.text = @"Username";
    self.usernameFieldCell.textField.placeholder = NSLocalizedString(@"Username", nil);
    self.usernameFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameFieldCell.textField.delegate = self;
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
}

- (void)configureEmailFieldCell
{
    self.emailFieldCell = [[BZGFormFieldCell alloc] init];
    self.emailFieldCell.label.text = @"Email";
    self.emailFieldCell.textField.placeholder = NSLocalizedString(@"Email", nil);
    self.emailFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailFieldCell.textField.delegate = self;
    @weakify(self)
    self.emailFieldCell.didEndEditingBlock = ^(BZGFormFieldCell *cell, NSString *text) {
        @strongify(self);
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
                                              } else {
                                                  [cell.infoCell setTapGestureBlock:nil];
                                              }
                                              [self updateInfoCellBelowFormFieldCell:cell];
                                          } failure:^(NSError *error) {
                                              cell.validationState = BZGValidationStateNone;
                                              cell.shouldShowInfoCell = NO;
                                              [self updateInfoCellBelowFormFieldCell:cell];
                                          }];
    };
}

- (void)configurePasswordFieldCell
{
    self.passwordFieldCell = [[BZGFormFieldCell alloc] init];
    self.passwordFieldCell.label.text = @"Password";
    self.passwordFieldCell.textField.placeholder = NSLocalizedString(@"Password", nil);
    self.passwordFieldCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordFieldCell.textField.secureTextEntry = YES;
    self.passwordFieldCell.textField.delegate = self;
    self.passwordFieldCell.shouldChangeTextBlock = ^BOOL(BZGFormFieldCell *cell, NSString *text) {
        // because this is a secure text field, reset the validation state every time.
        cell.validationState = BZGValidationStateNone;
        if (text.length < 8) {
            cell.validationState = BZGValidationStateInvalid;
            [cell.infoCell setText:@"Password must be at least 8 characters long."];
            cell.shouldShowInfoCell = YES;
        } else {
            cell.validationState = BZGValidationStateValid;
            cell.shouldShowInfoCell = NO;
        }
        return YES;
    };
}

#pragma mark - UITableViewDataSource

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
                                  return @(UITableViewCellSelectionStyleNone);
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
    if (indexPath.section == self.formSection) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 44;
    }
}

@end
