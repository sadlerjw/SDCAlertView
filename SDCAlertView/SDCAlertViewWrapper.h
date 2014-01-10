//
//  SDCAlertViewWrapper.h
//  Pods
//
//  Created by Jason Sadler on 1/6/2014.
//
//

#import <Foundation/Foundation.h>

@class SDCAlertView;
@class SDCAlertViewWrapper;

/**
 A convenience class that contains either an SDCAlertView (if running on iOS 7 or later)
 or a UIAlertView (if running on iOS 6 or earlier). Provides numerous methods and properties
 to simplify usage by forwarding them to the proper implementation.
 */

typedef NS_ENUM(NSInteger, SDCAlertViewStyle) {
    SDCAlertViewStyleDefault = 0,
    SDCAlertViewStyleSecureTextInput,
    SDCAlertViewStylePlainTextInput,
    SDCAlertViewStyleLoginAndPasswordInput
};

@protocol SDCAlertViewWrapperDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(SDCAlertViewWrapper *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(SDCAlertViewWrapper *)alertView;

- (void)willPresentAlertView:(SDCAlertViewWrapper *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(SDCAlertViewWrapper *)alertView;  // after animation

- (void)alertView:(SDCAlertViewWrapper *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(SDCAlertViewWrapper *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(SDCAlertViewWrapper *)alertView;

@end

@interface SDCAlertViewWrapper : NSObject

@property (nonatomic, strong, readonly) id alertView;

@property(nonatomic) NSInteger tag;                // default is 0

@property(nonatomic, weak) id<SDCAlertViewWrapperDelegate> delegate;    // weak reference
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;   // secondary explanation text

- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message
					 delegate:(id)delegate
			cancelButtonTitle:(NSString *)cancelButtonTitle
			otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonWithTitle:(NSString *)title;    // returns index of button. 0 based.
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@property(nonatomic,readonly) NSInteger numberOfButtons;
@property(nonatomic) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used
@property(nonatomic,readonly,getter=isVisible) BOOL visible;

// shows popup alert animated.
- (void)show;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

// Alert view style - defaults to UIAlertViewStyleDefault
@property(nonatomic,assign) SDCAlertViewStyle alertViewStyle NS_AVAILABLE_IOS(5_0);

/* Retrieve a text field at an index - raises NSRangeException when textFieldIndex is out-of-bounds.
 The field at index 0 will be the first text field (the single field or the login field), the field at index 1 will be the password field. */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex NS_AVAILABLE_IOS(5_0);

- (void)addSubview:(UIView*)subview;

@end