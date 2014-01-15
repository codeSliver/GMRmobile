//
//  GMRBaseCell.m
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import "GMRBaseCell.h"
#import "GMRHomeCell.h"
#import "GMRConstants.h"

@implementation GMRBaseCell

static GMRBaseCell *baseCell = nil;

/**
 *  list of all nibs for custom cells
 */
static UINib *homeCellNib;
static UINib *collapsableCellNib;

/**
 *  create all the nibs in one go
 */
+ (void)initialize
{
    if (!baseCell) {
        baseCell = [[GMRBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if (!homeCellNib){
        homeCellNib = [UINib nibWithNibName:gmr_home_cell bundle:nil];
        assert(homeCellNib);
    }
    if (!collapsableCellNib){
        collapsableCellNib = [UINib nibWithNibName:gmr_collapsable_cell bundle:nil];
        assert(collapsableCellNib);
    }
    
}

-(UINib*)getNibWithName:(NSString*)nibName{
    UINib *nib = nil;
    
    
    /**
     *  choose appropriate nib
     */
    if ([[nibName lowercaseString] isEqualToString:[gmr_home_cell lowercaseString]]) {
        nib = homeCellNib;
    }
    else if ([[nibName lowercaseString] isEqualToString:[gmr_collapsable_cell lowercaseString]]) {
        nib = collapsableCellNib;
    }

    
    return nib;
}
-(NSString *) reuseIdentifier {
    
    NSString *identifier = [self reuseIdentifierForClass:NSStringFromClass([self class])];
    
    return identifier;
}
-(NSString *) reuseIdentifierForClass:(NSString*)className{
    
    NSString *identifier = nil;
    
    @synchronized (self) {
        
        if ([[className lowercaseString] isEqualToString:[gmr_home_cell lowercaseString]]) {
            identifier = GMR_HOME_CELL_REUSE_IDENTIFIER;
        }
        else if ([[className lowercaseString] isEqualToString:[gmr_collapsable_cell lowercaseString]]) {
            identifier = GMR_COLLAPSABLE_CELL_REUSE_IDENTIFIER;
        }

    }
    
    return identifier;
}
+(NSString*)getMyReuseIdentifier{
    return [baseCell reuseIdentifierForClass:NSStringFromClass([self class])];
}
+ (GMRBaseCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[baseCell getNibWithName:nibName] instantiateWithOwner:self options:nil];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    GMRBaseCell *cell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[GMRBaseCell class]]) {
            cell = (GMRBaseCell *)nibItem;
            break;
        }
    }
    
    return cell;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
