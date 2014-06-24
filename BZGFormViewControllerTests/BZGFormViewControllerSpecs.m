//
//  BZGFormViewControllerSpecs.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"
#import "BZGTextFieldCell.h"

@interface BZGFormViewController ()

- (NSArray *)allFormCells;
@property (nonatomic, strong) NSMutableArray *formCellsBySection;

@end

UIWindow *window;
BZGFormViewController *formViewController;
BZGTextFieldCell *cell1;
BZGTextFieldCell *cell2;
BZGTextFieldCell *cell3;

SpecBegin(BZGFormViewController)

beforeEach(^{
    [super setUp];
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    formViewController = [[BZGFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    cell1 = [[BZGTextFieldCell alloc] init];
    cell2 = [[BZGTextFieldCell alloc] init];
    cell3 = [[BZGTextFieldCell alloc] init];
    [formViewController addFormCells:[@[cell1, cell2] mutableCopy] atSection:1];
    [formViewController addFormCells:[@[cell3] mutableCopy] atSection:2];
    [formViewController.tableView reloadData];
    window.rootViewController = formViewController;
    [window makeKeyAndVisible];
});

afterEach(^{
    formViewController = nil;
});


// Remove this one formSections and formCells
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

describe(@"Initialization", ^{
    it(@"should initialize with no form cell sections", ^{
        formViewController = [[BZGFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
        expect(formViewController.formCells).to.haveCountOf(0);
        expect(formViewController.formSection).to.equal(0);
        expect([[formViewController allFormCells] count]).to.equal(0);
    });
});

describe(@"Setting form cells", ^{
    context(@"deprecated formSection, formCells methods", ^{
        it(@"should use formSection to put the formCells into the two-dimensional formCellsBySection array", ^{
            NSMutableArray *formCells = [NSMutableArray arrayWithArray:@[cell1, cell2, cell3]];
            formViewController.formSection = 2;
            formViewController.formCells = formCells;
            
            expect((formViewController.formCells)).to.equal(formCells);
            expect(([formViewController allFormCells])).to.equal(formCells);
            
            expect(([formViewController formCellsInSection:0])).to.haveCountOf(0);
            expect(([formViewController formCellsInSection:1])).to.haveCountOf(0);
            expect(([formViewController formCellsInSection:2])).to.equal(formCells);
            expect(([formViewController formCellsInSection:3])).to.haveCountOf(0);
            
            formViewController.formSection = 1;
            formViewController.formCells = formCells;
            
            expect((formViewController.formCells)).to.equal(formCells);
            expect(([formViewController allFormCells])).to.equal(formCells);
            
            expect(([formViewController formCellsInSection:0])).to.haveCountOf(0);
            expect(([formViewController formCellsInSection:1])).to.equal(formCells);
            expect(([formViewController formCellsInSection:2])).to.haveCountOf(0);
            expect(([formViewController formCellsInSection:3])).to.haveCountOf(0);
        });
    });
    
#pragma clang diagnostic pop
    
    context(@"adding form cells into specific sections", ^{
        it(@"should set the form view controller's form cells", ^{
            expect([formViewController.tableView numberOfRowsInSection:0]).to.equal(0);
            expect([formViewController.tableView numberOfRowsInSection:1]).to.equal(2);
            expect([formViewController.tableView numberOfRowsInSection:2]).to.equal(1);
        });

        it(@"should set the cell's UITextFieldDelegate to the form view controller", ^{
            expect(cell1.textField.delegate).to.equal(formViewController);
            expect(cell2.textField.delegate).to.equal(formViewController);
            expect(cell3.textField.delegate).to.equal(formViewController);
        });

        it(@"should set the cell's BZGFormCellDelegate to the form view controller", ^{
            expect(cell1.delegate).to.equal(formViewController);
            expect(cell2.delegate).to.equal(formViewController);
            expect(cell3.delegate).to.equal(formViewController);
        });
    });
});

describe(@"previousFormCell:", ^{
    it(@"should return the correct previous cell", ^{
        expect([formViewController previousFormCell:cell3]).to.equal(cell2);
        expect([formViewController previousFormCell:cell2]).to.equal(cell1);
        expect([formViewController previousFormCell:cell1]).to.equal(nil);
    });
});

describe(@"nextFormCell:", ^{
    it(@"should return the correct next cell", ^{
        expect([formViewController nextFormCell:cell1]).to.equal(cell2);
        expect([formViewController nextFormCell:cell2]).to.equal(cell3);
        expect([formViewController nextFormCell:cell3]).to.equal(nil);
    });
});

describe(@"firstInvalidFormCell", ^{
    it(@"should return the correct first invalid cell", ^{
        expect([formViewController firstInvalidFormCell]).to.equal(nil);
        cell2.validationState = BZGValidationStateInvalid;
        cell3.validationState = BZGValidationStateInvalid;
        expect([formViewController firstInvalidFormCell]).to.equal(cell2);
        cell1.validationState = BZGValidationStateInvalid;
        expect([formViewController firstInvalidFormCell]).to.equal(cell1);
    });
});

describe(@"updateInfoCellBelowFormCell", ^{
    it(@"should show an info cell when the field has state BZGValidationStateInvalid", ^{
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateInvalid;
        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:1]).to.equal(3);
        NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell1 info text");
    });

    it(@"should show an info cell when the field has state BZGValidationStateWarning", ^{
        [cell3.infoCell setText:@"cell3 info text"];
        cell3.validationState = BZGValidationStateWarning;
        [formViewController updateInfoCellBelowFormCell:cell3];
        expect([formViewController.tableView numberOfRowsInSection:2]).to.equal(2);
        NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell3 info text");
    });

    it(@"should not show an info cell when the field has state BZGValidationStateValid", ^{
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateValid;
        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:1]).to.equal(2);
    });

    it(@"should update the info cell's text", ^{
        cell2.validationState = BZGValidationStateInvalid;
        [cell2.infoCell setText:@"cell2 info text"];
        [formViewController updateInfoCellBelowFormCell:cell2];
        expect([formViewController.tableView numberOfRowsInSection:1]).to.equal(3);
        NSIndexPath *infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        UITableViewCell *infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text");

        [cell2.infoCell setText:@"cell2 info text changed"];
        [formViewController updateInfoCellBelowFormCell:cell2];
        expect([formViewController.tableView numberOfRowsInSection:1]).to.equal(3);
        infoCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        infoCell = [formViewController.tableView cellForRowAtIndexPath:infoCellIndexPath];
        expect(infoCell).to.beKindOf([BZGInfoCell class]);
        expect(((BZGInfoCell *)infoCell).infoLabel.text).to.equal(@"cell2 info text changed");
    });
});

