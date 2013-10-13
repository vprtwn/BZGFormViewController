//
//  BZGFormInfoCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//


#import "BZGFormInfoCell.h"

@implementation BZGFormInfoCell

- (id)initWithText:(NSString *)text
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        self.imageView.hidden = YES;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

        self.infoLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.infoLabel.font = [UIFont systemFontOfSize:14];
        self.infoLabel.adjustsFontSizeToFitWidth = NO;
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.text = text;

        // resize label and cell if necessary
        CGFloat verticalPadding = self.frame.size.height * 0.3;
        CGFloat currentHeight = self.infoLabel.frame.size.height;
        CGFloat heightThatFits = [self.infoLabel sizeThatFits:self.infoLabel.frame.size].height;
        CGFloat adjustedHeightThatFits = heightThatFits + verticalPadding*2;
        CGFloat newHeight = currentHeight;
        CGFloat yPadding = 0;
        if (adjustedHeightThatFits > currentHeight) {
            newHeight = adjustedHeightThatFits;
            yPadding = 0;
        }
        [self.infoLabel setFrame:CGRectMake(self.infoLabel.frame.origin.x,
                                           self.infoLabel.frame.origin.y + yPadding,
                                           self.infoLabel.frame.size.width,
                                           newHeight)];
        [self addSubview:self.infoLabel];
        [self setFrame:CGRectMake(self.frame.origin.x,
                                  self.frame.origin.y,
                                  self.frame.size.width,
                                  newHeight)];
    }
    return self;
}

@end
