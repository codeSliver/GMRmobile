

#import "GMRBaseCell.h"
#import "UIImageView+WebCache.h"

@interface GMRReviewCell : GMRBaseCell
{
    UIImageView * roundUserImage;
    
    IBOutlet UIView * userName;
    UILabel * userNameLabel;
    
    IBOutlet UIView * userAddress;
    UILabel * userAddressLabel;
    
    IBOutlet UIView * pointView;
    UILabel * pointLabel;
    
    IBOutlet UIView * commentView;
    UITextView * commentTextView;
    
}

@property (nonatomic,strong) IBOutlet UIButton * userImage;

-(void)setLabels;
-(float)getHeightForComment:(NSDictionary*)commentDictionary;
-(void)setComment:(NSDictionary*)commentDictionary;
@end
