//
//  SectionArray.h
//  CustomTableTest
//
//  Created by   on 5/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GMRSectionView;


@interface GMRSectionInfo : NSObject

@property (assign) BOOL open;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSMutableDictionary *sectionData;
@property (nonatomic, retain) NSMutableArray *sectionCategory;

@property (strong) GMRSectionView *sectionView;
@property (nonatomic,strong,readonly) NSMutableArray *rowHeights;

-(id)initWithTitle:(NSString*)title isOpen:(BOOL)open;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end
