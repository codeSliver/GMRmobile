//
//  SectionArray.m
//  CustomTableTest
//
//  Created by   on 5/11/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMRSectionInfo.h"

@implementation GMRSectionInfo

@synthesize  open=_open;
@synthesize title=_title;
@synthesize sectionCategory=_sectionCategory;
@synthesize sectionView;
@synthesize rowHeights;
@synthesize sectionData;

- init {
	return [self initWithTitle:@"title" isOpen:NO];
}

-(id)initWithTitle:(NSString*)title isOpen:(BOOL)open{
    
    self = [super init];
    
    if (self) {
        
        _open = open;
        _title = title;
        
        rowHeights = [[NSMutableArray alloc] init];
        //_contestsCategory = [NSMutableArray array];
    }
    
    return self;
}

- (NSUInteger)countOfRowHeights {
	return [rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
	return [rowHeights objectAtIndex:idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
	[rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
	[rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
	[rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
	[rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
	[rowHeights replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
	[rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end
