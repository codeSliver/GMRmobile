//
//  SectionView.h
//  CustomTableTest
//
//  Created by   on 5/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol GMRSectionView;

@interface GMRSectionView : UIView

@property (nonatomic, retain) UILabel *sectionTitle;
@property (nonatomic, retain) UIImageView *signImage;
@property (nonatomic, retain) UIButton *discButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id<GMRSectionView> delegate;

@property (nonatomic, retain) UIImageView *heartImage1;
@property (nonatomic, retain) UIImageView *heartImage2;
@property (nonatomic, retain) UIImageView *heartImage3;
@property (nonatomic, retain) UIImageView *heartImage4;
@property (nonatomic, retain) UIImageView *heartImage5;
@property (nonatomic, strong) UILabel * commentsLabel;
@property (nonatomic) int commentsNo;


- (id)initWithFrame:(CGRect)frame WithSectionDict: (NSDictionary *) sectionDict Section:(NSInteger)sectionNumber delegate: (id <GMRSectionView>) delegate;
- (void) discButtonPressed : (id) sender;
- (void) toggleButtonPressed : (BOOL) flag;

@end

@protocol GMRSectionView <NSObject>

@optional
- (void) sectionClosed : (NSInteger) section;
- (void) sectionOpened : (NSInteger) section;
- (void) sectionPressed: (NSInteger) section;
- (void) ratePressed;
-(void) commentPressed;
@end