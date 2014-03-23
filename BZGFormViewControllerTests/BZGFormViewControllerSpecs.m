//
//  BZGFormViewControllerSpecs.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"
#import "BZGTextFieldCell.h"

UIWindow *window;
BZGFormViewController *formViewController;
BZGTextFieldCell *cell1;
BZGTextFieldCell *cell2;
BZGTextFieldCell *cell3;

SpecBegin(BZGFormViewController)

before(^{
    [super setUp];
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    formViewController = [[BZGFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cell1 = [[BZGTextFieldCell alloc] init];
    cell2 = [[BZGTextFieldCell alloc] init];
    cell3 = [[BZGTextFieldCell alloc] init];
    window.rootViewController = formViewController;
    [window makeKeyAndVisible];
});

after(^{
    formViewController = nil;
});

describe(@"Initialization", ^{
    it(@"should initialize with no form cells", ^{
        expect(formViewController.formCells).to.equal(nil);
        expect(formViewController.formSection).to.equal(0);
    });
});

describe(@"Setting form cells", ^{
    it(@"should set the form view controller's form cells", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
    });

    it(@"should set the cell's textfield's delegate to the form view controller", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2]];
        [formViewController.tableView reloadData];
        expect(cell1.textField.delegate).to.equal(formViewController);
        expect(cell2.textField.delegate).to.equal(formViewController);
    });
});

describe(@"nextFormCell:", ^{
    it(@"should return the correct next cell", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];
        expect([formViewController nextFormCell:cell1]).to.equal(cell2);
        expect([formViewController nextFormCell:cell2]).to.equal(cell3);
        expect([formViewController nextFormCell:cell3]).to.equal(nil);
    });
});

describe(@"firstInvalidFormCell", ^{
    it(@"should return the correct first invalid cell", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        expect([formViewController firstInvalidFormCell]).to.equal(nil);
        cell2.validationState = BZGValidationStateInvalid;
        cell3.validationState = BZGValidationStateInvalid;
        expect([formViewController firstInvalidFormCell]).to.equal(cell2);
    });
});

describe(@"updateInfoCellBelowFormCell", ^{
    it(@"should show an info cell when the field has state BZGValidationStateInvalid", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateInvalid;
        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
        NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:formViewController.formSection];
        UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell1 info text");
    });

    it(@"should show an info cell when the field has state BZGValidationStateWarning", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateWarning;
        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
        NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:formViewController.formSection];
        UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell1 info text");
    });

    it(@"should not show an info cell when the field has state BZGValidationStateValid", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateValid;
        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
    });

    it(@"should not show an info cell when the text field is editing", ^{
        UITextField *mockEditingTextField = mock([UITextField class]);
        [given([mockEditingTextField isEditing]) willReturnBool:YES];
        cell1.textField = mockEditingTextField;
        cell1.validationState = BZGValidationStateInvalid;

        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];

        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(3);
    });

    it(@"should update the info cell's text", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
        [formViewController.tableView reloadData];
        cell2.validationState = BZGValidationStateInvalid;
        [cell2.infoCell setText:@"cell2 info text"];
        [formViewController updateInfoCellBelowFormCell:cell2];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
        NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:formViewController.formSection];
        UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text");

        [cell2.infoCell setText:@"cell2 info text changed"];
        [formViewController updateInfoCellBelowFormCell:cell2];
        expect([formViewController.tableView numberOfRowsInSection:formViewController.formSection]).to.equal(4);
        infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:formViewController.formSection];
        infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text changed");
    });
});

describe(@"UITextFieldDelegate blocks", ^{
    it(@"should call the didBeginEditingBlock when the text field begins editing", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1]];
        [formViewController.tableView reloadData];
        cell1.textField.text = @"cell1 textfield text";
        cell1.didBeginEditingBlock = ^(BZGTextFieldCell *cell, NSString *text) {
            cell.infoCell.textLabel.text = text;
        };
        [formViewController textFieldDidBeginEditing:cell1.textField];
        expect(cell1.infoCell.textLabel.text).to.equal(@"cell1 textfield text");
    });

    it(@"should call the shouldChangeText block when the text field's text changes", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1]];
        [formViewController.tableView reloadData];
        cell1.textField.text = @"foo";
        cell1.shouldChangeTextBlock = ^BOOL(BZGTextFieldCell *cell, NSString *text) {
            cell.infoCell.textLabel.text = text;
            return YES;
        };

        expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
        [formViewController textField:cell1.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
        expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
    });

    it(@"should call the didEndEditing block when the text field ends editing", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1]];
        [formViewController.tableView reloadData];
        cell1.textField.text = @"foo";
        cell1.didEndEditingBlock = ^(BZGTextFieldCell *cell, NSString *text) {
            cell.infoCell.textLabel.text = text;
        };

        expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
        [formViewController textFieldDidEndEditing:cell1.textField];
        expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
    });

    it(@"should call the shouldReturn block when the text field returns", ^{
        formViewController.formCells = [NSMutableArray arrayWithArray:@[cell1]];
        [formViewController.tableView reloadData];
        cell1.textField.text = @"foo";
        cell1.shouldReturnBlock = ^BOOL(BZGTextFieldCell *cell, NSString *text) {
            cell.infoCell.textLabel.text = text;
            return YES;
        };

        expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
        [formViewController textFieldShouldReturn:cell1.textField];
        [cell1.textField sendActionsForControlEvents:UIControlEventAllEditingEvents];
        expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
    });
});

SpecEnd
