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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setAllowsSelection:NO];
}

#pragma mark - Showing/hiding info cells

- (BZGFormInfoCell *)infoCellBelowFormFieldCell:(BZGFormFieldCell *)fieldCell
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:fieldCell];
    if (cellIndex == NSNotFound) return nil;
    if (cellIndex+1 > self.formFieldCells.count - 1) return nil;

    UITableViewCell *cellBelow = self.formFieldCells[cellIndex+1];
    if ([cellBelow isKindOfClass:[BZGFormInfoCell class]]) {
        return (BZGFormInfoCell *)cellBelow;
    }

    return nil;
}

- (void)showInfoCellBelowFormFieldCell:(BZGFormFieldCell *)cell
                                  text:(NSString *)text
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return;

    // if an info cell is already showing, update the cell's text
    BZGFormInfoCell *infoCell = [self infoCellBelowFormFieldCell:cell];
    if (infoCell) {
        infoCell.textLabel.text = text;
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

- (void)removeInfoCellBelowFormFieldCell:(BZGFormFieldCell *)cell
{
    NSUInteger cellIndex = [self.formFieldCells indexOfObject:cell];
    if (cellIndex == NSNotFound) return;

    // if no info cell is showing, do nothing
    BZGFormInfoCell *infoCell = [self infoCellBelowFormFieldCell:cell];
    if (!infoCell) return;

    // otherwise, remove it
    [self.formFieldCells removeObjectAtIndex:cellIndex+1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex+1
                                                inSection:self.formSection];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateInfoCellBelowFormFieldCell:(BZGFormFieldCell *)cell
{
    if (cell.validationState == BZGValidationStateInvalid || cell.validationState == BZGValidationStateWarning) {
        if (!cell.textField.editing) {
            [self showInfoCellBelowFormFieldCell:cell text:cell.infoText];
        }
    } else {
        [self removeInfoCellBelowFormFieldCell:cell];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.formSection) {
        return self.formFieldCells.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        return [self.formFieldCells objectAtIndex:indexPath.row];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.formSection) {
        UITableViewCell *cell = [self.formFieldCells objectAtIndex:indexPath.row];
        return cell.frame.size.height;
    }
    return 0;
}


@end
