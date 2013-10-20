//
//  BZGFormInfoCell.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

typedef BOOL (^BZGTapGestureBlock)();

@interface BZGFormInfoCell : UITableViewCell

/// The cell's label.
@property (nonatomic, strong) UILabel *infoLabel;

/**
 * Initializes a BZGFormInfoCell with the given text.
 */
- (id)initWithText:(NSString *)text;

/**
 * Sets the cell's info text, resizing the cell and label as necessary.
 */
- (void)setText:(NSString *)text;

/**
 * Sets the block executed when the cell is tapped.
 */
- (void)setTapGestureBlock:(BZGTapGestureBlock)block;

@end
