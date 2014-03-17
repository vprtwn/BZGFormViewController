//
//  BZGTextFieldFormCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTextFieldFormCell.h"
#import "Constants.h"

@interface BZGFormFieldCellTests : XCTestCase {
    BZGTextFieldFormCell *formFieldCell;
}

@end

@implementation BZGFormFieldCellTests

- (void)setUp
{
    [super setUp];
    formFieldCell = [[BZGTextFieldFormCell alloc] init];
}

- (void)tearDown
{
    formFieldCell = nil;
    [super tearDown];
}

- (void)testDefaults
{
    expect(formFieldCell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);
    expect(formFieldCell.validationState).to.equal(BZGValidationStateNone);
    expect(formFieldCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
    expect(formFieldCell.activityIndicatorView.hidden).to.beTruthy;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
    expect(formFieldCell.showsCheckmarkWhenValid).to.equal(YES);
    expect(formFieldCell.showsValidationWhileEditing).to.equal(NO);
}

- (void)testFormFieldValidState
{
    formFieldCell.validationState = BZGValidationStateValid;
    expect(formFieldCell.validationState).to.equal(BZGValidationStateValid);
    expect(formFieldCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
    expect(formFieldCell.activityIndicatorView.hidden).to.beTruthy;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
}

- (void)testFormFieldInvalidState
{
    formFieldCell.validationState = BZGValidationStateInvalid;
    expect(formFieldCell.validationState).to.equal(BZGValidationStateInvalid);
    expect(formFieldCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_INVALID_COLOR);
    expect(formFieldCell.activityIndicatorView.hidden).to.beTruthy;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
}

- (void)testFormFieldValidatingState
{
    formFieldCell.validationState = BZGValidationStateValidating;
    expect(formFieldCell.validationState).to.equal(BZGValidationStateValidating);
    expect(formFieldCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
    expect(formFieldCell.activityIndicatorView.hidden).to.beFalsy;
    expect(formFieldCell.activityIndicatorView.isAnimating).to.beTruthy;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
}

- (void)testFormFieldNoneState
{
    formFieldCell.validationState = BZGValidationStateNone;
    expect(formFieldCell.validationState).to.equal(BZGValidationStateNone);
    expect(formFieldCell.textField.textColor).to.equal(BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR);
    expect(formFieldCell.activityIndicatorView.hidden).to.beTruthy;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
}

- (void)testParentCellForTextField
{
    UITextField *textField = [[UITextField alloc] init];
    BZGTextFieldFormCell *cell = [BZGTextFieldFormCell parentCellForTextField:textField];
    expect(cell).to.beNil;

    cell = [BZGTextFieldFormCell parentCellForTextField:formFieldCell.textField];
    expect(cell).toNot.beNil;
    expect(cell).to.equal(formFieldCell);
}

- (void)testShowsCheckmarkNO
{
    formFieldCell.showsCheckmarkWhenValid = NO;
    formFieldCell.validationState = BZGValidationStateValid;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
}

- (void)testShowsCheckmarkYES
{
    formFieldCell.showsCheckmarkWhenValid = YES;
    formFieldCell.validationState = BZGValidationStateValid;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
}

@end
