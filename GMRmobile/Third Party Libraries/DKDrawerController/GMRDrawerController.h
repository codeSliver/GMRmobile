// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

/**
 `GMRDrawerController` is a side drawer navigation container view controller designed to support the growing number of applications that leverage the side drawer paradigm. This library is designed to exclusively support side drawer navigation in light-weight, focused approach.
 
 ## Creating a GMRDrawerController
 `GMRDrawerController` is a container view controller, similiar to `UINavigationController` or `UITabBarController`, with up to three child view controllers - Center, LeftDrawer, and RightDrawer. To create a `GMRDrawerController`, you must first instantiate the drawer view controllers and the initial center controller, then call one of the init methods listed in this class.

 ## Handling a UINavigationController as the centerViewController
 `GMRDrawerController` automatically supports handling a `UINavigationController` as the `centerViewController`, and will correctly handle the proper gestures on each view (the navigation bar view as well as the content view for the visible view controller). Note that while this library does support other container view controllers, the open/close gestures are not customized to support them.
 
 ## Accessing GMRDrawerController from the Child View Controller
 You can leverage the category class (UIViewController+GMRDrawerController) included with this library to access information about the parent `GMRDrawerController`. Note that if you are contained within a UINavigationController, the `drawerContainerViewController` will still return the proper reference to the `drawerContainerViewController` parent, even though it is not the direct parent. Refer to the documentation included with the category for more information.

 ## How GMRDrawerOpenCenterInteractionMode is handled
 `GMRDrawerOpenCenterInteractionMode` controls how the user should be able to interact with the center view controller when either drawer is open. By default, this is set to `GMRDrawerOpenCenterInteractionModeNavigationBarOnly`, which allows the user to interact with UINavigationBarItems while either drawer is open (typicaly used to click the menu button to close). If you set the interaction mode to `GMRDrawerOpenCenterInteractionModeNone`, no items within the center view will be able to be interacted with while a drawer is open. Note that this setting has no effect at all on the `GMRCloseDrawerGestureMode`.
 
 ## How Open/Close Gestures are handled
 Two gestures are added to every instance of a drawer controller, one for pan and one for touch. `GMRDrawerController` is the delegate for each of the gesture recoginzers, and determines if a touch should be sent to the appropriate gesture when a touch is detected compared with the masks set for open and close gestures and the state of the drawer controller.
 
 ## Integrating with State Restoration
 In order to opt in to state restoration for `GMRDrawerController`, you must set the `restorationIdentifier` of your drawer controller. Instances of your centerViewController, leftDrawerViewController and rightDrawerViewController must also be configured with their own `restorationIdentifier` (and optionally a restorationClass) if you intend for those to be restored as well. If your GMRDrawerController had an open drawer when your app was sent to the background, that state will also be restored.
 
 ## What this library doesn't do.
 This library is not meant for:
    - Top or bottom drawer views
    - Displaying both drawers at one time
    - Displaying a minimum drawer width
    - Support container view controllers other than `UINavigationController` as the center view controller. 
 */

typedef NS_ENUM(NSInteger,GMRDrawerSide){
    GMRDrawerSideNone = 0,
    GMRDrawerSideLeft,
    GMRDrawerSideRight,
};

typedef NS_OPTIONS(NSInteger, GMROpenDrawerGestureMode) {
    GMROpenDrawerGestureModeNone                     = 0,
    GMROpenDrawerGestureModePanningNavigationBar     = 1 << 1,
    GMROpenDrawerGestureModePanningCenterView        = 1 << 2,
    GMROpenDrawerGestureModeBezelPanningCenterView   = 1 << 3,
    GMROpenDrawerGestureModeCustom                   = 1 << 4,
    GMROpenDrawerGestureModeAll                      =   GMROpenDrawerGestureModePanningNavigationBar     |
                                                        GMROpenDrawerGestureModePanningCenterView        |
                                                        GMROpenDrawerGestureModeBezelPanningCenterView   |
                                                        GMROpenDrawerGestureModeCustom,
};

