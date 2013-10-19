//
//  BZGFloatingPlaceholderFormFieldCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFloatingPlaceholderFormFieldCell.h"
#import "JVFloatLabeledTextField.h"

@implementation BZGFloatingPlaceholderFormFieldCell

- (void)configureTextField
{
    CGFloat leftPadding = 10;
    CGRect textFieldFrame = CGRectMake(leftPadding,
                                       0,
                                       self.bounds.size.width - self.activityIndicatorView.frame.size.width - leftPadding,
                                       self.bounds.size.height);
    self.textField = [[JVFloatLabeledTextField alloc] initWithFrame:textFieldFrame];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.textColor = [UIColor blackColor];
    [self addSubview:self.textField];
}

@end