describe(@"UITextFieldDelegate blocks", ^{
    it(@"should call the didBeginEditingBlock when the text field begins editing", ^{
        cell1.textField.text = @"cell1 textfield text";
        cell1.didBeginEditingBlock = ^(BZGTextFieldCell *cell, NSString *text) {
            cell.infoCell.textLabel.text = text;
        };
        [formViewController textFieldDidBeginEditing:cell1.textField];
        expect(cell1.infoCell.textLabel.text).to.equal(@"cell1 textfield text");
    });

    it(@"should call the shouldChangeText block when the text field's text changes", ^{
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
        cell1.textField.text = @"foo";
        cell1.didEndEditingBlock = ^(BZGTextFieldCell *cell, NSString *text) {
            cell.infoCell.textLabel.text = text;
        };

        expect(cell1.infoCell.textLabel.text).toNot.equal(@"foo");
        [formViewController textFieldDidEndEditing:cell1.textField];
        expect(cell1.infoCell.textLabel.text).to.equal(@"foo");
    });

    it(@"should call the shouldReturn block when the text field returns", ^{
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

describe(@"isValid", ^{
    it(@"should be valid when all the cells are valid", ^{
        cell1.validationState = BZGValidationStateValid;
        cell2.validationState = BZGValidationStateValid;
        cell3.validationState = BZGValidationStateValid;
        expect(formViewController.isValid).to.equal(YES);
    });

    it(@"should be valid when one cell is warning", ^{
        cell1.validationState = BZGValidationStateWarning;
        cell2.validationState = BZGValidationStateValid;
        cell3.validationState = BZGValidationStateValid;
        expect(formViewController.isValid).to.equal(YES);
    });

    it(@"should be invalid when one cell is invalid", ^{
        cell1.validationState = BZGValidationStateValid;
        cell2.validationState = BZGValidationStateInvalid;
        cell3.validationState = BZGValidationStateValid;
        expect(formViewController.isValid).to.equal(NO);
    });

    it(@"should be invalid when one cell is validating", ^{
        cell1.validationState = BZGValidationStateValid;
        cell2.validationState = BZGValidationStateValid;
        cell3.validationState = BZGValidationStateValidating;
        expect(formViewController.isValid).to.equal(NO);
    });
});

SpecEnd
