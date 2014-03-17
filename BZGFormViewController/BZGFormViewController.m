//
//  BZGFormViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"
#import "BZGTextFieldFormCell.h"
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

- (BZGFormInfoCell *)infoCellBelowFormCell:(BZGTextFieldFormCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return nil;
    if (cellIndex + 1 >= self.formCells.count) return nil;

    UITableViewCell *cellBelow = self.formCells[cellIndex + 1];
    if ([cellBelow isKindOfClass:[BZGFormInfoCell class]]) {
        return (BZGFormInfoCell *)cellBelow;
    }

    return nil;
}

- (void)showInfoCellBelowFormCell:(BZGTextFieldFormCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];

    // if an info cell is already showing, do nothing
    BZGFormInfoCell *infoCell = [self infoCellBelowFormCell:cell];
    if (infoCell) return;

    // otherwise, add the cell's info cell to the table view
    [self.formCells insertObject:cell.infoCell atIndex:cellIndex+1];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeInfoCellBelowFormFieldCell:(BZGTextFieldFormCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return;

    // if no info cell is showing, do nothing
    BZGFormInfoCell *infoCell = [self infoCellBelowFormCell:cell];
    if (!infoCell) return;

    // otherwise, remove it
    [self.formCells removeObjectAtIndex:cellIndex+1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateInfoCellBelowFormCell:(BZGTextFieldFormCell *)cell
{
    if (!cell.textField.editing &&
        (cell.validationState == BZGValidationStateInvalid ||
         cell.validationState == BZGValidationStateWarning)) {
        [self showInfoCellBelowFormCell:cell];
    } else {
        [self removeInfoCellBelowFormFieldCell:cell];
    }
}

#pragma mark - Finding cells

- (BZGTextFieldFormCell *)firstInvalidFormCell
{
    for (UITableViewCell *cell in self.formCells) {
        if ([cell isKindOfClass:[BZGTextFieldFormCell class]]) {
            if (((BZGTextFieldFormCell *)cell).validationState == BZGValidationStateInvalid) {
                return (BZGTextFieldFormCell *)cell;
            }
        }
    }
    return nil;
}

- (BZGTextFieldFormCell *)nextFormCell:(BZGTextFieldFormCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return nil;

    for (NSUInteger i = cellIndex + 1; i < self.formCells.count; ++i) {
        UITableViewCell *cell = self.formCells[i];
        if ([cell isKindOfClass:[BZGTextFieldFormCell class]]) {
            return (BZGTextFieldFormCell *)cell;
        }
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.formCells) {
        return self.formCells.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.formCells) {
        return [self.formCells objectAtIndex:indexPath.row];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.formCells) {
        UITableViewCell *cell = [self.formCells objectAtIndex:indexPath.row];
        return cell.frame.size.height;
    }
    return 0;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BZGTextFieldFormCell *cell = [BZGTextFieldFormCell parentCellForTextField:textField];
    if (!cell) {
        return;
    }
    if (cell.didBeginEditingBlock) {
        cell.didBeginEditingBlock(cell, textField.text);
    }

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = YES;
    BZGTextFieldFormCell *cell = [BZGTextFieldFormCell parentCellForTextField:textField];
    if (!cell) {
        return YES;
    }

    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (cell.shouldChangeTextBlock) {
        shouldChange = cell.shouldChangeTextBlock(cell, newText);
    }

    [self updateInfoCellBelowFormCell:cell];
    return shouldChange;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BZGTextFieldFormCell *cell = [BZGTextFieldFormCell parentCellForTextField:textField];
    if (!cell) {
        return;
    }
    if (cell.didEndEditingBlock) {
        cell.didEndEditingBlock(cell, textField.text);
    }

    [self updateInfoCellBelowFormCell:cell];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = YES;
    BZGTextFieldFormCell *cell = [BZGTextFieldFormCell parentCellForTextField:textField];
    if (!cell) {
        return YES;
    }

    if (cell.shouldReturnBlock) {
        shouldReturn = cell.shouldReturnBlock(cell, textField.text);
    }

    BZGTextFieldFormCell *nextCell = [self nextFormCell:cell];
    if (!nextCell) {
        [cell.textField resignFirstResponder];
    }
    else {
        [nextCell.textField becomeFirstResponder];
    }

    [self updateInfoCellBelowFormCell:cell];
    return shouldReturn;
}


@end
