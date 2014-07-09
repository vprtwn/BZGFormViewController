//
//  BZGFormCell.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>
#import "BZGInfoCell.h"

@protocol BZGFormCellDelegate;

typedef NS_ENUM(NSInteger, BZGValidationState) {
    BZGValidationStateNone,
    BZGValidationStateInvalid,
    BZGValidationStateWarning,
    BZGValidationStateValid,
    BZGValidationStateValidating,
};

@interface BZGFormCell : UITableViewCell

/// The current validation state. Default is BZGValidationStateNone.
@property (assign, nonatomic) BZGValidationState validationState;

// The cell's validation error
@property (copy, nonatomic) NSError *validationError;

/// The cell displayed when the cell's validation state is Invalid or Warning.
@property (strong, nonatomic) BZGInfoCell *infoCell;

/// The cell's delegate
@property (strong, nonatomic) id<BZGFormCellDelegate> delegate;

@end

@protocol BZGFormCellDelegate <NSObject>

/**
 * Tells the delegate that the form cell changed its validation state.
 */
- (void)formCell:(BZGFormCell *)formCell didChangeValidationState:(BZGValidationState)validationState;

@end
