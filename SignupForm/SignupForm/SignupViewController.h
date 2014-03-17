//
//  SignupViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"

@class BZGMailgunEmailValidator;

@interface SignupViewController : BZGFormViewController

@property (nonatomic, strong) BZGTextFieldFormCell *usernameFieldCell;
@property (nonatomic, strong) BZGTextFieldFormCell *emailFieldCell;
@property (nonatomic, strong) BZGTextFieldFormCell *passwordFieldCell;

@property (nonatomic, strong) BZGMailgunEmailValidator *emailValidator;

@end
