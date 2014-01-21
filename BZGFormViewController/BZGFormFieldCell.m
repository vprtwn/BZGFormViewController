//
//  BZGFormFieldCell.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "BZGFormFieldCell.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "BZGFormInfoCell.h"
#import "Constants.h"

@implementation BZGFormFieldCell

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        [self setDefaults];
        [self configureInfoCell];
        [self configureActivityIndicatorView];
        [self configureTextField];
        [self configureLabel];
        [self configureBindings];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidEndEditing:)
                                                     name:UITextFieldTextDidEndEditingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDefaults
{
    self.backgroundColor = BZG_FORMFIELD_BACKGROUND_COLOR;
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    self.imageView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.validationState = BZGValidationStateNone;
    self.shouldShowInfoCell = NO;
}

- (void)configureInfoCell
{
    self.infoCell = [[BZGFormInfoCell alloc] init];
}

- (void)configureTextField
{
    CGFloat textFieldX = self.bounds.size.width * 0.35;
    CGFloat textFieldY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        textFieldY = 12;
    }
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    CGRect textFieldFrame = CGRectMake(textFieldX,
                                       textFieldY,
                                       self.bounds.size.width - textFieldX - self.activityIndicatorView.frame.size.width,
                                       self.bounds.size.height);
    self.textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.textColor = BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR;
    self.textField.font = BZG_FORMFIELD_TEXTFIELD_FONT;
    self.textField.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textField];
}

- (void)configureLabel
{
    CGFloat labelX = 10;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        labelX = 15;
    }
    CGRect labelFrame = CGRectMake(labelX,
                                   0,
                                   self.textField.frame.origin.x - labelX,
                                   self.bounds.size.height);
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label.font = BZG_FORMFIELD_LABEL_FONT;
    self.label.textColor = BZG_FORMFIELD_LABEL_COLOR;
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

- (void)configureActivityIndicatorView
{
    CGFloat activityIndicatorWidth = self.bounds.size.height*0.7;
    CGRect activityIndicatorFrame = CGRectMake(self.bounds.size.width - activityIndicatorWidth,
                                               0,
                                               activityIndicatorWidth,
                                               self.bounds.size.height);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setFrame:activityIndicatorFrame];
    self.activityIndicatorView.hidesWhenStopped = NO;
    self.activityIndicatorView.hidden = YES;
    [self addSubview:self.activityIndicatorView];
}

- (void)configureBindings
{
    @weakify(self);

    RAC(self.textField, textColor) =
    [RACObserve(self, validationState) map:^UIColor *(NSNumber *validationState) {
        @strongify(self);
        if (self.textField.editing || self.textField.isFirstResponder) {
            return BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR;
        }
        switch (validationState.integerValue) {
            case BZGValidationStateInvalid:
                return BZG_FORMFIELD_TEXTFIELD_INVALID_COLOR;
                break;
            case BZGValidationStateValid:
            case BZGValidationStateValidating:
            case BZGValidationStateNone:
            default:
                return BZG_FORMFIELD_TEXTFIELD_NORMAL_COLOR;
                break;
        }
    }];

    RAC(self.activityIndicatorView, hidden) =
    [RACObserve(self, validationState) map:^NSNumber *(NSNumber *validationState) {
        @strongify(self);
        if (validationState.integerValue == BZGValidationStateValidating) {
            [self.activityIndicatorView startAnimating];
            return @NO;
        } else {
            [self.activityIndicatorView stopAnimating];
            return @YES;
        }
    }];

    RAC(self, accessoryType) =
    [RACObserve(self, validationState) map:^NSNumber *(NSNumber *validationState) {
        @strongify(self);
        if (validationState.integerValue == BZGValidationStateValid
            && !self.textField.editing) {
            return @(UITableViewCellAccessoryCheckmark);
        } else {
            return @(UITableViewCellAccessoryNone);
        }
    }];
}


+ (BZGFormFieldCell *)parentCellForTextField:(UITextField *)textField
{
    UIView *view = textField;
    while ((view = view.superview)) {
        if ([view isKindOfClass:[BZGFormFieldCell class]]) break;
    }
    return (BZGFormFieldCell *)view;
}


#pragma mark - UITextField notification selectors
// I'm using these notifications to flush the validation state signal.
// It works, but seems hacky. Is there a better way?

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if ([textField isEqual:self.textField]) {
        self.validationState = self.validationState;
        
        // Secure text fields clear on begin editing on iOS6+.
        // If it seems like the text field has been cleared,
        // invoke the text change delegate method again to ensure proper validation.
        if (textField.secureTextEntry && textField.text.length <= 1) {
            [self.textField.delegate textField:self.textField
                 shouldChangeCharactersInRange:NSMakeRange(0, textField.text.length)
                             replacementString:textField.text];
        }
    }
}

- (void)textFieldTextDidEndEditing:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if ([textField isEqual:self.textField]) {
        self.validationState = self.validationState;
    }
}

@end
