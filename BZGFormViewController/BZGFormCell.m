//
//  BZGFormCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormCell.h"

@implementation BZGFormCell

- (void)setValidationState:(BZGValidationState)validationState
{
    _validationState = validationState;
    if (self.delegate) {
        [self.delegate formCell:self didChangeValidationState:validationState];
    }
}

@end
