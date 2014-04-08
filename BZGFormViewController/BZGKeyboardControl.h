//
//  BZGKeyboardControl.h
//
//  https://github.com/benzguo/BZGFormViewController
//

#import <UIKit/UIKit.h>

@class BZGTextFieldCell;

@interface BZGKeyboardControl : UIView

@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) BZGTextFieldCell *previousCell;
@property (nonatomic, strong) BZGTextFieldCell *currentCell;
@property (nonatomic, strong) BZGTextFieldCell *nextCell;

@end
