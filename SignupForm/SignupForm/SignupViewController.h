//
//  SignupViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"

@class BZGMailgunEmailValidator;

@interface SignupViewController : BZGFormViewController

@property (nonatomic, strong) BZGTextFieldCell *usernameFieldCell;
@property (nonatomic, strong) BZGTextFieldCell *emailFieldCell;
@property (nonatomic, strong) BZGTextFieldCell *passwordFieldCell;

@property (nonatomic, strong) BZGMailgunEmailValidator *emailValidator;

@end
