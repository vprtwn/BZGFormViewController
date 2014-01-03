//
//  SignupViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"

@class BZGMailgunEmailValidator;

@interface SignupViewController : BZGFormViewController //<UITextFieldDelegate>

@property (nonatomic, strong) BZGFormFieldCell *usernameFieldCell;
@property (nonatomic, strong) BZGFormFieldCell *emailFieldCell;
@property (nonatomic, strong) BZGFormFieldCell *passwordFieldCell;

@property (nonatomic, strong) BZGMailgunEmailValidator *emailValidator;

@end
