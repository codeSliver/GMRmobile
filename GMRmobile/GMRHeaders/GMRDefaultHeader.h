

#import <UIKit/UIKit.h>


@protocol HeaderViewDelegate <NSObject>

-(void)headerBackButtonPressed;
-(void)headerHomeButtonPressed:(int)state;
-(void)headerInfoButtonPressed;

@end


@interface GMRDefaultHeader : UIView
{
    IBOutlet UIView * titleLabelView;
    

}

@property (nonatomic,strong) UIViewController * parent;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic, weak) id<HeaderViewDelegate> delegate;


-(void)initialize;
@end
