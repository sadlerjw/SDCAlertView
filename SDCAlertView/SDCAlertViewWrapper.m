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

@interface SDCAlertViewWrapper ()
@property (nonatomic, strong) id alertView;
@end

@implementation SDCAlertViewWrapper

@synthesize alertView;

+ (BOOL)isIOS7 {
    static dispatch_once_t once;
    static BOOL isIOS7;
    dispatch_once(&once, ^ {
        NSString* majorVersion = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0];
        isIOS7 = [majorVersion integerValue] >= 7;
    });
    return isIOS7;
}

- (id)init {
    self = [super init];
    if (self) {
        self.alertView = IOS_7 ? [[SDCAlertView alloc] init] : [[UIAlertView alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    // Explicitly NOT calling [self init] - we want to call different super constructors.
    self = [super init];
    if (self) {
        self.alertView = IOS_7 ? [SDCAlertView alloc] : [UIAlertView alloc];
        self.alertView = [self.alertView initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        
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

- (id)delegate {
    return [self.alertView delegate];
}

- (void)setDelegate:(id)delegate {
    [self.alertView setDelegate:delegate];
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


@end
