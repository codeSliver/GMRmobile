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


#import "GMRDrawerSharedStateManager.h"

#import <QuartzCore/QuartzCore.h>

@implementation GMRDrawerSharedStateManager

+ (GMRDrawerSharedStateManager *)sharedManager {
    static GMRDrawerSharedStateManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GMRDrawerSharedStateManager alloc] init];
        [_sharedManager setLeftDrawerAnimationType:GMRDrawerAnimationTypeParallax];
        [_sharedManager setRightDrawerAnimationType:GMRDrawerAnimationTypeParallax];
    });
    
    return _sharedManager;
}

-(GMRDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(GMRDrawerSide)drawerSide{
    GMRDrawerAnimationType animationType;
    if(drawerSide == GMRDrawerSideLeft){
        animationType = self.leftDrawerAnimationType;
    }
    else {
        animationType = self.rightDrawerAnimationType;
    }
    
    GMRDrawerControllerDrawerVisualStateBlock visualStateBlock = nil;
    switch (animationType) {
        case GMRDrawerAnimationTypeSlide:
            visualStateBlock = [GMRDrawerVisualState slideVisualStateBlock];
            break;
        case GMRDrawerAnimationTypeSlideAndScale:
            visualStateBlock = [GMRDrawerVisualState slideAndScaleVisualStateBlock];
            break;
        case GMRDrawerAnimationTypeParallax:
            visualStateBlock = [GMRDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            break;
        case GMRDrawerAnimationTypeSwingingDoor:
            visualStateBlock = [GMRDrawerVisualState swingingDoorVisualStateBlock];
            break;
        default:
            visualStateBlock =  ^(GMRDrawerController * drawerController, GMRDrawerSide drawerSide, CGFloat percentVisible){
                
                UIViewController * sideDrawerViewController;
                CATransform3D transform;
                CGFloat maxDrawerWidth;
                
                if(drawerSide == GMRDrawerSideLeft){
                    sideDrawerViewController = drawerController.leftDrawerViewController;
                    maxDrawerWidth = drawerController.maximumLeftDrawerWidth;
                }
                else if(drawerSide == GMRDrawerSideRight){
                    sideDrawerViewController = drawerController.rightDrawerViewController;
                    maxDrawerWidth = drawerController.maximumRightDrawerWidth;
                }
                
                if(percentVisible > 1.0){
                    transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
                    
                    if(drawerSide == GMRDrawerSideLeft){
                        transform = CATransform3DTranslate(transform, maxDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
                    }else if(drawerSide == GMRDrawerSideRight){
                        transform = CATransform3DTranslate(transform, -maxDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
                    }
                }
                else {
                    transform = CATransform3DIdentity;
                }
                [sideDrawerViewController.view.layer setTransform:transform];
            };
            break;
    }
    return visualStateBlock;
}
@end
