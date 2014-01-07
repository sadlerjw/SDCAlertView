    //
//  SDCAlertViewWrapper.m
//  Pods
//
//  Created by Jason Sadler on 1/6/2014.
//
//

#import "SDCAlertViewWrapper.h"
#import "SDCAlertView.h"

#define IOS_7 [SDCAlertViewWrapper isIOS7]

// This set is used to essentially retain instances of SDCAlertViewWrapper
// for as long as its attendant alert view (SDCAlertView or UIAlertView)
// is showing. Consumers of this class should be able to treat
// SDCAlertViewWrapper as if it's an alias to either SDCAlertView or
// UIAlertView, so they should expect the system to retain it once
// they call [myAlertViewWrapper show].
// The instnace of SDCAlertViewWrapper is the delegate on the alert view,
// but UIAlertView's delegate property is an assign property - meaning that
// if we don't make sure this class is retained by something else,
// alertView.delegate will point to garbage memory.
// When we detect that the alert is about to be shown, we add the wrapper
// to this set; and when the alert has finished being shown, we remove it.
static NSMutableSet* wrappersForShowingAlerts = nil;

@interface SDCAlertViewWrapper () <SDCAlertViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) id alertView;
@end

@implementation SDCAlertViewWrapper

@synthesize alertView;
@synthesize delegate;

+ (BOOL)isIOS7 {
    static dispatch_once_t once;
    static BOOL isIOS7;
    dispatch_once(&once, ^ {
        NSString* majorVersion = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0];
        isIOS7 = [majorVersion integerValue] >= 7;
    });
    return isIOS7;
}

+ (void)initialize {
    wrappersForShowingAlerts = [NSMutableSet set];
}

- (id)init {
    self = [super init];
    if (self) {
        if (IOS_7) {
            self.alertView = [[SDCAlertView alloc] init];
            ((SDCAlertView*)self.alertView).delegate = self;
        } else {
            self.alertView = [[UIAlertView alloc] init];
            ((UIAlertView*)self.alertView).delegate = self;
        }
        
        NSLog(@"New alert without title, %@", self);
    }
    return self;
}

- (void)dealloc {
    if (self.alertView && [self.alertView delegate] == self) {
        // If we're being released, we want to make sure that
        // self.alertView.delegate doesn't point at garbage, so we
        // manually nil it out. (See doc block on wrappersForShowingAlerts
        // for details.
        [self.alertView setDelegate:nil];
    }
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    // Explicitly NOT calling [self init] - we want to call different super constructors.
    self = [super init];
    if (self) {
        self.alertView = IOS_7 ? [SDCAlertView alloc] : [UIAlertView alloc];
        self.alertView = [self.alertView initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        
        self.delegate = aDelegate;
        
        NSLog(@"New alert with title, %@", self);
        
        va_list argumentList;
		va_start(argumentList, otherButtonTitles);
		for (NSString *buttonTitle = otherButtonTitles; buttonTitle != nil; buttonTitle = va_arg(argumentList, NSString *)) {
			[self.alertView addButtonWithTitle:buttonTitle];
        }
        
    }
    return self;
}

- (NSInteger)tag {
    return [self.alertView tag];
}

- (void)setTag:(NSInteger)tag {
    [self.alertView setTag:tag];
}

- (NSString *)title {
    return [self.alertView title];
}

- (void)setTitle:(NSString *)title {
    [self.alertView setTitle:title];
}

- (NSString *)message {
    return [self.alertView message];
}

- (void)setMessage:(NSString *)message {
    [self.alertView setMessage:message];
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    return [self.alertView addButtonWithTitle:title];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    return [self.alertView buttonTitleAtIndex:buttonIndex];
}

- (NSInteger)numberOfButtons {
    return [self.alertView numberOfButtons];
}

- (NSInteger)cancelButtonIndex {
    return [self.alertView cancelButtonIndex];
}

- (void)setCancelButtonIndex:(NSInteger)cancelButtonIndex {
    [self.alertView setCancelButtonIndex:cancelButtonIndex];
}

- (NSInteger)firstOtherButtonIndex {
    return [self.alertView firstOtherButtonIndex];
}

- (BOOL)isVisible {
    return [self.alertView isVisible];
}

- (void)show {
    [self.alertView show];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [self.alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (SDCAlertViewStyle)alertViewStyle {
    if (IOS_7) {
        return [((SDCAlertView*)self.alertView) alertViewStyle];
    } else {
        UIAlertViewStyle style = [((UIAlertView*)self.alertView) alertViewStyle];
        switch (style) {
            case UIAlertViewStyleDefault:
                return SDCAlertViewStyleDefault;
                break;
            case UIAlertViewStyleSecureTextInput:
                return SDCAlertViewStyleSecureTextInput;
                break;
            case UIAlertViewStyleLoginAndPasswordInput:
                return SDCAlertViewStyleLoginAndPasswordInput;
                break;
            case UIAlertViewStylePlainTextInput:
            default:
                return SDCAlertViewStylePlainTextInput;
                break;
        }
    }
}

- (void)setAlertViewStyle:(SDCAlertViewStyle)alertViewStyle {
    switch (alertViewStyle) {
        case SDCAlertViewStyleDefault:
            [self privateSetAlertViewStyle:IOS_7 ? SDCAlertViewStyleDefault : UIAlertViewStyleDefault];
            break;
        case SDCAlertViewStyleSecureTextInput:
            [self privateSetAlertViewStyle:IOS_7 ? SDCAlertViewStyleSecureTextInput : UIAlertViewStyleSecureTextInput];
            break;
        case SDCAlertViewStyleLoginAndPasswordInput:
            [self privateSetAlertViewStyle:IOS_7 ? SDCAlertViewStyleLoginAndPasswordInput : UIAlertViewStyleLoginAndPasswordInput];
            break;
        case SDCAlertViewStylePlainTextInput:
            [self privateSetAlertViewStyle:IOS_7 ? SDCAlertViewStylePlainTextInput : UIAlertViewStylePlainTextInput];
            break;
        default:
            break;
    }
}

- (void)privateSetAlertViewStyle:(NSInteger)alertViewStyle {
    if (IOS_7) {
        ((SDCAlertView*)self.alertView).alertViewStyle = (SDCAlertViewStyle)alertViewStyle;
    } else {
        ((UIAlertView*)self.alertView).alertViewStyle = (UIAlertViewStyle)alertViewStyle;
    }
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex {
    return [self.alertView textFieldAtIndex:textFieldIndex];
}

- (void)addSubview:(UIView*)subview {
    if (IOS_7) {
        [((SDCAlertView*)self.alertView).contentView addSubview:subview];
    } else {
        [self.alertView addSubview:subview];
    }
}

#pragma mark - Delegate methods

- (void)alertView:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertViewCancel:(id)alertView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewCancel:)]) {
        [delegate alertViewCancel:self];
    }
}

- (void)willPresentAlertView:(id)alertView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    
    // Make sure that sometihng is retaining us. See details in doc
    // block on wrappersForShowingAlerts for details.
    [wrappersForShowingAlerts addObject:self];
}

- (void)didPresentAlertView:(id)alertView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [self.delegate didPresentAlertView:self];
    }
}

- (void)alertView:(id)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(id)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
    
    // We don't require being retained by the system anymore.
    // See block on wrappersForShowingAlerts for details.
    [wrappersForShowingAlerts removeObject:self];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(id)alertView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [self.delegate alertViewShouldEnableFirstOtherButton:self];
    }
    return YES;
}

@end
