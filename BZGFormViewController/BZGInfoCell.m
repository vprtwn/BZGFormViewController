//
//  BZGInfoCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGInfoCell.h"
#import "Constants.h"

@interface BZGInfoCell () {
    void (^_tapGestureBlock) ();
}

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation BZGInfoCell

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithText:(NSString *)text
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        [self setup];
        self.infoLabel.text = text;
        [self updateSize];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.infoLabel.text = text;
    [self updateSize];
}

- (void)setTapGestureBlock:(void(^)())block
{
    _tapGestureBlock = block;
}

- (void)setup
{
    // Hide default components
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    self.imageView.hidden = YES;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = BZG_INFO_BACKGROUND_COLOR;
    
    self.infoLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.infoLabel.font = BZG_INFO_LABEL_FONT;
    self.infoLabel.adjustsFontSizeToFitWidth = NO;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.text = @"";
    self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)tapGestureAction
{
    if (_tapGestureBlock) {
        _tapGestureBlock();
    }
}

- (void)updateSize
{
    CGFloat verticalPadding = 10;
    CGSize currentSize = self.infoLabel.frame.size;
    CGFloat currentHeight = currentSize.height;
    CGFloat heightThatFits = [self.infoLabel sizeThatFits:currentSize].height;
    CGFloat adjustedHeightThatFits = heightThatFits + verticalPadding*2;
    CGFloat newHeight = currentHeight;
    CGFloat yPadding = 0;
    if (adjustedHeightThatFits > currentHeight) {
        newHeight = adjustedHeightThatFits;
        yPadding = 0;
    }
    [self.infoLabel setFrame:CGRectMake(0,
                                        yPadding,
                                        self.frame.size.width,
                                        newHeight)];
    [self addSubview:self.infoLabel];
    [self setFrame:CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              self.frame.size.width,
                              newHeight)];
}

@end