typedef NS_OPTIONS(NSInteger, GMRCloseDrawerGestureMode) {
    GMRCloseDrawerGestureModeNone                    = 0,
    GMRCloseDrawerGestureModePanningNavigationBar    = 1 << 1,
    GMRCloseDrawerGestureModePanningCenterView       = 1 << 2,
    GMRCloseDrawerGestureModeBezelPanningCenterView  = 1 << 3,
    GMRCloseDrawerGestureModeTapNavigationBar        = 1 << 4,
    GMRCloseDrawerGestureModeTapCenterView           = 1 << 5,
    GMRCloseDrawerGestureModePanningDrawerView       = 1 << 6,
    GMRCloseDrawerGestureModeCustom                  = 1 << 7,
    GMRCloseDrawerGestureModeAll                     =   GMRCloseDrawerGestureModePanningNavigationBar    |
                                                        GMRCloseDrawerGestureModePanningCenterView       |
                                                        GMRCloseDrawerGestureModeBezelPanningCenterView  |
                                                        GMRCloseDrawerGestureModeTapNavigationBar        |
                                                        GMRCloseDrawerGestureModeTapCenterView           |
                                                        GMRCloseDrawerGestureModePanningDrawerView       |
                                                        GMRCloseDrawerGestureModeCustom,
};

typedef NS_ENUM(NSInteger, GMRDrawerOpenCenterInteractionMode) {
    GMRDrawerOpenCenterInteractionModeNone,
    GMRDrawerOpenCenterInteractionModeFull,
    GMRDrawerOpenCenterInteractionModeNavigationBarOnly,
};

@class  GMRDrawerController;
typedef void (^GMRDrawerControllerDrawerVisualStateBlock)(GMRDrawerController * drawerController, GMRDrawerSide drawerSide, CGFloat percentVisible);

@interface GMRDrawerController : UIViewController

///---------------------------------------
/// @name Accessing Drawer Container View Controller Properties
///---------------------------------------

/**
 The center view controller. 
 
 This can only be set via the init methods, as well as the `setNewCenterViewController:...` methods. The size of this view controller will automatically be set to the size of the drawer container view controller, and it's position is modified from within this class. Do not modify the frame externally.
 */
@property (nonatomic, strong) UIViewController * centerViewController;

/**
 The left drawer view controller. 
 
 The size of this view controller is managed within this class, and is automatically set to the appropriate size based on the `maximumLeftDrawerWidth`. Do not modify the frame externally.
 */
@property (nonatomic, strong) UIViewController * leftDrawerViewController;

/**
 The right drawer view controller. 
 
 The size of this view controller is managed within this class, and is automatically set to the appropriate size based on the `maximumRightDrawerWidth`. Do not modify the frame externally.
 */
@property (nonatomic, strong) UIViewController * rightDrawerViewController;

/**
 The maximum width of the `leftDrawerViewController`. 
 
 By default, this is set to 280. If the `leftDrawerViewController` is nil, this property will return 0.0;
 */
@property (nonatomic, assign) CGFloat maximumLeftDrawerWidth;

/**
 The maximum width of the `rightDrawerViewController`. 
 
 By default, this is set to 280. If the `rightDrawerViewController` is nil, this property will return 0.0;

 */
@property (nonatomic, assign) CGFloat maximumRightDrawerWidth;

/**
 The visible width of the `leftDrawerViewController`. 
 
 Note this value can be greater than `maximumLeftDrawerWidth` during the full close animation when setting a new center view controller;
 */
@property (nonatomic, assign, readonly) CGFloat visibleLeftDrawerWidth;

/**
 The visible width of the `rightDrawerViewController`. 
 
 Note this value can be greater than `maximumRightDrawerWidth` during the full close animation when setting a new center view controller;
 */
@property (nonatomic, assign, readonly) CGFloat visibleRightDrawerWidth;

