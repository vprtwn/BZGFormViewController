//
//  BZGFormInfoCellTests.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTestsBase.h"
#import "BZGFormInfoCell.h"

@interface BZGFormInfoCellTests : XCTestCase

@end

@implementation BZGFormInfoCellTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitWithText
{
    BZGFormInfoCell *cell = [[BZGFormInfoCell alloc] initWithText:@"foo"];
    expect(cell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);
    expect(cell.infoLabel.text).to.equal(@"foo");
}

- (void)testResizing
{
    BZGFormInfoCell *cell1 = [[BZGFormInfoCell alloc] initWithText:@"foo"];
    expect(cell1.infoLabel.text).to.equal(@"foo");

    NSString *longText = @"foo foo foo foo foo foo foo foo. foo foo foo foo foo foo foo foo. fooo foo foo foo foo foo foo foo.";
    BZGFormInfoCell *cell2 = [[BZGFormInfoCell alloc] initWithText:longText];
    expect(cell1.frame.size.height).to.beLessThan(cell2.frame.size.height);
}

- (void)testSetText
{
    BZGFormInfoCell *cell = [[BZGFormInfoCell alloc] init];
    expect(cell.infoLabel.text).to.equal(@"");
    [cell setText:@"foo"];
    expect(cell.infoLabel.text).to.equal(@"foo");
    CGFloat height1 = cell.frame.size.height;
    
    NSString *longText = @"foo foo foo foo foo foo foo foo. foo foo foo foo foo foo foo foo. fooo foo foo foo foo foo foo foo.";
    [cell setText:longText];
    expect(cell.infoLabel.text).to.equal(longText);
    CGFloat height2 = cell.frame.size.height;
    expect(height1).to.beLessThan(height2);
}


@end
