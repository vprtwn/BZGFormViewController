//
//  BZGPhoneTextFieldCell.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTextFieldCell.h"
#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>

@interface BZGPhoneTextFieldCell : BZGTextFieldCell

/// The text to display in the info cell when the phone number is invalid
@property (strong, nonatomic) NSString *invalidText;

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
