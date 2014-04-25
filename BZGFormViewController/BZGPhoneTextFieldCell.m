//
//  BZGPhoneTextFieldCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGPhoneTextFieldCell.h"

@implementation BZGPhoneTextFieldCell

- (id)init
{
    self = [super init];
    if (self) {
        self.invalidText = @"Please enter a valid phone number";
    }
    return self;
}

@end
