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

@interface BZGFormFieldCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

/// The form field's current validation state. Default is BZGValidationStateNone. A BZGFormViewController will use this property to display a BZGFormInfoCell if the cell is in a 'valid' or 'warning' state.
@property (assign, nonatomic) BZGValidationState validationState;

/// Provide a helpful description of the form cell in its current state. A BZGFormViewController will use this property to populate a BZGFormInfoCell.
@property (strong, nonatomic) NSString *infoText;

/**
 * Returns the parent BZGFormFieldCell for the given text field. If no cell is found, returns nil.
 */
+ (BZGFormFieldCell *)parentCellForTextField:(UITextField *)textField;

@end
