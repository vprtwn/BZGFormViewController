#import "BZGInfoCell.h"

SpecBegin(BZGInfoCell)

describe(@"Initialization", ^{
    it(@"should correctly initialize with text", ^{
        BZGInfoCell *cell = [[BZGInfoCell alloc] initWithText:@"foo"];
        expect(cell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);
        expect(cell.infoLabel.text).to.equal(@"foo");
    });
});

describe(@"Resizing", ^{
    it(@"should correctly resize to fit large text", ^{
        BZGInfoCell *cell1 = [[BZGInfoCell alloc] initWithText:@"foo"];
        expect(cell1.infoLabel.text).to.equal(@"foo");

        NSString *longText = @"foo foo foo foo foo foo foo foo. foo foo foo foo foo foo foo foo. fooo foo foo foo foo foo foo foo.";
        BZGInfoCell *cell2 = [[BZGInfoCell alloc] initWithText:longText];
        expect(cell1.frame.size.height).to.beLessThan(cell2.frame.size.height);
    });
});

describe(@"Setting text", ^{
    it(@"should correctly update when setting text", ^{
        BZGInfoCell *cell = [[BZGInfoCell alloc] init];
        expect(cell.infoLabel.text).to.equal(@"");
        [cell setText:@"foo"];
        expect(cell.infoLabel.text).to.equal(@"foo");
        CGFloat height1 = cell.frame.size.height;

        NSString *longText = @"foo foo foo foo foo foo foo foo. foo foo foo foo foo foo foo foo. fooo foo foo foo foo foo foo foo.";
        [cell setText:longText];
        expect(cell.infoLabel.text).to.equal(longText);
        CGFloat height2 = cell.frame.size.height;
        expect(height1).to.beLessThan(height2);
    });
});

SpecEnd