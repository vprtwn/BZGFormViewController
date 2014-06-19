//
//  BZGFormCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormCell.h"
#import "Constants.h"

@implementation BZGFormCell

- (id)init
{
    return [self initWithFormViewSection:0];
}

- (id)initWithFormViewSection:(NSInteger)formViewSection
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        // Hide default elements
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        self.imageView.hidden = YES;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BZG_BACKGROUND_COLOR;
        
        _validationState = BZGValidationStateNone;
        _formViewSection = formViewSection;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ is not supported. Please use init instead.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setValidationState:(BZGValidationState)validationState
{
    _validationState = validationState;
    if (self.delegate) {
        [self.delegate formCell:self didChangeValidationState:validationState];
    }
}

@end
