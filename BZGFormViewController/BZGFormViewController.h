//
//  BZGFormViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>
#import "BZGFormCell.h"
#import "NSError+BZGFormViewController.h"

@class BZGInfoCell, BZGTextFieldCell, BZGPhoneTextFieldCell;

@interface BZGFormViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BZGFormCellDelegate>

/// The table view managed by the controller object.
@property (nonatomic, strong) UITableView *tableView;

/// The form cells used to populate the table view's form section.
@property (nonatomic, strong) NSMutableArray *formCells __deprecated;

/// The table view section where the form should be displayed. (Use 
@property (nonatomic, assign) NSUInteger formSection __deprecated;

/// A property indicating whether or not the keyboard should display an input accessory view with previous, next, and done buttons.
@property (nonatomic, assign) BOOL showsKeyboardControl;

/// A property indicating whether or not a cell manages displaying its own validation state underneath itself with another cell. Default is YES;
@property (assign, nonatomic) BOOL showsValidationCell;

/** 
 * A property indicating whether or not the form is valid.
 * A form is valid when all of its formCells have validation state
 * BZGValidationStateValid or BZGValidationStateWarning.
 */
@property (nonatomic, readonly) BOOL isValid;

/**
 * Initializes a form view controller to manage a table view of a given style.
 *
 * @param style A constant that specifies the style of table view that the controller object is to manage (UITableViewStylePlain or UITableViewStyleGrouped).
 * @return An initialized BZGFormViewController object or nil if the object couldn’t be created.
 */
- (id)initWithStyle:(UITableViewStyle)style;

/**
 * Updates the display state of the info cell below a form cell.
 *
 * @param cell an instance of BZGTextFieldCell in a BZGFormViewController's form cells
 */
- (void)updateInfoCellBelowFormCell:(BZGTextFieldCell *)cell;

/**
 * Returns the next form cell.
 *
 * @param cell The starting form field cell.
 * @return The next form field cell or nil if no cell is found.
 */
- (BZGTextFieldCell *)nextFormCell:(BZGTextFieldCell *)cell;

/**
 * Returns the previous form cell.
 *
 * @param cell The starting form field cell.
 * @return The previous form field cell or nil if no cell is found.
 */
- (BZGTextFieldCell *)previousFormCell:(BZGTextFieldCell *)cell;    


/**
 * Scrolls to and makes a destination cell the first responder.
 *
 * @param destinationCell The destination cell.
 */
- (void)navigateToDestinationCell:(BZGTextFieldCell *)destinationCell;

/**
 * Returns the first invalid form field cell.
 *
 * @return The first form field cell with state 'BZGValidationStateInvalid' or nil if no cell is found.
 */
- (BZGTextFieldCell *)firstInvalidFormCell;

/**
 * Returns the first warning form field cell.
 *
 * @return The first form field cell with state 'BZGValidationStateWarning' or nil if no cell is found.
 */
- (BZGTextFieldCell *)firstWarningFormCell;

/**
 * Returns a two-dimensional array of all of the cells, ordered by section and row.
 *
 * @return A two-dimensional array of all of the cells, ordered by section and row.
 */
- (NSArray *)allFormCells;

/**
 * Returns an array of cells in the section, ordered by row
 *
 * @return An array of cells in the section, ordered by row
 */
- (NSArray *)formCellsInSection:(NSInteger)section;

/**
 * Appends the form cell at the end of the section
 *
 * @param formCell A BZGFormCell
 * @param section A form section
 */
- (void)addFormCell:(BZGFormCell *)formCell atSection:(NSInteger)section;

/**
 * Appends the form cells at the end of the section
 *
 * @param formCells An array of BZGFormCells
 * @param section A form section
 */
- (void)addFormCells:(NSArray *)formCells atSection:(NSInteger)section;

/**
 * Inserts the form cells into the section, starting at the specified index path
 *
 * @param formCells An array of BZGFormCells
 * @param indexPath An index path representing the section and row for insertion
 */
- (void)insertFormCells:(NSArray *)formCells atIndexPath:(NSIndexPath *)indexPath;

/**
 * Removes the form cell at the specified index path
 *
 * @param indexPath An index path representing the section and row for removal
 */
- (void)removeFormCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Removes all form cells in the specified section
 *
 * @param section A form section
 */
- (void)removeFormCellsInSection:(NSInteger)section;

/**
 * Removes all form cells from all sections
 */
- (void)removeAllFormCells;

/**
 * Returns an index path for the cell in the form
 *
 * @param cell A BZGFormCell that's in the form
 * @return An index path representing the row and section of the cell in the form
 */
- (NSIndexPath *)indexPathOfCell:(BZGFormCell *)cell;


@end
