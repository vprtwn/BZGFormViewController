//
//  SignupViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "SignupViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGMailgunEmailValidator.h"

#warning remove public key
#define MAILGUN_PUBLIC_KEY @"pubkey-2qnhwymcue-jpv13-mka58smsqunxy33" //@"YOUR_MAILGUN_PUBLIC_KEY"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    self.emailValidator = [BZGMailgunEmailValidator validatorWithPublicKey:MAILGUN_PUBLIC_KEY operationQueue:queue];
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
    // validation state should be None if field is empty
    if (newText.length == 0) {
        cell.validationState = BZGValidationStateNone;
    }
    else if ([cell isEqual:self.usernameFieldCell]) {
        if (newText.length < 5) {
            cell.validationState = BZGValidationStateInvalid;
            cell.infoText = NSLocalizedString(@"Username must be at least 5 characters long. Username must be at least 5 characters long. Username must be at least 5 characters long.", nil);
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

@end
