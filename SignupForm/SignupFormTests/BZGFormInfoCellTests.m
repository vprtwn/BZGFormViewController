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
    expect(cell.infoLabel.text).to.equal(@"foo");
}

@end
