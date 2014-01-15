//
//  GMRHomeCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRCommentPopUp.h"
#import "GMRCollapsableTableViewController.h"

@implementation GMRCommentPopUp

@synthesize commentTextView = _commentTextView;
@synthesize cancelButton = _cancelButton;
@synthesize parent = _parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initialize
{
    _commentTextView.delegate = self;
}
-(IBAction)cancelPressed:(id)sender
{
    [_commentTextView resignFirstResponder];
    
    [self removeFromSuperview];
}

-(IBAction)sendPressed:(id)sender
{
    [((GMRCollapsableTableViewController*)_parent) sendComment:_commentTextView.text];
    [self cancelPressed:nil];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+100,self.frame.size.width,self.frame.size.height)];
    
    [UIView commitAnimations];
    return YES;

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-100,self.frame.size.width,self.frame.size.height)];
    
    [UIView commitAnimations];
    return YES;

}
@end
