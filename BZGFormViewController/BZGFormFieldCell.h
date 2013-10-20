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
    BZGValidationStateNone
};

@class BZGFormInfoCell;

@interface BZGFormFieldCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

/// The current validation state. Default is BZGValidationStateNone.
@property (assign, nonatomic) BZGValidationState validationState;

/// A BZGFormInfoCell instance belonging to this form field cell.
@property (strong, nonatomic) BZGFormInfoCell *infoCell;

/// A value indicating whether or not the cell's info cell should be shown.
@property (assign, nonatomic) BOOL shouldShowInfoCell;

/**
 * Returns the parent BZGFormFieldCell for the given text field. If no cell is found, returns nil.
 * 
 * @param textField A UITextField instance that may or may not belong to this BZGFormFieldCell instance.
 */
+ (BZGFormFieldCell *)parentCellForTextField:(UITextField *)textField;

@end
