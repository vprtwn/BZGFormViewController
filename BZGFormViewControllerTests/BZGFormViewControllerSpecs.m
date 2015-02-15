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
@property (nonatomic, strong) NSArray *allFormCellsFlattened;

@end

UIWindow *window;
BZGFormViewController *formViewController;
BZGTextFieldCell *cell1;
BZGTextFieldCell *cell2;
BZGTextFieldCell *cell3;

SpecBegin(BZGFormViewController)

beforeEach(^{
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    formViewController = [OCMockObject partialMockForObject:[[BZGFormViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    
    cell1 = [OCMockObject partialMockForObject:[[BZGTextFieldCell alloc] init]];
    cell2 = [OCMockObject partialMockForObject:[[BZGTextFieldCell alloc] init]];
    cell3 = [OCMockObject partialMockForObject:[[BZGTextFieldCell alloc] init]];
    [[(id)cell1 stub] resignFirstResponder];
    [[(id)cell1 stub] becomeFirstResponder];
    [[(id)cell2 stub] resignFirstResponder];
    [[(id)cell2 stub] becomeFirstResponder];
    [[(id)cell3 stub] resignFirstResponder];
    [[(id)cell3 stub] becomeFirstResponder];
    
    [formViewController addFormCells:@[cell1, cell2] atSection:1];
    [formViewController addFormCells:@[cell3] atSection:2];
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
            expect(([formViewController allFormCells])).to.equal(@[@[], @[], formCells]);
            
            expect(([formViewController formCellsInSection:0])).to.haveCountOf(0);
            expect(([formViewController formCellsInSection:1])).to.haveCountOf(0);
            expect(([formViewController formCellsInSection:2])).to.equal(formCells);
            expect(([formViewController formCellsInSection:3])).to.haveCountOf(0);
            
            formViewController.formSection = 1;
            formViewController.formCells = formCells;
            
            expect((formViewController.formCells)).to.equal(formCells);
            expect(([formViewController allFormCells])).to.equal(@[@[], formCells]);
            
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

describe(@"firstWarningFormCell", ^{
    it(@"should return the correct first warning cell", ^{
        expect([formViewController firstInvalidFormCell]).to.equal(nil);
        cell2.validationState = BZGValidationStateWarning;
        cell3.validationState = BZGValidationStateWarning;
        expect([formViewController firstWarningFormCell]).to.equal(cell2);
        cell1.validationState = BZGValidationStateWarning;
        expect([formViewController firstWarningFormCell]).to.equal(cell1);
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
    
    it(@"should never show an info cell if text has not been provided", ^{
        [cell3.infoCell setText:@""];
        cell3.validationState = BZGValidationStateWarning;
        [formViewController updateInfoCellBelowFormCell:cell3];
        expect([formViewController.tableView numberOfRowsInSection:2]).to.equal(1);
        [cell3.infoCell setText:nil];
        cell3.validationState = BZGValidationStateInvalid;
        [formViewController updateInfoCellBelowFormCell:cell3];
        expect([formViewController.tableView numberOfRowsInSection:2]).to.equal(1);
    });

    it(@"should not show an info cell when the field has state BZGValidationStateValid", ^{
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateValid;
        [formViewController updateInfoCellBelowFormCell:cell1];
        expect([formViewController.tableView numberOfRowsInSection:1]).to.equal(2);
    });

    it(@"should not show any info cells when the formViewController has flag showsValidationCell=NO", ^{
        formViewController.showsValidationCell = NO;
        [cell1.infoCell setText:@"cell1 info text"];
        cell1.validationState = BZGValidationStateInvalid;
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

describe(@"prepareCell:", ^{
    it(@"should set the cell's delegate to the BZGFormViewController", ^{
        it(@"should set the cell's UITextFieldDelegate to the form view controller", ^{
            [formViewController addFormCell:cell1 atSection:0];
            expect(cell1.textField.delegate).to.equal(formViewController);
        });
        
        it(@"should set the cell's BZGFormCellDelegate to the form view controller", ^{
            [formViewController addFormCell:cell1 atSection:0];
            expect(cell1.delegate).to.equal(formViewController);
        });
        
        it(@"should raise an exception if the cell is not a BZGFormCell or BZGInfoCell", ^{
            expect(^{
                [formViewController addFormCell:(BZGFormCell *)[[UITableViewCell alloc] init] atSection:0];
            }).to.raise(nil);
        });
    });
});

describe(@"insertFormCells:atIndexPath:", ^{
    it(@"should insert the form cells into the section", ^{
        BZGFormCell *cell4 = [[BZGFormCell alloc] init];
        
        [formViewController insertFormCells:@[cell3, cell4] atIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        expect([formViewController formCellsInSection:1]).to.equal(@[cell1, cell3, cell4, cell2]);
    });
});

describe(@"removeFormCellAtIndexPath:", ^{
    it(@"should remove the form cell at the provided index path", ^{
        [formViewController removeFormCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        expect([formViewController formCellsInSection:1]).to.equal(@[cell2]);
        expect([formViewController formCellsInSection:2]).to.equal(@[cell3]);
    });
});

describe(@"removeFormCellsInSection:", ^{
    it(@"should remove the form cell at the providedindex path", ^{
        [formViewController removeFormCellsInSection:1];
        
        expect([formViewController formCellsInSection:1]).to.equal(@[]);
    });
});

describe(@"removeAllFormCells", ^{
    it(@"should remove the form cell at the providedindex path", ^{
        [formViewController removeAllFormCells];
        
        expect([formViewController allFormCells]).to.equal(@[]);
    });
});

describe(@"indexPathOfCell:", ^{
    it(@"should return an NSIndexPath representing the row and section that the cell is in", ^{
        expect([formViewController indexPathOfCell:cell3]).to.equal([NSIndexPath indexPathForRow:0 inSection:2]);
    });
    
    it(@"should return nil if the cell is not in the formViewController", ^{
        expect([formViewController indexPathOfCell:[[BZGFormCell alloc] init]]).to.beNil();
    });
});

describe(@"setShowsValidationCell", ^{
    it(@"should updateInfoCellBelowFormCell for all cells", ^{
        for (NSNumber *boolean in @[@(YES), @(NO)]) {
            for (BZGTextFieldCell *cell in @[cell1, cell2, cell3]) {
                [[(id)formViewController expect] updateInfoCellBelowFormCell:cell];
            }
            BOOL booleanPrimitive = [boolean boolValue];
            formViewController.showsValidationCell = booleanPrimitive;
            expect(formViewController.showsValidationCell).to.equal(booleanPrimitive);
        }
    });
});

describe(@"Keyboard notifications", ^{
    describe(@"tableView.contentInset", ^{
        __block UIEdgeInsets existingInsets;
        __block UIEdgeInsets expectedInsets;
        __block UIEdgeInsets insetsWithKeyboard;
        __block CGRect keyboardRect;
        __block CGSize keyboardSize;
        __block NSDictionary *notificationUserInfo;
        
        before(^{
            existingInsets       = UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f);
            keyboardSize         = CGSizeMake(320.f, 270.f);
            keyboardRect         = CGRectMake(0.f, 0.f, keyboardSize.width, keyboardSize.height);
            notificationUserInfo = @{
                                     UIKeyboardFrameBeginUserInfoKey        : [NSValue valueWithCGRect:keyboardRect],
                                     UIKeyboardAnimationDurationUserInfoKey : [NSNumber numberWithInt:0]
                                     };
            insetsWithKeyboard = UIEdgeInsetsMake(existingInsets.top,
                                                  existingInsets.left,
                                                  existingInsets.bottom + keyboardSize.height,
                                                  existingInsets.right);
        });
        
        context(@"UIKeyboardWillShowNotification", ^{
            before(^{
                expectedInsets = insetsWithKeyboard;

                formViewController.tableView.contentInset = existingInsets;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                                    object:nil
                                                                  userInfo:notificationUserInfo];
            });
            
            it(@"should maintain the current insets, adding the height of the keyboard", ^{
                expect(formViewController.tableView.contentInset).to.equal(expectedInsets);
            });
        });
        
        context(@"UIKeyboardWillHideNotification", ^{
            before(^{
                expectedInsets = existingInsets;
                
                formViewController.tableView.contentInset = existingInsets;
                
                // Trigger the show (this sets up the with-keyboard-insets
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                                    object:nil
                                                                  userInfo:notificationUserInfo];
                
                // "Hide" the keyboard
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                                    object:nil
                                                                  userInfo:notificationUserInfo];
            });
            
            it(@"should set the insets back to their original value", ^{
                expect(formViewController.tableView.contentInset).to.equal(expectedInsets);
            });
        });
    });
    
    describe(@"tableView.scrollIndicatorInsets", ^{
        __block UIEdgeInsets existingInsets;
        __block UIEdgeInsets expectedInsets;
        __block UIEdgeInsets insetsWithKeyboard;
        __block CGRect keyboardRect;
        __block CGSize keyboardSize;
        __block NSDictionary *notificationUserInfo;
        
        before(^{
            existingInsets       = UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f);
            keyboardSize         = CGSizeMake(320.f, 270.f);
            keyboardRect         = CGRectMake(0.f, 0.f, keyboardSize.width, keyboardSize.height);
            notificationUserInfo = @{
                                     UIKeyboardFrameBeginUserInfoKey        : [NSValue valueWithCGRect:keyboardRect],
                                     UIKeyboardAnimationDurationUserInfoKey : [NSNumber numberWithInt:0]
                                     };
            insetsWithKeyboard = UIEdgeInsetsMake(existingInsets.top,
                                                  existingInsets.left,
                                                  existingInsets.bottom + keyboardSize.height,
                                                  existingInsets.right);
        });
        
        context(@"UIKeyboardWillShowNotification", ^{
            before(^{
                expectedInsets = insetsWithKeyboard;
                
                formViewController.tableView.contentInset = existingInsets;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                                    object:nil
                                                                  userInfo:notificationUserInfo];
            });
            
            it(@"should maintain the current insets, adding the height of the keyboard", ^{
                expect(formViewController.tableView.scrollIndicatorInsets).to.equal(expectedInsets);
            });
        });
        
        context(@"UIKeyboardWillHideNotification", ^{
            before(^{
                expectedInsets = existingInsets;
                
                formViewController.tableView.contentInset = existingInsets;
                
                // Trigger the show (this sets up the with-keyboard-insets
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                                    object:nil
                                                                  userInfo:notificationUserInfo];
                
                // "Hide" the keyboard
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                                    object:nil
                                                                  userInfo:notificationUserInfo];
            });
            
            it(@"should set the insets back to their original value", ^{
                expect(formViewController.tableView.scrollIndicatorInsets).to.equal(expectedInsets);
            });
        });
    });
});

SpecEnd
