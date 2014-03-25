//
//  BZGFormCellSpecs.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormCell.h"

BZGFormCell *cell;

SpecBegin(BZGFormCell)

before(^{
    cell = [[BZGFormCell alloc] init];
});

after(^{
    cell = nil;
});

describe(@"Initialization", ^{
    it(@"should initialize with correct defaults", ^{
        expect(cell.validationState).to.equal(BZGValidationStateNone);
        expect(cell.delegate).to.equal(nil);
    });
});

describe(@"validationState", ^{
    it(@"should invoke formCell:didChangeValidationState: when the cell's validation state changes", ^{
        
    });
});

SpecEnd