/**
 The animation velocity of the open and close methods, measured in points per second.
 
 By default, this is set to 840 points per second (three times the default drawer width), meaning it takes 1/3 of a second for the `centerViewController` to open/close across the default drawer width. Note that there is a minimum .1 second duration for built in animations, to account for small distance animations.
 */
@property (nonatomic, assign) CGFloat animationVelocity;

/** 
 A boolean that determines whether or not the panning gesture will "hard-stop" at the maximum width for a given drawer side.
 
 By default, this value is set to YES. Enabling `shouldStretchDrawer` will give the pan a gradual asymptotic stopping point much like `UIScrollView` behaves. Note that if this value is set to YES, the `drawerVisualStateBlock` can be passed a `percentVisible` greater than 1.0, so be sure to handle that case appropriately.
 */
@property (nonatomic, assign) BOOL shouldStretchDrawer;

/**
 The current open side of the drawer. 
 
 Note this value will change as soon as a pan gesture opens a drawer, or when a open/close animation is finished.
 */
@property (nonatomic, assign, readonly) GMRDrawerSide openSide;

/**
 How a user is allowed to open a drawer using gestures. 
 
 By default, this is set to `GMROpenDrawerGestureModeNone`. Note these gestures may affect user interaction with the `centerViewController`, so be sure to use appropriately.
 */
@property (nonatomic, assign) GMROpenDrawerGestureMode openDrawerGestureModeMask;

/**
 How a user is allowed to close a drawer. 
 
 By default, this is set to `GMRCloseDrawerGestureModeNone`. Note these gestures may affect user interaction with the `centerViewController`, so be sure to use appropriately.
 */
@property (nonatomic, assign) GMRCloseDrawerGestureMode closeDrawerGestureModeMask;

/**
 The value determining if the user can interact with the `centerViewController` when a side drawer is open. 
 
 By default, it is `GMRDrawerOpenCenterInteractionModeNavigationBarOnly`, meaning that the user can only interact with the buttons on the `UINavigationBar`, if the center view controller is a `UINavigationController`. Otherwise, the user cannot interact with any other center view controller elements.
 */
@property (nonatomic, assign) GMRDrawerOpenCenterInteractionMode centerHiddenInteractionMode;

/**
 The flag determining if a shadow should be drawn off of `centerViewController` when a drawer is open. 
 
 By default, this is set to YES.
 */
@property (nonatomic, assign) BOOL showsShadow;

/**
 The flag determining if a custom background view should appear beneath the status bar, forcing the child content to be drawn lower than the status bar. This property is only available for > iOS 7.0 to take into account for the new behavior of the status bar.
 
 By default, this is set to NO. If running on < iOS 7.0, it will always return NO.
 */
@property (nonatomic, assign) BOOL showsStatusBarBackgroundView;

/**
 The color of the status bar background view if `showsStatusBarBackgroundView` is set to YES. This value is ignored in < iOS 7.0.
 
 By default, this is set `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor * statusBarViewBackgroundColor;

///---------------------------------------
/// @name Initializing a `GMRDrawerController`
///---------------------------------------

/**
 Creates and initializes an `GMRDrawerController` object with the specified center view controller, left drawer view controller, and right drawer view controller. 
 
 @param centerViewController The center view controller. This argument must not be `nil`.
 @param leftDrawerViewController The left drawer view controller.
 @param rightDrawerViewController The right drawer controller.
 
 @return The newly-initialized drawer container view controller.
 */
-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController;

/**
 Creates and initializes an `GMRDrawerController` object with the specified center view controller, left drawer view controller.
 
 @param centerViewController The center view controller. This argument must not be `nil`.
 @param leftDrawerViewController The left drawer view controller.
 
 @return The newly-initialized drawer container view controller.
 */
-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController;

