//
//  SectionView.m
//  CustomTableTest
//
//  Created by   on 5/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMRSectionView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GMRSectionView

@synthesize section;
@synthesize sectionTitle,signImage;
@synthesize discButton;
@synthesize delegate;
@synthesize heartImage1,heartImage2,heartImage3,heartImage4,heartImage5;
@synthesize commentsLabel = _commentsLabel;
@synthesize commentsNo = _commentsNo;

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame WithSectionDict: (NSDictionary *) sectionDict Section:(NSInteger)sectionNumber delegate: (id <GMRSectionView>) Delegate
{
    self = [super initWithFrame:frame];
    if (self) {
   
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discButtonPressed:)];
        [self addGestureRecognizer:tapGesture];
        
        self.userInteractionEnabled = YES;

        self.section = sectionNumber;
        self.delegate = Delegate;
        
        NSString *imageName = section == 3 ? @"person-icon.png" : (section == 4 ? @"people-icon.png" : (section == 5 ? @"chat-icon.png" : @"chat-icon.png"));
        
        UIImage *image = [UIImage imageNamed:imageName];
        int imageHeight = 24;
        int imageWidth = 20;
        signImage = [[UIImageView alloc] initWithImage:image];
        CGRect signFrame = CGRectMake(20, (frame.size.height-image.size.height)/2, image.size.width, image.size.height);
        signImage.frame = signFrame;
        [self addSubview:signImage];
        
        if (section == 0) {
            signImage.hidden = YES;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 250, frame.size.height - 5)];
           
            NSString * titleStr = [NSString stringWithFormat:@"%@",[sectionDict objectForKey:@"m_genere"]];
            label.text = titleStr;
            label.font = [UIFont fontWithName:@"Lato-Light" size:11];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
            label.textAlignment = NSTextAlignmentLeft;
            [self addSubview:label];
            self.sectionTitle = label;
            
            UILabel *ylabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 2, 75, frame.size.height - 5)];
            ylabel.text = [sectionDict objectForKey:@"m_year"];
            ylabel.font = [UIFont fontWithName:@"Lato-Light" size:11];
            ylabel.backgroundColor = [UIColor clearColor];
            ylabel.textColor = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
            ylabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:ylabel];
        }
        if (section == 1) {
            signImage.hidden = YES;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 250, frame.size.height - 5)];
            
            NSString * titleStr = [NSString stringWithFormat:@"Synopsis"];
            label.text = titleStr;
            label.font = [UIFont fontWithName:@"Lato-Light" size:11];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            [self addSubview:label];
            self.sectionTitle = label;
            
        }else if (section == 2) {
                signImage.hidden = YES;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 250, frame.size.height - 5)];
                
                NSString * titleStr = [NSString stringWithFormat:@"Cast"];
                label.text = titleStr;
                label.font = [UIFont fontWithName:@"Lato-Light" size:11];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor blackColor];
                label.textAlignment = NSTextAlignmentLeft;
                [self addSubview:label];
                self.sectionTitle = label;
                
        }
        else if (section == 3 || section == 4)
        {
            float rating = section == 3 ? [[sectionDict objectForKey:@"ppl_rating"] floatValue] : [[sectionDict objectForKey:@"celeb_rating"] floatValue];
            
            float initialOffset = 20 + imageWidth +20;
            int roundRating = lroundf(rating);
            for (int i = 0; i<roundRating; i++) {
                //Filled Hearts
                UIImage *heart = [UIImage imageNamed:@"heart-icon.png"];
                UIImageView *heartImage = [[UIImageView alloc] initWithImage:heart];
                CGRect signFrame = CGRectMake(initialOffset, (frame.size.height-heart.size.height)/2, heart.size.height, heart.size.height);
                heartImage.frame = signFrame;
                initialOffset += heart.size.width + 3;
                [self addSubview:heartImage];
            }
            UIImage *heart = [UIImage imageNamed:@"heart-icon.png"];
            for (int i = roundRating; i<5; i++) {
                //Empty Hearts
                UIImage *heart1 = [UIImage imageNamed:@"ratemovie_logo.png"];
                UIImageView *heartImageU = [[UIImageView alloc] initWithImage:heart1];
                CGRect signFrame = CGRectMake(initialOffset, (frame.size.height-heart.size.height)/2, heart.size.width, heart.size.height);
                heartImageU.frame = signFrame;
                initialOffset +=  heart.size.width + 3;
                [self addSubview:heartImageU];
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(initialOffset + 20, (frame.size.height-20)/2, 150, 20)];
            if (rating > 0.1)
                label.text = [NSString stringWithFormat:@"%0.1f",rating];
            else
                label.text = [NSString stringWithFormat:@"No ratings yet"];
            label.font = [UIFont fontWithName:@"Lato-Light" size:13];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
            label.textAlignment = NSTextAlignmentLeft;
            [self addSubview:label];

        }
        else if (section == 5)
        {
            CGRect LabelFrame = self.bounds;
            LabelFrame.size.width -= 50;
            LabelFrame.size.height -= 10;
            LabelFrame.origin.x = 20 + signImage.frame.size.width + 20;
            CGRectInset(LabelFrame, 0.0, 15.0);
            
            self.commentsNo = [[sectionDict objectForKey:@"comments"] intValue];
            _commentsLabel = [[UILabel alloc] initWithFrame:LabelFrame];
            _commentsLabel.text = [NSString stringWithFormat:@"%@ comments",[sectionDict objectForKey:@"comments"]];
            _commentsLabel.font = [UIFont fontWithName:@"Lato-Light" size:13];
            _commentsLabel.backgroundColor = [UIColor clearColor];
            _commentsLabel.textColor = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
            _commentsLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_commentsLabel];
            self.sectionTitle = _commentsLabel;

        }
        
        CGRect buttonFrame = CGRectMake(100, 0, 50, frame.size.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        [button setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(discButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.discButton = button;

        
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            
            color = [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:248.0f/255.0f green:200.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
            [colors addObject:(id)[color CGColor]];
        }
        self.layer.frame = frame;
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.99], [NSNumber numberWithFloat:1.0], nil]];
    }
    return self;
}

- (void) discButtonPressed : (id) sender
{
    if ((self.section == 4)||(self.section == 1)||(self.section == 2)){
       [self toggleButtonPressed:TRUE];
    }else if (self.section == 5)
    {
        if ([self.delegate respondsToSelector:@selector(commentPressed)])
        {
            [self.delegate commentPressed];
        }
    }else if (self.section == 3)
    {
        if ([self.delegate respondsToSelector:@selector(ratePressed)])
        {
            [self.delegate ratePressed];
        }
    }
}

- (void) toggleButtonPressed : (BOOL) flag
{
    self.discButton.selected = !self.discButton.selected;
    if(flag)
    {
        if (self.discButton.selected) 
        {
            if ([self.delegate respondsToSelector:@selector(sectionOpened:)]) 
            {
                [self.delegate sectionOpened:self.section];
            }
        } else
        {
            if ([self.delegate respondsToSelector:@selector(sectionClosed:)]) 
            {
                [self.delegate sectionClosed:self.section];
            }
        }
    }
    else
    {
       
    }
}

@end
