//
//  BZGFormViewControllerTests.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTestsBase.h"
#import "BZGFormViewController.h"
#import "BZGTextFieldFormCell.h"
#import "BZGFormInfoCell.h"

@interface BZGFormViewControllerTests : XCTestCase {
    BZGFormViewController *formViewController;
    BZGTextFieldFormCell *cell1;
    BZGTextFieldFormCell *cell2;
    BZGTextFieldFormCell *cell3;
}

@end

@implementation BZGFormViewControllerTests

- (void)setUp
{
    [super setUp];
    formViewController = [[BZGFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cell1 = [[BZGTextFieldFormCell alloc] init];
    cell2 = [[BZGTextFieldFormCell alloc] init];
    cell3 = [[BZGTextFieldFormCell alloc] init];
}

- (void)tearDown
{
    formViewController = nil;
    [super tearDown];
}

- (void)testDefaults
{
    expect(formViewController.formFieldCells).to.equal(nil);
    expect(formViewController.formSection).to.equal(0);
}

- (void)testSetFormFieldCells
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
}

- (void)testNextFormFieldCell
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    expect([formViewController nextFormFieldCell:cell1]).to.equal(cell2);
    expect([formViewController nextFormFieldCell:cell2]).to.equal(cell3);
    expect([formViewController nextFormFieldCell:cell3]).to.equal(nil);
}

- (void)testFirstInvalidFormFieldCell
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    expect([formViewController firstInvalidFormFieldCell]).to.equal(nil);
    cell2.validationState = BZGValidationStateInvalid;
    cell3.validationState = BZGValidationStateInvalid;
    expect([formViewController firstInvalidFormFieldCell]).to.equal(cell2);
}

// Expect an info cell to be displayed and then removed.
- (void)testUpdateInfoCellBelowFormFieldCell_showToNoShow
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell1.shouldShowInfoCell = YES;
    [cell1.infoCell setText:@"cell1 info text"];
    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:formViewController.formSection];
    UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell1 info text");

    cell1.shouldShowInfoCell = NO;
    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
    infoCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:formViewController.formSection];
    expect([formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath]).to.beKindOf([BZGTextFieldFormCell class]);
}

// Expect an info cell to be displayed and then updated.
- (void)testUpdateInfoCellBelowFormFieldCell_showThenChangeText
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell2.shouldShowInfoCell = YES;
    [cell2.infoCell setText:@"cell2 info text"];
    [formViewController updateInfoCellBelowFormFieldCell:cell2];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:formViewController.formSection];
    UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text");

    [cell2.infoCell setText:@"cell2 info text changed"];
    [formViewController updateInfoCellBelowFormFieldCell:cell2];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:formViewController.formSection];
    infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text changed");
}

// Expect no info cell to be displayed.
- (void)testUpdateInfoCellBelowFormFieldCell_showWhileEditing
{
    UITextField *mockEditingTextField = mock([UITextField class]);
    [given([mockEditingTextField isEditing]) willReturnBool:YES];
    cell1.textField = mockEditingTextField;

    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell1.shouldShowInfoCell = YES;

    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
}

// Expect the block to be called when the text field begins editing.
- (void)testDidBeginEditingBlock
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1]];
    [formViewController.tableView reloadData];
    cell1.textField.text = @"cell1 textfield text";
    cell1.didBeginEditingBlock = ^(BZGTextFieldFormCell *cell, NSString *text) {
        cell.infoCell.textLabel.text = text;
    };
    [formViewController textFieldDidBeginEditing:cell1.textField];
    expect(cell1.infoCell.textLabel.text).to.equal(@"cell1 textfield text");
}

// Expect the block to be called when the text field's text changes.
- (void)testShouldChangeTextBlock
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1]];
    [formViewController.tableView reloadData];
    cell1.textField.text = @"foo";
    cell1.shouldChangeTextBlock = ^BOOL(BZGTextFieldFormCell *cell, NSString *text) {
        cell.infoCell.textLabel.text = text;
        return YES;
    };

    expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
    [formViewController textField:cell1.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
    expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
}

// Expect the block to be called when the text field ends editing.
- (void)testDidEndEditingBlock
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1]];
    [formViewController.tableView reloadData];
    cell1.textField.text = @"foo";
    cell1.didEndEditingBlock = ^(BZGTextFieldFormCell *cell, NSString *text) {
        cell.infoCell.textLabel.text = text;
    };

    expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
    [formViewController textFieldDidEndEditing:cell1.textField];
    expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
}

// Expect the block to be called when the text field returns.
- (void)testShouldReturnBlock
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1]];
    [formViewController.tableView reloadData];
    cell1.textField.text = @"foo";
    cell1.shouldReturnBlock = ^BOOL(BZGTextFieldFormCell *cell, NSString *text) {
        cell.infoCell.textLabel.text = text;
        return YES;
    };

    expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
    [formViewController textFieldShouldReturn:cell1.textField];
    [cell1.textField sendActionsForControlEvents:UIControlEventAllEditingEvents];
    expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
}

@end
