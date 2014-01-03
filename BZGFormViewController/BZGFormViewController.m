//
//  BZGFormViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGFormInfoCell.h"
#import "Constants.h"

@interface BZGFormViewController ()

@end

@implementation BZGFormViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self configureTableView];
    }
    return self;
}

- (void)configureTableView
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BZG_TABLEVIEW_BACKGROUND_COLOR;
}

#pragma mark - Showing/hiding info cells

- (BZGFormInfoCell *)infoCellBelowFormFieldCell:(BZGFormFieldCell *)fieldCell
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:fieldCell];
    if (cellIndex == NSNotFound) return nil;
    if (cellIndex + 1 >= self.formFieldCells.count) return nil;

    UITableViewCell *cellBelow = self.formFieldCells[cellIndex + 1];
    if ([cellBelow isKindOfClass:[BZGFormInfoCell class]]) {
        return (BZGFormInfoCell *)cellBelow;
    }

    return nil;
}

- (void)showInfoCellBelowFormFieldCell:(BZGFormFieldCell *)fieldCell
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:fieldCell];
    if (cellIndex == NSNotFound) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];

    // if an info cell is already showing, do nothing
    BZGFormInfoCell *infoCell = [self infoCellBelowFormFieldCell:fieldCell];
    if (infoCell) return;

    // otherwise, add the field cell's info cell to the table view
    [self.formFieldCells insertObject:fieldCell.infoCell atIndex:cellIndex+1];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeInfoCellBelowFormFieldCell:(BZGFormFieldCell *)fieldCell
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:fieldCell];
    if (cellIndex == NSNotFound) return;

    // if no info cell is showing, do nothing
    BZGFormInfoCell *infoCell = [self infoCellBelowFormFieldCell:fieldCell];
    if (!infoCell) return;

    // otherwise, remove it
    [self.formFieldCells removeObjectAtIndex:cellIndex+1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateInfoCellBelowFormFieldCell:(BZGFormFieldCell *)fieldCell
{
    if (fieldCell.shouldShowInfoCell && !fieldCell.textField.editing) {
        [self showInfoCellBelowFormFieldCell:fieldCell];
    } else {
        [self removeInfoCellBelowFormFieldCell:fieldCell];
    }
}

#pragma mark - Finding cells

- (BZGFormFieldCell *)firstInvalidFormFieldCell
{
    for (UITableViewCell *cell in self.formFieldCells) {
        if ([cell isKindOfClass:[BZGFormFieldCell class]]) {
            if (((BZGFormFieldCell *)cell).validationState == BZGValidationStateInvalid) {
                return (BZGFormFieldCell *)cell;
            }
        }
    }
    return nil;
}

- (BZGFormFieldCell *)nextFormFieldCell:(BZGFormFieldCell *)fieldCell
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:fieldCell];
    if (cellIndex == NSNotFound) return nil;

    for (NSUInteger i = cellIndex + 1; i < self.formFieldCells.count; ++i) {
        UITableViewCell *cell = self.formFieldCells[i];
        if ([cell isKindOfClass:[BZGFormFieldCell class]]) {
            return (BZGFormFieldCell *)cell;
        }
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.formFieldCells) {
        return self.formFieldCells.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.formFieldCells) {
        return [self.formFieldCells objectAtIndex:indexPath.row];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.formFieldCells) {
        UITableViewCell *cell = [self.formFieldCells objectAtIndex:indexPath.row];
        return cell.frame.size.height;
    }
    return 0;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) {
        return;
    }
    if (cell.didBeginEditingBlock) {
        cell.didBeginEditingBlock(cell, textField.text);
    }
    [self updateInfoCellBelowFormFieldCell:cell];

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = YES;
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) {
        return YES;
    }

    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (cell.shouldChangeTextBlock) {
        shouldChange = cell.shouldChangeTextBlock(cell, newText);
    }

    [self updateInfoCellBelowFormFieldCell:cell];
    return shouldChange;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) {
        return;
    }
    if (cell.didEndEditingBlock) {
        cell.didEndEditingBlock(cell, textField.text);
    }

    [self updateInfoCellBelowFormFieldCell:cell];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = YES;
    BZGFormFieldCell *cell = [BZGFormFieldCell parentCellForTextField:textField];
    if (!cell) {
        return YES;
    }

    if (cell.shouldReturnBlock) {
        shouldReturn = cell.shouldReturnBlock(cell, textField.text);
    }

    BZGFormFieldCell *nextCell = [self nextFormFieldCell:cell];
    if (!nextCell) {
        [cell.textField resignFirstResponder];
    }
    else {
        [nextCell.textField becomeFirstResponder];
    }

    [self updateInfoCellBelowFormFieldCell:cell];
    return shouldReturn;
}


@end
