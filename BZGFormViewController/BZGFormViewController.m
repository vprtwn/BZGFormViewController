//
//  BZGFormViewController.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormViewController.h"
#import "BZGFormFieldCell.h"
#import "BZGFormInfoCell.h"

@interface BZGFormViewController ()

@end

@implementation BZGFormViewController

- (id)init
{
    self = [super init];
    if (self) [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self setup];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) [self setup];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) [self setup];
    return self;
}

- (void)setup
{
    [self configureTableView];
}

- (void)configureTableView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setTableFooterView:[UIView new]];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
                                  text:(NSString *)text
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:fieldCell];
    if (cellIndex == NSNotFound) return;

    // if an info cell is already showing, update the cell's text
    BZGFormInfoCell *infoCell = [self infoCellBelowFormFieldCell:fieldCell];
    if (infoCell) {
        infoCell.infoLabel.text = text;
        return;
    }

    // otherwise, create a new cell
    infoCell = [[BZGFormInfoCell alloc] initWithText:text];
    [self.formFieldCells insertObject:infoCell atIndex:cellIndex+1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];
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
    if (fieldCell.validationState == BZGValidationStateInvalid || fieldCell.validationState == BZGValidationStateWarning) {
        if (!fieldCell.textField.editing) {
            [self showInfoCellBelowFormFieldCell:fieldCell text:fieldCell.infoText];
        }
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
    if (section == self.formSection) {
        if (self.formFieldCells) {
            return self.formFieldCells.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        if (self.formFieldCells) {
            return [self.formFieldCells objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        if (self.formFieldCells) {
            UITableViewCell *cell = [self.formFieldCells objectAtIndex:indexPath.row];
            return cell.frame.size.height;
        }
    }
    return 0;
}


@end
