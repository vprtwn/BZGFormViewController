#import "BZGPhoneTextFieldCell.h"

#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

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
    
    before(^{
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
    
});

SpecEnd
