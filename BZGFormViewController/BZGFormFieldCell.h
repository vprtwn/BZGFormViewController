//
//  BZGFormFieldCell.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>
#import "BZGFormInfoCell.h"

typedef NS_ENUM(NSInteger, BZGValidationState) {
    BZGValidationStateInvalid,
    BZGValidationStateValid,
    BZGValidationStateValidating,
    BZGValidationStateNone
};

@interface BZGFormFieldCell : UITableViewCell <UITextFieldDelegate>

typedef void (^voidEditingEventBlock)(BZGFormFieldCell *cell, NSString *text);
typedef BOOL (^boolEditingEventBlock)(BZGFormFieldCell *cell, NSString *text);

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

/// The current validation state. Default is BZGValidationStateNone.
@property (assign, nonatomic) BZGValidationState validationState;

/// The info cell displayed below this cell when shouldShowInfoCell is true.
@property (strong, nonatomic) BZGFormInfoCell *infoCell;

/// A value indicating whether or not the cell's info cell should be shown.
@property (assign, nonatomic) BOOL shouldShowInfoCell;

/// The block called when the text field's text begins editing.
@property (copy, nonatomic) voidEditingEventBlock didBeginEditingBlock;

/**
 * The block called before the text field's text changes.
 * The block's text parameter is the new text. Return NO if the text shouldn't change.
 */
@property (copy, nonatomic) boolEditingEventBlock shouldChangeTextBlock;

/// The block called when the text field's text ends editing.
@property (copy, nonatomic) voidEditingEventBlock didEndEditingBlock;

/// The block called before the text field returns. Return NO if the text field shouldn't return.
@property (copy, nonatomic) boolEditingEventBlock shouldReturnBlock;

/**
 * Returns the parent BZGFormFieldCell for the given text field. If no cell is found, returns nil.
 * 
 * @param textField A UITextField instance that may or may not belong to this BZGFormFieldCell instance.
 */
+ (BZGFormFieldCell *)parentCellForTextField:(UITextField *)textField;

@end