/**
 Creates and initializes an `GMRDrawerController` object with the specified center view controller, right drawer view controller.
 
 @param centerViewController The center view controller. This argument must not be `nil`.
 @param rightDrawerViewController The right drawer controller.
 
 @return The newly-initialized drawer container view controller.
 */
-(id)initWithCenterViewController:(UIViewController *)centerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController;

///---------------------------------------
/// @name Opening and Closing a Drawer
///---------------------------------------

/**
 Toggles the drawer open/closed based on the `drawer` passed in. 
 
 Note that if you attempt to toggle a drawer closed while the other is open, nothing will happen. For example, if you pass in GMRDrawerSideLeft, but the right drawer is open, nothing will happen. In addition, the completion block will be called with the finished flag set to NO.
 
 @param drawerSide The `GMRDrawerSide` to toggle. This value cannot be `GMRDrawerSideNone`.
 @param animated Determines whether the `drawer` should be toggle animated.
 @param completion The block that is called when the toggle is complete, or if no toggle took place at all.
 
 */
-(void)toggleDrawerSide:(GMRDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

/**
 Closes the open drawer.
 
 @param animated Determines whether the drawer side should be closed animated
 @param completion The block that is called when the close is complete
 
 */
-(void)closeDrawerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

/**
 Opens the `drawer` passed in.
 
 @param drawerSide The `GMRDrawerSide` to open. This value cannot be `GMRDrawerSideNone`.
 @param animated Determines whether the `drawer` should be open animated.
 @param completion The block that is called when the toggle is open.
 
 */
-(void)openDrawerSide:(GMRDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

///---------------------------------------
/// @name Setting a new Center View Controller
///---------------------------------------

/**
 Sets the new `centerViewController`. 
 
 This sets the view controller and will automatically adjust the frame based on the current state of the drawer controller. If `closeAnimated` is YES, it will immediately change the center view controller, and close the drawer from its current position.
 
 @param centerViewController The new `centerViewController`.
 @param closeAnimated Determines whether the drawer should be closed with an animation.
 @param completion The block called when the animation is finsihed.
 
 */
-(void)setCenterViewController:(UIViewController *)centerViewController withCloseAnimation:(BOOL)closeAnimated completion:(void(^)(BOOL finished))completion;

/**
 Sets the new `centerViewController`. 
 
 This sets the view controller and will automatically adjust the frame based on the current state of the drawer controller. If `closeFullAnimated` is YES, the current center view controller will animate off the screen, the new center view controller will then be set, followed by the drawer closing across the full width of the screen.
 
 @param newCenterViewController The new `centerViewController`.
 @param fullCloseAnimated Determines whether the drawer should be closed with an animation.
 @param completion The block called when the animation is finsihed.
 
 */
-(void)setCenterViewController:(UIViewController *)newCenterViewController withFullCloseAnimation:(BOOL)fullCloseAnimated completion:(void(^)(BOOL finished))completion;

///---------------------------------------
/// @name Animating the Width of a Drawer
///---------------------------------------

/**
 Sets the maximum width of the left drawer view controller. 
 
 If the drawer is open, and `animated` is YES, it will animate the drawer frame as well as adjust the center view controller. If the drawer is not open, this change will take place immediately.
 
 @param width The new width of left drawer view controller. This must be greater than zero.
 @param animated Determines whether the drawer should be adjusted with an animation.
 @param completion The block called when the animation is finished.
 
 */
-(void)setMaximumLeftDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

/**
 Sets the maximum width of the right drawer view controller. 
 
 If the drawer is open, and `animated` is YES, it will animate the drawer frame as well as adjust the center view controller. If the drawer is not open, this change will take place immediately.
 
 @param width The new width of right drawer view controller. This must be greater than zero.
 @param animated Determines whether the drawer should be adjusted with an animation.
 @param completion The block called when the animation is finished.
 
 */
-(void)setMaximumRightDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

///---------------------------------------
/// @name Previewing a Drawer
///---------------------------------------

/**
 Bounce preview for the specified `drawerSide` a distance of 40 points.
 
 @param drawerSide The drawer to preview. This value cannot be `GMRDrawerSideNone`.
 @param completion The block called when the animation is finsihed.
 
 */
-(void)bouncePreviewForDrawerSide:(GMRDrawerSide)drawerSide completion:(void(^)(BOOL finished))completion;

/**
 Bounce preview for the specified `drawerSide`.
 
 @param drawerSide The drawer side to preview. This value cannot be `GMRDrawerSideNone`.
 @param distance The distance to bounce.
 @param completion The block called when the animation is finsihed.
 
 */
-(void)bouncePreviewForDrawerSide:(GMRDrawerSide)drawerSide distance:(CGFloat)distance completion:(void(^)(BOOL finished))completion;

///---------------------------------------
/// @name Custom Drawer Animations
///---------------------------------------

/**
 Sets a callback to be called when a drawer visual state needs to be updated. 
 
 This block is responsible for updating the drawer's view state, and the drawer controller will handle animating to that state from the current state. This block will be called when the drawer is opened or closed, as well when the user is panning the drawer. This block is not responsible for doing animations directly, but instead just updating the state of the properies (such as alpha, anchor point, transform, etc). Note that if `shouldStretchDrawer` is set to YES, it is possible for `percentVisible` to be greater than 1.0. If `shouldStretchDrawer` is set to NO, `percentVisible` will never be greater than 1.0.
 
 Note that when the drawer is finished opening or closing, the side drawer controller view will be reset with the following properies:
 
    - alpha: 1.0
    - transform: CATransform3DIdentity
    - anchorPoint: (0.5,0.5)
 
 @param drawerVisualStateBlock A block object to be called that allows the implementer to update visual state properties on the drawer. `percentVisible` represents the amount of the drawer space that is current visible, with drawer space being defined as the edge of the screen to the maxmimum drawer width. Note that you do have access to the drawerController, which will allow you to update things like the anchor point of the side drawer layer.
 */
-(void)setDrawerVisualStateBlock:(void(^)(GMRDrawerController * drawerController, GMRDrawerSide drawerSide, CGFloat percentVisible))drawerVisualStateBlock;

///---------------------------------------
/// @name Gesture Completion Handling
///---------------------------------------

/**
 Sets a callback to be called when a gesture has been completed.
 
 This block is called when a gesture action has been completed. You can query the `openSide` of the `drawerController` to determine what the new state of the drawer is.
 
 @param gestureCompletionBlock A block object to be called that allows the implementer be notified when a gesture action has been completed.
 */
-(void)setGestureCompletionBlock:(void(^)(GMRDrawerController * drawerController, UIGestureRecognizer * gesture))gestureCompletionBlock;

///---------------------------------------
/// @name Custom Gesture Handler
///---------------------------------------

/**
 Sets a callback to be called to determine if a UIGestureRecognizer should recieve the given UITouch.
 
 This block provides a way to allow a gesture to be recognized with custom logic. For example, you may have a certain part of your view that should accept a pan gesture recognizer to open the drawer, but not another a part. If you return YES, the gesture is recognized and the appropriate action is taken. This provides similar support to how Facebook allows you to pan on the background view of the main table view, but not the content itself. You can inspect the `openSide` property of the `drawerController` to determine the current state of the drawer, and apply the appropriate logic within your block.
 
 Note that either `openDrawerGestureModeMask` must contain `GMROpenDrawerGestureModeCustom`, or `closeDrawerGestureModeMask` must contain `GMRCloseDrawerGestureModeCustom` for this block to be consulted.
 
 @param gestureShouldRecognizeTouchBlock A block object to be called to determine if the given `touch` should be recognized by the given gesture.
 */
-(void)setGestureShouldRecognizeTouchBlock:(BOOL(^)(GMRDrawerController * drawerController, UIGestureRecognizer * gesture, UITouch * touch))gestureShouldRecognizeTouchBlock;

@end
