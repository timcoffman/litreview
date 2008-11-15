//
//  TDCollectionParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

// Abstract Class
@interface TDCollectionParser : TDParser {
	NSMutableArray *subparsers;
}
- (void)add:(TDParser *)p;

@property (nonatomic, readonly, retain) NSMutableArray *subparsers;
@end
