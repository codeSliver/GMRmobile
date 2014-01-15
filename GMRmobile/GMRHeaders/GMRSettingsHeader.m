


#import "GMRSettingsHeader.h"

@implementation GMRSettingsHeader

@synthesize parent = _parent;
@synthesize titleLabel = _titleLabel;
@synthesize delegate = _delegate;

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
    _titleLabel = [[UILabel alloc] initWithFrame:titleLabelView.frame];
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:200.0/255.0 blue:13.0/255.0 alpha:1];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:14.0];
    [titleLabelView.superview addSubview:_titleLabel];
}

-(IBAction)backPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(headerBackButtonPressed)])
    {
        [self.delegate headerBackButtonPressed];
    }
}
@end