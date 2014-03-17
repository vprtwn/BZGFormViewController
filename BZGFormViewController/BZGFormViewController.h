//
//  BZGFormViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

@class BZGTextFieldFormCell, BZGFormInfoCell;

@interface BZGFormViewController : UITableViewController <UITextFieldDelegate>

/// The form cells used to populate the view controller's form section.
@property (nonatomic, strong) NSMutableArray *formCells;

/// The table view section where the form should be displayed.
@property (nonatomic, assign) NSUInteger formSection;

/**
 * Updates the display state of the info cell below a form field cell.
 *
 * @param cell an instance of BZGFormFieldCell in a BZGFormViewController's formFieldCells
 */
- (void)updateInfoCellBelowFormCell:(BZGTextFieldFormCell *)fieldCell;

/**
 * Returns the next form field cell. (Useful for implementing textFieldShouldReturn.)
 *
 * @param cell The starting form field cell.
 * @return The next form field cell or nil if no cell is found.
 */
- (BZGTextFieldFormCell *)nextFormCell:(BZGTextFieldFormCell *)fieldCell;

/**
 * Returns the first invalid form field cell.
 *
 * @return The first form field cell with state 'BZGValidationStateInvalid' or nil if no cell is found.
 */
- (BZGTextFieldFormCell *)firstInvalidFormCell;


@end
