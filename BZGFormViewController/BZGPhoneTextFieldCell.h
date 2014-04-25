//
//  BZGPhoneTextFieldCell.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTextFieldCell.h"
#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>

@interface BZGPhoneTextFieldCell : BZGTextFieldCell <UITextFieldDelegate>

@property (strong, nonatomic) NBAsYouTypeFormatter *phoneFormatter;

@end
