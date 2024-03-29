/*
    AccordionView.m

    Created by Wojtek Siudzinski on 19.12.2011.
    Copyright (c) 2011 Appsome. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#import "AccordionView.h"
#import "GMRHomeCellView.h"

@implementation AccordionView

@synthesize selectedIndex, isHorizontal, animationDuration, animationCurve;
@synthesize allowsMultipleSelection, selectionIndexes, delegate, startsClosed;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        views = [NSMutableArray new];
        headers = [NSMutableArray new];
        originalSizes = [NSMutableArray new];
        
        self.backgroundColor = [UIColor clearColor];
        prevCategory = -1;
        prevIndex = -1;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        
        self.userInteractionEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        
        animationDuration = 0.3;
        animationCurve = UIViewAnimationCurveEaseIn;
        
        self.autoresizesSubviews = NO;
        scrollView.autoresizesSubviews = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        [scrollView setBounces:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        self.allowsMultipleSelection = NO;

        self.startsClosed = NO;
    }
    
    return self;
}

- (void)addHeader:(id)aHeader withView:(id)aView {
    if ((aHeader != nil) && (aView != nil)) {
        [headers addObject:aHeader];        
        [views addObject:aView];        
        [originalSizes addObject:[NSValue valueWithCGSize:[aView frame].size]];
        
        [aView setAutoresizingMask:UIViewAutoresizingNone];
        [aView setClipsToBounds:YES];
        
        CGRect frame = [aHeader frame];
        
        if (self.isHorizontal) {
            // TODO
        } else {
            frame.origin.x = 0;
            frame.size.width = [self frame].size.width;
            [aHeader setFrame:frame];
            
            frame = [aView frame];
            frame.origin.x = 0;
            frame.size.width = [self frame].size.width;
            [aView setFrame:frame];
        }
        
        [scrollView addSubview:aView];
        [scrollView addSubview:aHeader];
        
        GMRHomeCellView * headerView = (GMRHomeCellView*)aHeader;
        
            [aHeader setTag:[headers count] - 1];
            headerView.likeButton.tag = [headers count]-1;
            headerView.commentButton.tag = [headers count]-1;
            headerView.groupButton.tag = [headers count]-1;
            headerView.userImageView.tag = [headers count] - 1;
            headerView.movieButton.tag = [headers count] - 1;
            [headerView.likeButton addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.commentButton addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.groupButton addTarget:self action:@selector(groupPressed:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.userImageView addTarget:self action:@selector(userProfilePressed:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.movieButton addTarget:self action:@selector(moviePressed:) forControlEvents:UIControlEventTouchUpInside];

        
        if (!self.startsClosed && [selectionIndexes count] == 0) {
            [self setSelectedIndex:-1];
        }
    }
}

-(void)moviePressed:(id)sender
{
    int movieId = ((UIButton*)sender).tag;
    [self.delegate moviePressed:movieId];
}
-(void)userProfilePressed:(id)sender
{
    int userId = ((UIButton*)sender).tag;
    [self.delegate userProfilePressed:userId];
}
-(void)likePressed:(id)sender
{
        if (([selectionIndexes firstIndex] == [sender tag])&&(prevCategory == 0)) {
            [self setSelectionIndexes:[NSIndexSet indexSet]];
        } else {
            [self setSelectedIndex:[sender tag]];
        }
    prevCategory = 0;

}

-(void)commentPressed:(id)sender
{
    if (([selectionIndexes firstIndex] == [sender tag])&&(prevCategory == 1)) {
        [self setSelectionIndexes:[NSIndexSet indexSet]];
    } else {
        [self setSelectedIndex:[sender tag]];
    }
    prevCategory = 1;

}

-(void)groupPressed:(id)sender
{
    if (([selectionIndexes firstIndex] == [sender tag])&&(prevCategory == 2)) {
        [self setSelectionIndexes:[NSIndexSet indexSet]];
    } else {
        [self setSelectedIndex:[sender tag]];
    }
    prevCategory = 2;

}
- (void)removeHeaderAtIndex:(NSInteger)index {
    if (index > [headers count] - 1) return;

    NSMutableIndexSet *cleanIndexes = [NSMutableIndexSet new];
    [selectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx == index) return;
        if (idx > index) idx--;
        
        [cleanIndexes addIndex:idx];
    }];
    
    for (UIView *aHeader in headers) {
        if (aHeader.tag > index) {
            aHeader.tag--;
        }
    }
    UIView *aHeader = [headers objectAtIndex:index];
    [aHeader removeFromSuperview];
    [headers removeObjectAtIndex:index];
    
    
    UIView *aView = [views objectAtIndex:index];
    [aView removeFromSuperview];
    [views removeObjectAtIndex:index];
    
    [originalSizes removeObjectAtIndex:index];
    
    [self setSelectionIndexes:cleanIndexes];
}

- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes {
    if ([headers count] == 0) return;
    if (!allowsMultipleSelection && [aSelectionIndexes count] > 1) {
        aSelectionIndexes = [NSIndexSet indexSetWithIndex:[aSelectionIndexes firstIndex]];
    }
    
    NSMutableIndexSet *cleanIndexes = [NSMutableIndexSet new];
    [aSelectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx > [headers count] - 1) return;
        
        [cleanIndexes addIndex:idx];
    }];

    selectionIndexes = cleanIndexes;
    [self setNeedsLayout];
    
    if ([delegate respondsToSelector:@selector(accordion:didChangeSelection:)]) {
        [delegate accordion:self didChangeSelection:self.selectionIndexes];
    }
}

- (void)setSelectedIndex:(NSInteger)aSelectedIndex {
    [self setSelectionIndexes:[NSIndexSet indexSetWithIndex:aSelectedIndex]];    
}

- (NSInteger)selectedIndex {
    return [selectionIndexes firstIndex];
}

- (void)setOriginalSize:(CGSize)size forIndex:(NSUInteger)index {
    if (index >= [views count]) return;
    
    [originalSizes replaceObjectAtIndex:index withObject:[NSValue valueWithCGSize:size]];
    
    if ([selectionIndexes containsIndex:index]) [self setNeedsLayout];
}

- (void)setStartsClosed:(BOOL)itStartsClosed {
    if (itStartsClosed) {
        [self setSelectionIndexes:[NSIndexSet indexSet]];
    }

    startsClosed = itStartsClosed;
}

- (void)touchDown:(id)sender {
    if (allowsMultipleSelection) {
        NSMutableIndexSet *mis = [selectionIndexes mutableCopy];
        if ([selectionIndexes containsIndex:[sender tag]]) {
            [mis removeIndex:[sender tag]];
        } else {
            [mis addIndex:[sender tag]];
        }
        
        [self setSelectionIndexes:mis];
    } else {
        // If the touched section is already opened, close it.
        if ([selectionIndexes firstIndex] == [sender tag]) {
            [self setSelectionIndexes:[NSIndexSet indexSet]];
        } else {
            [self setSelectedIndex:[sender tag]];
        }
    }
}

- (void)animationDone {
    for (int i=0; i<[views count]; i++) {
        if (![selectionIndexes containsIndex:i]) [[views objectAtIndex:i] setHidden:YES];
    }
}

- (void)layoutSubviews {
    if (self.isHorizontal) {
        // TODO
    } else {
        int height = 0;
        for (int i=0; i<[views count]; i++) {
            id aHeader = [headers objectAtIndex:i];
            id aView = [views objectAtIndex:i];
            
            CGSize originalSize = [[originalSizes objectAtIndex:i] CGSizeValue];
            CGRect viewFrame = [aView frame];
            CGRect headerFrame = [aHeader frame];
            headerFrame.origin.y = height;
            height += headerFrame.size.height;
            viewFrame.origin.y = height;
            
            if ([selectionIndexes containsIndex:i]) {
                viewFrame.size.height = originalSize.height;
                [aView setFrame:CGRectMake(0, viewFrame.origin.y, [self frame].size.width, 0)];
                [aView setHidden:NO];
            } else {
                viewFrame.size.height = 0;
            }
            
            height += viewFrame.size.height;
            
            if (!CGRectEqualToRect([aHeader frame], headerFrame) || !CGRectEqualToRect([aView frame], viewFrame)) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(animationDone)];
                [UIView setAnimationDuration:self.animationDuration];
                [UIView setAnimationCurve:self.animationCurve];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [aHeader setFrame:headerFrame];                
                [aView setFrame:viewFrame];
                [UIView commitAnimations];
            }
        }
        
        CGPoint offset = scrollView.contentOffset;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationCurve:self.animationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [scrollView setContentSize:CGSizeMake([self frame].size.width, height)];
        [UIView commitAnimations];

        
        if (offset.y + scrollView.frame.size.height > height) {
            offset.y = height - scrollView.frame.size.height;
            if (offset.y < 0) {
                offset.y = 0;
            }
        }
        [scrollView setContentOffset:offset animated:YES];
        [self scrollViewDidScroll:scrollView];
    }
}

#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int i = 0;
    for (UIView *view in views) {
        if (self.isHorizontal) {
            // TODO
        } else {
            if (view.frame.size.height > 0) {
                UIView *header = [headers objectAtIndex:i];
                CGRect content = view.frame;
                content.origin.y -= header.frame.size.height;
                content.size.height += header.frame.size.height;
                
                CGRect frame = header.frame;                
                if (CGRectContainsPoint(content, aScrollView.contentOffset)) {
                    if (aScrollView.contentOffset.y < content.origin.y + content.size.height - frame.size.height) {
                        frame.origin.y = aScrollView.contentOffset.y;
                    } else {
                        frame.origin.y = content.origin.y + content.size.height - frame.size.height;
                    }
                    
                } else {
                    frame.origin.y = view.frame.origin.y - frame.size.height;
                }
                header.frame = frame;
            }
        }
        i++;
    }
}

-(void)moveLastScrollItem
{
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+68)];
}
@end
