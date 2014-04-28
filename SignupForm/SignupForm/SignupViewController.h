//
//  SignupViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"

@class BZGMailgunEmailValidator;

@interface SignupViewController : BZGFormViewController

@property (nonatomic, strong) BZGTextFieldCell *usernameCell;
@property (nonatomic, strong) BZGTextFieldCell *emailCell;
@property (nonatomic, strong) BZGPhoneTextFieldCell *phoneCell;
@property (nonatomic, strong) BZGTextFieldCell *passwordCell;

@property (nonatomic, strong) BZGMailgunEmailValidator *emailValidator;

@end
