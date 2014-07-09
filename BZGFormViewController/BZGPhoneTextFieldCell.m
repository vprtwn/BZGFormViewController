//
//  BZGPhoneTextFieldCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGPhoneTextFieldCell.h"
#import "NSError+BZGFormViewController.h"

#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

@interface BZGPhoneTextFieldCell ()

// Phone number formatting
@property (strong, nonatomic) NBAsYouTypeFormatter *phoneFormatter;
@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) NBPhoneNumberUtil *phoneUtil;

@end

@implementation BZGPhoneTextFieldCell

- (id)init
{
    self = [super init];
    if (self) {
        NSLocale *locale = [NSLocale currentLocale];
        self.regionCode = [[locale localeIdentifier] substringFromIndex:3];
        self.phoneFormatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:self.regionCode];
        self.phoneUtil = [NBPhoneNumberUtil sharedInstance];   
        self.invalidText = @"Please enter a valid phone number";
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return self;
}

-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
{
    // Disable long press
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) 
    {
        gestureRecognizer.enabled = NO;
    }
    [super addGestureRecognizer:gestureRecognizer];
    return;
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *digitSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    // Entered one number
    if (string.length == 1 &&
        [string rangeOfCharacterFromSet:digitSet].length != 0 &&
        range.location == self.textField.text.length) {
        self.textField.text = [self.phoneFormatter inputDigit:string];
    }
    // Backspace
    else if (string.length == 0) {
        self.textField.text = [self.phoneFormatter removeLastDigit];
    }
    // Validate text
    NSError *error = nil;
    NBPhoneNumber *phoneNumber = [self.phoneUtil parse:self.textField.text
                                         defaultRegion:self.regionCode
                                                 error:&error];
    if (!error) {
        BOOL isPossibleNumber = NO;
        if ([self.regionCode isEqualToString:@"US"]) {
            // Don't allow 7-digit local format
            NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
            NSString *strippedPhoneString = [[self.textField.text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
            isPossibleNumber = [self.phoneUtil isPossibleNumber:phoneNumber error:&error] && strippedPhoneString.length >= 10;
        }
        else {
            isPossibleNumber = [self.phoneUtil isPossibleNumber:phoneNumber error:&error];
        }
        if (error || !isPossibleNumber) {
            self.validationState = BZGValidationStateInvalid;
            self.validationError = [NSError bzg_errorWithDescription:self.invalidText];
        } else {
            self.validationState = BZGValidationStateValid;
            self.validationError = nil;
        }
    }
    else {
        self.validationState = BZGValidationStateInvalid;
        self.validationError = [NSError bzg_errorWithDescription:self.invalidText];
    }

    return NO;
}

@end
