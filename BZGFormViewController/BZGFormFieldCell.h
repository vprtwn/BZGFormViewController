//
//  BZGFormFieldCell.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BZGValidationState) {
    BZGValidationStateInvalid,
    BZGValidationStateValid,
    BZGValidationStateValidating,
    BZGValidationStateWarning,
    BZGValidationStateNone
};

@class BZGFormInfoCell;

@interface BZGFormFieldCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

/// The form field's current validation state. Default is BZGValidationStateNone. A BZGFormViewController will use this property to display a BZGFormInfoCell if the cell is in a 'valid' or 'warning' state.
@property (assign, nonatomic) BZGValidationState validationState;

/// A BZGFormViewController can show this info cell below the field cell.
@property (strong, nonatomic) BZGFormInfoCell *infoCell;

/**
 * Returns the parent BZGFormFieldCell for the given text field. If no cell is found, returns nil.
 */
+ (BZGFormFieldCell *)parentCellForTextField:(UITextField *)textField;

@end
