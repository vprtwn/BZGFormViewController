#import "BZGPhoneTextFieldCell.h"

#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

#import "NSError+BZGFormViewController.h"

@interface BZGPhoneTextFieldCell ()

@property (strong, nonatomic) NBAsYouTypeFormatter *phoneFormatter;
@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) NBPhoneNumberUtil *phoneUtil;

@end

SpecBegin(BZGPhoneTextFieldCell)

describe(@"initialization", ^{
    it(@"should have default invalid text", ^{
        BZGPhoneTextFieldCell *cell = [BZGPhoneTextFieldCell new];
        expect(cell.invalidText.length).toNot.equal(0);
    });
});

describe(@"shouldChangeCharactersInRange:replacementString", ^{
    __block BZGPhoneTextFieldCell *cell;

    void(^enterPhoneNumber)(NSString *) = ^(NSString *phoneNumber) {
        for (NSInteger i = 0; i <phoneNumber.length; i++) {
            NSString *singleDigit = [phoneNumber substringWithRange:NSMakeRange(i, 1)];
            [cell shouldChangeCharactersInRange:NSMakeRange(cell.textField.text.length, 1) replacementString:singleDigit];
        }
    };

    beforeEach(^{
        cell = [BZGPhoneTextFieldCell new];
    });
    
    it(@"should always return NO", ^{
        cell.textField.text = @"123";
        BOOL shouldChange = [cell shouldChangeCharactersInRange:NSRangeFromString(@"2 1") replacementString:@"2"];
        expect(shouldChange).to.beFalsy();
    });
    
    it(@"should call inputDigit on the cell's phoneFormatter if the user entered one digit", ^{
        id mockFormatter = [OCMockObject mockForClass:[NBAsYouTypeFormatter class]];
        [[mockFormatter expect] inputDigit:@"1"];
        cell.phoneFormatter = mockFormatter;
        cell.textField.text = @"123";
        
        [cell shouldChangeCharactersInRange:NSRangeFromString(@"3 1") replacementString:@"1"];
        [mockFormatter verify];
    });
    
    it(@"should not call inputDigit on the cell's phoneFormatter if the user entered more than one digit", ^{
        id mockFormatter = [OCMockObject mockForClass:[NBAsYouTypeFormatter class]];
        [[mockFormatter reject] inputDigit:OCMOCK_ANY];
        cell.phoneFormatter = mockFormatter;
        cell.textField.text = @"123";
        
        [cell shouldChangeCharactersInRange:NSRangeFromString(@"3 2") replacementString:@"12"];
        [mockFormatter verify];       
    });
    
    it(@"should not call inputDigit on the cell's phoneFormatter if the user entered a nonnumeric character", ^{
        id mockFormatter = [OCMockObject mockForClass:[NBAsYouTypeFormatter class]];
        [[mockFormatter reject] inputDigit:OCMOCK_ANY];
        cell.phoneFormatter = mockFormatter;
        cell.textField.text = @"123";
        
        [cell shouldChangeCharactersInRange:NSRangeFromString(@"3 1") replacementString:@"a"];
        [mockFormatter verify];              
    });
    
    it(@"should call removeDigit on the cell's phoneFormatter if the user pressed backspace", ^{
        id mockFormatter = [OCMockObject mockForClass:[NBAsYouTypeFormatter class]];
        [[mockFormatter expect] removeLastDigit];
        cell.phoneFormatter = mockFormatter;
        cell.textField.text = @"123";
        
        [cell shouldChangeCharactersInRange:NSRangeFromString(@"3 1") replacementString:@""];
        [mockFormatter verify];                     
    });

    it(@"should set validationState to BZGValidationStateInvalid and set validationError if the phone number is invalid", ^{
        NSString *testString = @"61238838";
        enterPhoneNumber(testString);
        expect(cell.validationState).to.equal(BZGValidationStateInvalid);
        expect(cell.validationError).toNot.beNil();

    });

    fit(@"should set validationState to BZGValidationStateValid and clear the validationError if the phone number is valid", ^{
        cell.validationState = BZGValidationStateInvalid;
        cell.validationError = [NSError bzg_errorWithDescription:@"Hleol, whirled"];
        NSString *testString = @"6123883823";
        enterPhoneNumber(testString);
        expect(cell.validationState).to.equal(BZGValidationStateValid);
        expect(cell.validationError).to.beNil();
    });
});


SpecEnd
