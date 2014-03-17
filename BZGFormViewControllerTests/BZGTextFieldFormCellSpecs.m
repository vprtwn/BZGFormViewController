#import "BZGTextFieldFormCell.h"
#import "Constants.h"

BZGTextFieldFormCell *formCell;

SpecBegin(BZGTextFieldFormCell)

before(^{
    formCell = [[BZGTextFieldFormCell alloc] init];
});

after(^{
    formCell = nil;
});

describe(@"Initialization", ^{
    it(@"should initialize with correct defaults", ^{
        expect(formCell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);
        expect(formCell.validationState).to.equal(BZGValidationStateNone);
        expect(formCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
        expect(formCell.activityIndicatorView.hidden).to.beTruthy;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
        expect(formCell.showsCheckmarkWhenValid).to.equal(YES);
        expect(formCell.showsValidationWhileEditing).to.equal(NO);
    });
});

describe(@"Validation states", ^{
    it(@"should behave correctly when state is BZGValidationStateValid", ^{
        formCell.validationState = BZGValidationStateValid;
        expect(formCell.validationState).to.equal(BZGValidationStateValid);
        expect(formCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
        expect(formCell.activityIndicatorView.hidden).to.beTruthy;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    });

    it(@"should behave correctly when state is BZGValidationStateInvalid", ^{
        formCell.validationState = BZGValidationStateInvalid;
        expect(formCell.validationState).to.equal(BZGValidationStateInvalid);
        expect(formCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_INVALID_COLOR);
        expect(formCell.activityIndicatorView.hidden).to.beTruthy;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should behave correctly when state is BZGValidationStateWarning", ^{
        formCell.validationState = BZGValidationStateWarning;
        expect(formCell.validationState).to.equal(BZGValidationStateWarning);
        expect(formCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
        expect(formCell.activityIndicatorView.hidden).to.beTruthy;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should behave correctly when state is BZGValidationStateNone", ^{
        formCell.validationState = BZGValidationStateNone;
        expect(formCell.validationState).to.equal(BZGValidationStateNone);
        expect(formCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
        expect(formCell.activityIndicatorView.hidden).to.beTruthy;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should behave correctly when state is BZGValidationStateValidating", ^{
        formCell.validationState = BZGValidationStateValidating;
        expect(formCell.validationState).to.equal(BZGValidationStateValidating);
        expect(formCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
        expect(formCell.activityIndicatorView.hidden).to.beFalsy;
        expect(formCell.activityIndicatorView.isAnimating).to.beTruthy;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });
});

describe(@"parentCellForTextField:", ^{
    it(@"should return the text field's parent BZGTextFieldFormCell", ^{

    });
});

describe(@"showsCheckmarkWhenValid", ^{
    it(@"should not show a checkmarck when showsCheckMarkWhenValid=NO", ^{
        formCell.showsCheckmarkWhenValid = NO;
        formCell.validationState = BZGValidationStateValid;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    });

    it(@"should not show a checkmarck when showsCheckMarkWhenValid=YES", ^{
        formCell.showsCheckmarkWhenValid = YES;
        formCell.validationState = BZGValidationStateValid;
        expect(formCell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
    });
});

SpecEnd
