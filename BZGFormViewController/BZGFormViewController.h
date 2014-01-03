//
//  BZGFormViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

@class BZGFormFieldCell, BZGFormInfoCell;

@interface BZGFormViewController : UITableViewController <UITextFieldDelegate>

/// An array of BZGFormFieldCells used as the table view's data source in the specified section.
@property (nonatomic, strong) NSMutableArray *formFieldCells;

/// The table view section where the form should be displayed.
@property (nonatomic, assign) NSUInteger formSection;

/**
 * Updates the display state of the info cell below a form field cell.
 *
 * @param cell an instance of BZGFormFieldCell in a BZGFormViewController's formFieldCells
 */
- (void)updateInfoCellBelowFormFieldCell:(BZGFormFieldCell *)fieldCell;

/**
 * Returns the next form field cell. (Useful for implementing textFieldShouldReturn.)
 *
 * @param cell The starting form field cell.
 * @return The next form field cell or nil if no cell is found.
 */
- (BZGFormFieldCell *)nextFormFieldCell:(BZGFormFieldCell *)fieldCell;

/**
 * Returns the first invalid form field cell.
 *
 * @return The first form field cell with state 'BZGValidationStateInvalid' or nil if no cell is found.
 */
- (BZGFormFieldCell *)firstInvalidFormFieldCell;


@end
