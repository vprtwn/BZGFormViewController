//
//  BZGFormViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

@class BZGFormFieldCell, BZGFormInfoCell;

@interface BZGFormViewController : UITableViewController

/// An array of BZGFormFieldCells used as the table view's data source in the specified section.
@property (nonatomic, strong) NSMutableArray *formFieldCells;

/// The table view section where the form should be displayed.
@property (nonatomic, assign) NSUInteger formSection;

/**
 * Updates the display state of the info cell corresponding to the given form cell.
 *
 * @param cell The given form cell.
 */
- (void)updateInfoCellBelowFormFieldCell:(BZGFormFieldCell *)cell;


@end
