#import "BZGPhoneTextFieldCell.h"

UIWindow *window;

SpecBegin(BZGPhoneTextFieldCell)

describe(@"initialization", ^{
    it(@"should have default invalid text", ^{
        BZGPhoneTextFieldCell *cell = [BZGPhoneTextFieldCell new];
        expect(cell.invalidText.length).toNot.equal(0);
    });
});

SpecEnd
