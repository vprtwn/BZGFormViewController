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
    it(@"should invoke formCell:didChangeValidationState: with the correct arguments when the cell's validation state changes to valid", ^{
        id<BZGFormCellDelegate> mockDelegate = mockProtocol(@protocol(BZGFormCellDelegate));
        cell.delegate = mockDelegate;
        cell.validationState = BZGValidationStateValid;
        [verify(mockDelegate) formCell:cell didChangeValidationState:BZGValidationStateValid];
    });

    it(@"should invoke formCell:didChangeValidationState: with the correct arguments when the cell's validation state changes to invalid", ^{
        id<BZGFormCellDelegate> mockDelegate = mockProtocol(@protocol(BZGFormCellDelegate));
        cell.delegate = mockDelegate;
        cell.validationState = BZGValidationStateInvalid;
        [verify(mockDelegate) formCell:cell didChangeValidationState:BZGValidationStateInvalid];
    });
});

SpecEnd