//
//  UILabel+Extention.m
//  LabelCategory
//
//  Created by 刘泽 on 16/6/24.
//  Copyright © 2016年 liuze. All rights reserved.
//

#import "UILabel+Extention.h"

#import <objc/runtime.h>

#import <CoreText/CoreText.h>

@implementation UILabel (Extention)

-(CGFloat)characterSpace{
    return [objc_getAssociatedObject(self,_cmd) floatValue];
}

-(void)setCharacterSpace:(CGFloat)characterSpace{
    
    //objc_setAssociatedObject来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。
    //关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；还有这种关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。这种关联策略是通过使用预先定义好的常量来表示的
    objc_setAssociatedObject(self, @selector(characterSpace), @(characterSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(CGFloat)lineSpace{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

-(void)setLineSpace:(CGFloat)lineSpace{
    objc_setAssociatedObject(self, @selector(lineSpace), @(lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(NSString *)keywords{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setKeywords:(NSString *)keywords{
    

    objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIFont *)keywordsFont{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setKeywordsFont:(UIFont *)keywordsFont{
    objc_setAssociatedObject(self, @selector(keywordsFont), keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)keywordsColor{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setKeywordsColor:(UIColor *)keywordsColor{
    objc_setAssociatedObject(self, @selector(keywordsColor), keywordsColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)underlineStr{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setUnderlineStr:(NSString *)underlineStr{
    objc_setAssociatedObject(self, @selector(underlineStr), underlineStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(UIColor *)underlineColor{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setUnderlineColor:(UIColor *)underlineColor{
    objc_setAssociatedObject(self, @selector(underlineColor), underlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

/**
 *  根据最大宽度计算label宽，高
 *
 *  @param maxWidth 最大宽度
 *
 *  @return size
 */
- (CGSize)getLableSizeWithMaxWidth:(CGFloat)maxWidth{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment=self.textAlignment;
    paragraphStyle.lineBreakMode=self.lineBreakMode;
    // 行间距
    if(self.lineSpace > 0){
        [paragraphStyle setLineSpacing:self.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    }
    
    // 字间距
    if(self.characterSpace > 0){
        long number = self.characterSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        
        CFRelease(num);
    }
    
    //关键字
    if (self.keywords) {
        NSRange itemRange = [self.text rangeOfString:self.keywords];
        if (self.keywordsFont) {
            [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:itemRange];
            
        }
        
        if (self.keywordsColor) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:itemRange];
            
        }
    }
    
    //下划线
    if (self.underlineStr) {
        NSRange itemRange = [self.text rangeOfString:self.underlineStr];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:itemRange];
        if (self.underlineColor) {
            [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:itemRange];
        }
    }
    
    
    
    self.attributedText = attributedString;
    
    //计算方法一
    //计算文本rect，但是发现设置paragraphStyle.lineBreakMode=NSLineBreakByTruncatingTail;后高度计算不准确
    //CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    //计算方法二
    CGSize maximumLabelSize = CGSizeMake(maxWidth, MAXFLOAT);//labelsize的最大值
    CGSize expectSize = [self sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

@end
