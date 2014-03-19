//
//  BZGFormViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"
#import "BZGTextFieldCell.h"
#import "BZGInfoCell.h"
#import "Constants.h"

@interface BZGFormViewController ()

@property (nonatomic, assign) UITableViewStyle style;

@end

@implementation BZGFormViewController

- (id)init {
    self = [super init];
    if (self) {
        self.style = UITableViewStyleGrouped;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizesSubviews = YES;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BZG_TABLEVIEW_BACKGROUND_COLOR;

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizesSubviews = YES;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [contentView addSubview:self.tableView];

    self.view = contentView;
}

#pragma mark - Showing/hiding info cells

- (BZGInfoCell *)infoCellBelowFormCell:(BZGTextFieldCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return nil;
    if (cellIndex + 1 >= self.formCells.count) return nil;

    UITableViewCell *cellBelow = self.formCells[cellIndex + 1];
    if ([cellBelow isKindOfClass:[BZGInfoCell class]]) {
        return (BZGInfoCell *)cellBelow;
    }

    return nil;
}

- (void)showInfoCellBelowFormCell:(BZGTextFieldCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];

    // if an info cell is already showing, do nothing
    BZGInfoCell *infoCell = [self infoCellBelowFormCell:cell];
    if (infoCell) return;

    // otherwise, add the cell's info cell to the table view
    [self.formCells insertObject:cell.infoCell atIndex:cellIndex+1];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeInfoCellBelowFormCell:(BZGTextFieldCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return;

    // if no info cell is showing, do nothing
    BZGInfoCell *infoCell = [self infoCellBelowFormCell:cell];
    if (!infoCell) return;

    // otherwise, remove it
    [self.formCells removeObjectAtIndex:cellIndex+1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateInfoCellBelowFormCell:(BZGTextFieldCell *)cell
{
    if (!cell.textField.editing &&
        (cell.validationState == BZGValidationStateInvalid ||
         cell.validationState == BZGValidationStateWarning)) {
        [self showInfoCellBelowFormCell:cell];
    } else {
        [self removeInfoCellBelowFormCell:cell];
    }
}

#pragma mark - Finding cells

- (BZGTextFieldCell *)firstInvalidFormCell
{
    for (UITableViewCell *cell in self.formCells) {
        if ([cell isKindOfClass:[BZGTextFieldCell class]]) {
            if (((BZGTextFieldCell *)cell).validationState == BZGValidationStateInvalid) {
                return (BZGTextFieldCell *)cell;
            }
        }
    }
    return nil;
}

- (BZGTextFieldCell *)nextFormCell:(BZGTextFieldCell *)cell
{
    NSUInteger cellIndex = [self.formCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return nil;

    for (NSUInteger i = cellIndex + 1; i < self.formCells.count; ++i) {
        UITableViewCell *cell = self.formCells[i];
        if ([cell isKindOfClass:[BZGTextFieldCell class]]) {
            return (BZGTextFieldCell *)cell;
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
    BZGTextFieldCell *cell = [BZGTextFieldCell parentCellForTextField:textField];
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
    BZGTextFieldCell *cell = [BZGTextFieldCell parentCellForTextField:textField];
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
    BZGTextFieldCell *cell = [BZGTextFieldCell parentCellForTextField:textField];
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
    BZGTextFieldCell *cell = [BZGTextFieldCell parentCellForTextField:textField];
    if (!cell) {
        return YES;
    }

    if (cell.shouldReturnBlock) {
        shouldReturn = cell.shouldReturnBlock(cell, textField.text);
    }

    BZGTextFieldCell *nextCell = [self nextFormCell:cell];
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
