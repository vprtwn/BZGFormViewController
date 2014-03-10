//
//  BZGFormFieldCellTests.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTestsBase.h"
#import "BZGFormFieldCell.h"
#import "Constants.h"

@interface BZGFormFieldCellTests : XCTestCase {
    BZGFormFieldCell *formFieldCell;
}

@end

@implementation BZGFormFieldCellTests

- (void)setUp
{
    [super setUp];
    formFieldCell = [[BZGFormFieldCell alloc] init];
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
    expect(formFieldCell.showsCheckmark).to.equal(YES);
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
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    expect(cell).to.beNil;

    cell = [BZGFormFieldCell parentCellForTextField:formFieldCell.textField];
    expect(cell).toNot.beNil;
    expect(cell).to.equal(formFieldCell);
}

- (void)testShowsCheckmarkNO
{
    formFieldCell.showsCheckmark = NO;
    formFieldCell.validationState = BZGValidationStateValid;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryNone);
}

- (void)testShowsCheckmarkYES
{
    formFieldCell.showsCheckmark = YES;
    formFieldCell.validationState = BZGValidationStateValid;
    expect(formFieldCell.accessoryType).to.equal(UITableViewCellAccessoryCheckmark);
}

@end
