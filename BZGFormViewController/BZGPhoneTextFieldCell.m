//
//  BZGPhoneTextFieldCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGPhoneTextFieldCell.h"
#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>

@implementation BZGPhoneTextFieldCell

- (id)init
{
    self = [super init];
    if (self) {
        self.textField.delegate = self;
        NSLocale *locale = [NSLocale currentLocale];
        NSString *regionCode = [[locale localeIdentifier] substringFromIndex:3];
        self.phoneFormatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:regionCode];
    }
    return self;
}

@end
