//
//  BZGTextFieldCellSpecs.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTextFieldCell.h"

BZGTextFieldCell *cell;

SpecBegin(BZGTextFieldCell)

before(^{
    cell = [[BZGTextFieldCell alloc] init];
});

after(^{
    cell = nil;
});

describe(@"Initialization", ^{
    it(@"should initialize with correct defaults", ^{
        expect(cell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);
        expect(cell.validationState).to.equal(BZGValidationStateNone);
        expect(cell.textField.textColor).to.equal(BZG_TEXTFIELD_NORMAL_COLOR);
        expect(cell.activityIndicatorView.hidden).to.beTruthy;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
        expect(cell.showsCheckmarkWhenValid).to.equal(YES);
        expect(cell.showsValidationWhileEditing).to.equal(NO);
    });
});

describe(@"Validation states", ^{
    it(@"should behave correctly when state is BZGValidationStateValid", ^{
        cell.validationState = BZGValidationStateValid;
        expect(cell.validationState).to.equal(BZGValidationStateValid);
        expect(cell.textField.textColor).to.equal(BZG_TEXTFIELD_NORMAL_COLOR);
        expect(cell.activityIndicatorView.hidden).to.beTruthy;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    });

    it(@"should behave correctly when state is BZGValidationStateInvalid", ^{
        cell.validationState = BZGValidationStateInvalid;
        expect(cell.validationState).to.equal(BZGValidationStateInvalid);
        expect(cell.textField.textColor).to.equal(BZG_TEXTFIELD_INVALID_COLOR);
        expect(cell.activityIndicatorView.hidden).to.beTruthy;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should behave correctly when state is BZGValidationStateWarning", ^{
        cell.validationState = BZGValidationStateWarning;
        expect(cell.validationState).to.equal(BZGValidationStateWarning);
        expect(cell.textField.textColor).to.equal(BZG_TEXTFIELD_NORMAL_COLOR);
        expect(cell.activityIndicatorView.hidden).to.beTruthy;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should behave correctly when state is BZGValidationStateNone", ^{
        cell.validationState = BZGValidationStateNone;
        expect(cell.validationState).to.equal(BZGValidationStateNone);
        expect(cell.textField.textColor).to.equal(BZG_TEXTFIELD_NORMAL_COLOR);
        expect(cell.activityIndicatorView.hidden).to.beTruthy;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should behave correctly when state is BZGValidationStateValidating", ^{
        cell.validationState = BZGValidationStateValidating;
        expect(cell.validationState).to.equal(BZGValidationStateValidating);
        expect(cell.textField.textColor).to.equal(BZG_TEXTFIELD_NORMAL_COLOR);
        expect(cell.activityIndicatorView.hidden).to.beFalsy;
        expect(cell.activityIndicatorView.isAnimating).to.beTruthy;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });
});

describe(@"parentCellForTextField:", ^{
    it(@"should return nil if the text field has no parent BZGTextFieldFormCell", ^{
        UITextField *textField = [[UITextField alloc] init];
        BZGTextFieldCell *cell = [BZGTextFieldCell parentCellForTextField:textField];
        expect(cell).to.beNil;
    });

    it(@"should return the cell when given a BZGTextFieldCell's text field", ^{
        cell = [BZGTextFieldCell parentCellForTextField:cell.textField];
        expect(cell).toNot.beNil;
        expect(cell).to.equal(cell);
    });
});

describe(@"showsCheckmarkWhenValid", ^{
    it(@"should not show a checkmarck when showsCheckMarkWhenValid=NO", ^{
        cell.showsCheckmarkWhenValid = NO;
        cell.validationState = BZGValidationStateValid;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should not show a checkmarck when showsCheckMarkWhenValid=YES", ^{
        cell.showsCheckmarkWhenValid = YES;
        cell.validationState = BZGValidationStateValid;
        expect(cell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    });
});

SpecEnd
