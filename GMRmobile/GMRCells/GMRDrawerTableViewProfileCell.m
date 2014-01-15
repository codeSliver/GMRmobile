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


#import "GMRDrawerTableViewProfileCell.h"
#import "GMRAppState.h"

@implementation GMRDrawerTableViewProfileCell

@synthesize customTitleLabel = _customTitleLabel;
@synthesize roundView = _roundView;
@synthesize logoutButton = _logoutButton;
@synthesize arrowView = _arrowView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setLabels];
        
        if(OSVersionIsAtLeastiOS7()== NO){
            [self.textLabel setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
            [self.textLabel setShadowOffset:CGSizeMake(0, 1)];
        }
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
}

-(void)setLabels
{
    _customTitleLabel = [[UILabel alloc] initWithFrame:self.titleViewLabel.frame];
    _customTitleLabel.text = @"";
    _customTitleLabel.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0f];
    _customTitleLabel.textAlignment = NSTextAlignmentLeft;
    _customTitleLabel.backgroundColor = [UIColor clearColor];
    _customTitleLabel.font = [UIFont fontWithName:@"Lato-Light" size:14.0];
    [self.titleViewLabel.superview addSubview:_customTitleLabel];
    
    [self.backgroundImageView setBackgroundColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0f]];
    
    [self.logoView setHidden:YES];
    self.roundView = [[UIImageView alloc] initWithFrame:self.logoView.frame];
    CALayer * l = [self.roundView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:15.0];
    
    // You can even add a border
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.logoView.superview addSubview:self.roundView ];
    
}

-(void)setSelected
{
    [_customTitleLabel setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0f]];
    [self.backgroundImageView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:174.0/255.0 blue:52.0/255.0 alpha:1.0f]];
//    [self.arrowView setImage:[UIImage imageNamed:@"arrow-state.png"]];
}

-(void)setUnselected
{
    _customTitleLabel.textColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0f];
    [self.backgroundImageView setBackgroundColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0f]];
//    [self.arrowView setImage:[UIImage imageNamed:@"profile_cell_arrow.png"]];
}

-(void)setLogoImage:(NSString*)_logoImage andPlaceholder:(NSString *)_placeholder
{
    logoName = _logoImage;
    placeholder = _placeholder;
     [self.roundView setImageWithURL:[NSURL URLWithString:_logoImage] placeholderImage:[UIImage imageNamed:placeholder] resize:YES options:SDWebImageRetryFailed];
}
-(void)reload
{
    _customTitleLabel.text = [[GMRAppState sharedState] getUserName];
    [self.roundView setImageWithURL:[NSURL URLWithString:logoName] placeholderImage:[UIImage imageNamed:placeholder] resize:YES options:SDWebImageRetryFailed];
    
}
-(void)setLogoImage:(NSString*)_logoImage{
    
    logoName = _logoImage;
    [self.roundView setImage:[UIImage imageNamed:_logoImage]];
}
-(NSString*)convertToSelected:(NSString*)_logoName
{
    _logoName = [_logoName stringByReplacingOccurrencesOfString:@".png" withString:@"_selected.png"];
    _logoName = [_logoName stringByReplacingOccurrencesOfString:@".jpg" withString:@"_selected.jpg"];

    _logoName = [_logoName stringByReplacingOccurrencesOfString:@".jpeg" withString:@"_selected.jpeg"];

    return _logoName;
}
@end
