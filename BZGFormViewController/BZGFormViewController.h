//
//  BZGFormViewController.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

@class BZGTextFieldFormCell, BZGFormInfoCell;

@interface BZGFormViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

/// The form cells used to populate the view controller's form section.
@property (nonatomic, strong) NSMutableArray *formCells;

/// The table view section where the form should be displayed.
@property (nonatomic, assign) NSUInteger formSection;

/// The view controller's table view.
@property (nonatomic, strong) UITableView *tableView;

/**
 * Initializes a form view controller to manage a tableview of a given style.
 *
 * @param style A constant that specifies the style of table view that the controller object is to manage (UITableViewStylePlain or UITableViewStyleGrouped).
 * @return An initialized BZGFormViewController object or nil if the object couldn’t be created.
 */
- (id)initWithStyle:(UITableViewStyle)style;

/**
 * Updates the display state of the info cell below a form cell.
 *
 * @param cell an instance of BZGFormFieldCell in a BZGFormViewController's formFieldCells
 */
- (void)updateInfoCellBelowFormCell:(BZGTextFieldFormCell *)cell;

/**
 * Returns the next form cell.
 *
 * @param cell The starting form field cell.
 * @return The next form field cell or nil if no cell is found.
 */
- (BZGTextFieldFormCell *)nextFormCell:(BZGTextFieldFormCell *)cell;

/**
 * Returns the first invalid form field cell.
 *
 * @return The first form field cell with state 'BZGValidationStateInvalid' or nil if no cell is found.
 */
- (BZGTextFieldFormCell *)firstInvalidFormCell;


@end
