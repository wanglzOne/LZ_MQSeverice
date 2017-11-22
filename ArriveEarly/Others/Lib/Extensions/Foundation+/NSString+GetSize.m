//
//  NSString+GetSize.m
//  SalesCheck
//
//  Created by iosdev on 15/7/15.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "NSString+GetSize.h"

@implementation NSString (GetSize)



+ (CGSize)getSizelabelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary* attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : paragraphStyle.copy };

    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;

    labelSize.height = ceil(labelSize.height);

    labelSize.width = ceil(labelSize.width);

    return labelSize;
}

- (NSString*)insertMark:(NSString*)markStr
{

    NSMutableString* mStr = [[NSMutableString alloc] initWithString:self];
    if (mStr.length == 11) {
        [mStr insertString:markStr atIndex:7];
        [mStr insertString:markStr atIndex:3];
    }
    return mStr;
}

- (CGSize)sizeOfTextFont:(CGFloat)fontSize maxSize:(CGSize)maxSize
{
    if (self == nil) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary* attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : paragraphStyle.copy };

    CGSize labelSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;

    labelSize.height = ceil(labelSize.height);

    labelSize.width = ceil(labelSize.width);

    return labelSize;
}

@end
