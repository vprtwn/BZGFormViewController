//
//  BZGFormViewControllerTests.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGTestsBase.h"
#import "BZGFormViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGFormInfoCell.h"

@interface BZGFormViewControllerTests : XCTestCase {
    BZGFormViewController *formViewController;
    BZGFormFieldCell *cell1;
    BZGFormFieldCell *cell2;
    BZGFormFieldCell *cell3;
}

@end

@implementation BZGFormViewControllerTests

- (void)setUp
{
    [super setUp];
    formViewController = [[BZGFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cell1 = [[BZGFormFieldCell alloc] init];
    cell2 = [[BZGFormFieldCell alloc] init];
    cell3 = [[BZGFormFieldCell alloc] init];
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
- (void)testUpdateInfoCellBelowFormFieldCell_invalidToValid
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell1.validationState = BZGValidationStateInvalid;
    [cell1.infoCell setText:@"cell1 info text"];
    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:formViewController.formSection];
    UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell1 info text");

    cell1.validationState = BZGValidationStateValid;
    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
    infoCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:formViewController.formSection];
    expect([formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath]).to.beKindOf([BZGFormFieldCell class]);
}

// Expect an info cell to be displayed and then updated.
- (void)testUpdateInfoCellBelowFormFieldCell_invalidToWarning
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell1.validationState = BZGValidationStateInvalid;
    [cell1.infoCell setText:@"cell1 info text"];
    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:formViewController.formSection];
    UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell1 info text");

    cell1.validationState = BZGValidationStateWarning;
    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:formViewController.formSection];
    infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
}

// Expect an info cell to be displayed and then updated.
- (void)testUpdateInfoCellBelowFormFieldCell_warningChangeText
{
    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell2.validationState = BZGValidationStateInvalid;
    [cell2.infoCell setText:@"cell2 info text"];
    [formViewController updateInfoCellBelowFormFieldCell:cell2];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:formViewController.formSection];
    UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text");

    cell2.validationState = BZGValidationStateWarning;
    [cell2.infoCell setText:@"cell2 info text changed"];
    [formViewController updateInfoCellBelowFormFieldCell:cell2];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
    infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:formViewController.formSection];
    infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
    expect(infoCell).to.beKindOf([BZGFormInfoCell class]);
    expect(((BZGFormInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text changed");
}

// Expect no info cell to be displayed.
- (void)testUpdateInfoCellBelowFormFieldCell_invalid_editing
{
    UITextField *mockEditingTextField = mock([UITextField class]);
    [given([mockEditingTextField isEditing]) willReturnBool:YES];
    cell1.textField = mockEditingTextField;

    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell1.validationState = BZGValidationStateInvalid;

    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
}

// Expect no info cell to be displayed.
- (void)testUpdateInfoCellBelowFormFieldCell_warning_editing
{
    UITextField *mockEditingTextField = mock([UITextField class]);
    [given([mockEditingTextField isEditing]) willReturnBool:YES];
    cell3.textField = mockEditingTextField;

    formViewController.formFieldCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
    [formViewController.tableView reloadData];
    cell3.validationState = BZGValidationStateWarning;

    [formViewController updateInfoCellBelowFormFieldCell:cell1];
    expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
}


@end
