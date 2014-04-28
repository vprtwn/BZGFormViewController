//
//  BZGKeyboardControl.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGKeyboardControl.h"

const CGFloat BZGKeyboardControlButtonSpacing = 22;

@implementation BZGKeyboardControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.previousButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105
                                                                            target:nil
                                                                            action:nil];
        self.nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106
                                                                        target:nil
                                                                        action:nil];
        
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                        target:nil
                                                                        action:nil];
        
        self.previousButton.enabled     = NO;
        self.nextButton.enabled         = NO;
        self.previousButton.tintColor   = [UIColor blackColor];
        self.nextButton.tintColor       = [UIColor blackColor];
        self.doneButton.tintColor       = [UIColor blackColor];
        
        UIBarButtonItem *buttonSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                       target:self
                                                                                       action:nil];
        buttonSpacing.width = BZGKeyboardControlButtonSpacing;
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:self
                                                                                       action:nil];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.frame];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [toolbar setItems:@[self.previousButton, buttonSpacing, self.nextButton, flexibleSpace, self.doneButton]];
        [self addSubview:toolbar];
    }
    return self;
}


- (void)setPreviousCell:(BZGTextFieldCell *)previousCell {
    _previousCell = previousCell;
    self.previousButton.enabled = !!previousCell;
}


- (void)setNextCell:(BZGTextFieldCell *)nextCell {
    _nextCell = nextCell;
    self.nextButton.enabled = !!nextCell;
}

@end
