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

/// The cell displayed when the cell's validation state is Invalid or Warning.
@property (strong, nonatomic) BZGInfoCell *infoCell;

/// The cell's delegate
@property (strong, nonatomic) id<BZGFormCellDelegate> delegate;

// The BZGFormViewController section that the cell should be placed into
@property (assign, nonatomic) NSInteger formViewSection;

@end

@protocol BZGFormCellDelegate <NSObject>

- (id)initWithFormViewSection:(NSInteger)formViewSection;

/**
 * Tells the delegate that the form cell changed its validation state.
 */
- (void)formCell:(BZGFormCell *)formCell didChangeValidationState:(BZGValidationState)validationState;

@end
