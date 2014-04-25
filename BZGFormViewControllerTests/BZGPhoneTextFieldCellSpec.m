#import "BZGPhoneTextFieldCell.h"

UIWindow *window;

SpecBegin(BZGPhoneTextFieldCell)

before(^{
    [super setUp];
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
});

describe(@"initialization", ^{
    it(@"should have a phone number formatter", ^{
        BZGPhoneTextFieldCell *cell = [BZGPhoneTextFieldCell new];
        expect(cell.phoneFormatter).toNot.beNil();
    });
});

SpecEnd
