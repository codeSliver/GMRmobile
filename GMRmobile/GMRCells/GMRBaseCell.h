//
//  GMRBaseCell.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  list of all custom cells Nib Names
 */
static NSString *gmr_home_cell                         = @"GMRHomeCell";
static NSString *gmr_collapsable_cell                  = @"GMRCollapsableCell";

/**
 *  Base class for all custom cells.It acts more like a factory which generates different custom cells for all view controllers in the app.
 */

@interface GMRBaseCell : UITableViewCell
{
    
}
+(GMRBaseCell *)cellFromNibNamed:(NSString *)nibName;
+(NSString*)getMyReuseIdentifier;
@end
