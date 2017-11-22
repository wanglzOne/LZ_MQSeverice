//
//  OrderAddPriceBuyTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderAddPriceBuyTableViewCell.h"

#import "AddPriceBuyCellView.h"

@interface OrderAddPriceBuyTableViewCell ()

@property (nonatomic, strong) UIScrollView *heandView;
@property (nonatomic, strong) UIScrollView *contentProductView;

@property (nonatomic, strong) NSMutableArray<AddPriceBuyCellView*> *contentProductViewSubviews;


@property (nonatomic, strong) NSArray<AddPricetoBuyConfigInfo*> *headArray;
// id : AddPricetoBuyConfigInfo.configId
@property (nonatomic, strong) NSDictionary<id,NSArray<AddPricetoBuyInfo*>*> *dataDict;


@end

@implementation OrderAddPriceBuyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
// 255.0
// 55
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.heandView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KHEIGHT_6(54.0))];
        [self.contentView addSubview:self.heandView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.heandView.frame), KScreenWidth, KHEIGHT_6(1.0))];
        [lineView setBackgroundColor:UIColorFromRGBA(0xe5e5e5, 1)];
        [self.contentView addSubview:lineView];
        
        self.contentProductView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), KScreenWidth, KHEIGHT_6(200.0))];
        [self.contentView addSubview:self.contentProductView];
    }
    return self;
}


- (void)setDataArray:(NSArray<AddPricetoBuyInfo *> *)dataArray
{
    if (_dataArray.count) {
        return;
    }
    _dataArray = dataArray;
    
    if (!dataArray.count) {
        return;
    }
    
    
    NSMutableArray *headArray = [[NSMutableArray alloc] init];
    
    for (AddPricetoBuyInfo *info in dataArray) {
        if (info.configInfo) {
            
            BOOL isExist = NO;
            for (AddPricetoBuyConfigInfo *cInfo in headArray) {
                if (cInfo.tagId == info.configInfo.tagId) {
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
               
                [headArray addObject:info.configInfo];
            }
        }
    }
  
    self.headArray = headArray;

        
    
        
    
        
    

    
    if (self.headArray.count == 0) {
        return;
    }
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < headArray.count; i ++) {
        AddPricetoBuyConfigInfo *cInfo = headArray[i];
        for (AddPricetoBuyInfo *dataInfo in dataArray) {
            if (cInfo.tagId == dataInfo.configInfo.tagId) {
                NSMutableArray *dataInfos = [dataDict objectForKey:cInfo.tagId];
                if (!dataInfos) {
                    dataInfos = [[NSMutableArray alloc] init];
                    [dataDict setObject:dataInfos forKey:cInfo.tagId];
                }
                [dataInfos addObject:dataInfo];
            }
        }
    }
    self.dataDict = dataDict;
    
    
    
    UIView *lastView = nil;
    for (int i = 0; i < headArray.count; i ++) {
//        //对数组进行排序
//        NSArray *ary = [headArray mutableCopy];
//            [ary sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                return [obj1 compare:obj2]; //升序
//        
//            }];
        AddPricetoBuyConfigInfo *cInfo = headArray[i];
        CGSize size = [cInfo.tagName sizeOfTextFont:15.0 maxSize:CGSizeMake(0, 25.0)];
        CGFloat width = size.width + 20;
        
        UIButton *itemTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        itemTitle.frame = CGRectMake(10 + i * (10 +width), self.heandView.size.height/2-25.0/2, width, 25.0);
        itemTitle.titleLabel.font = [UIFont systemFontOfSize:15.0];
        itemTitle.tag = i+100;
        [itemTitle setTitle:cInfo.tagName forState:UIControlStateNormal];
        [itemTitle setBackgroundColor:HWColor(254, 254, 254) forState:UIControlStateNormal];
        [itemTitle setBackgroundColor:HWColor(255, 225, 0) forState:UIControlStateSelected];
        [itemTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemTitle addTarget:self action:@selector(chooseAddPricetoBuyConfigInfo:) forControlEvents:UIControlEventTouchUpInside];
        itemTitle.layer.cornerRadius = CGRectGetHeight(itemTitle.frame)/2;
        itemTitle.clipsToBounds = YES;
        itemTitle.layer.borderColor = [UIColor grayColor].CGColor;
        itemTitle.layer.borderWidth = 1.0;
        if (i == 0) {
            itemTitle.selected = YES;
        }
        lastView = itemTitle;
        [self.heandView addSubview:itemTitle];
    }
    [self.heandView setContentSize:CGSizeMake(CGRectGetMaxX(lastView.frame) + 10, self.heandView.frame.size.height)];
    
    
    NSInteger maxData = 0;
    for (NSArray *arr in dataDict.allValues) {
        if (maxData < arr.count) {
            maxData = arr.count;
        }
    }
    CGFloat width = KHEIGHT_6(110.0);
    self.contentProductViewSubviews = [[NSMutableArray alloc] init];
    for (int i = 0; i < maxData; i ++) {
        AddPriceBuyCellView *cellView = [[NSBundle mainBundle] loadNibNamed:@"AddPriceBuyCellView" owner:nil options:nil][0];
        
        cellView.frame = CGRectMake(10+ i * (10 +width), 0, width, CGRectGetHeight(self.contentProductView.frame));
        [cellView.addButton addTarget:self action:@selector(addPriceBuyCellView_addButtonClik:) forControlEvents:UIControlEventTouchUpInside];
        [cellView.reduceButton addTarget:self action:@selector(addPriceBuyCellView_reduceButtonClik:) forControlEvents:UIControlEventTouchUpInside];
//        [cellView.imageButton sd_setImageWithURL:[NSURL URLWithString:info.productInfo.productHeadImgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"kenweir3"]];
        cellView.bgView.backgroundColor = HWColor(247, 247, 247);
        cellView.backgroundColor = [UIColor clearColor];
        [self.contentProductView addSubview:cellView];
        
        
        [self.contentProductViewSubviews addObject:cellView];
    }
    
    
    [self setContentProductView];
    
}


- (void)addPriceBuyCellView_addButtonClik:(UIButton *)btn
{
    [self updateDatafor:YES and:btn];
}
- (void)addPriceBuyCellView_reduceButtonClik:(UIButton *)btn
{
    AddPriceBuyCellView *cellView = (AddPriceBuyCellView*)[[btn superview] superview];
    if (![cellView.label_productCount.text intValue]) {
        return;
    }
    [self updateDatafor:NO and:btn];
}

- (void)updateDatafor:(BOOL)isAdd and:(UIButton *)btn
{
    AddPriceBuyCellView *cellView = (AddPriceBuyCellView*)[[btn superview] superview];
    AddPricetoBuyConfigInfo *cInfo = self.headArray[[self getSletedIndex]];
    if (cInfo.tagId) {
        NSArray *arr = [self.dataDict objectForKey:cInfo.tagId];
        for (int i = 0; i < arr.count; i ++)
        {
            AddPricetoBuyInfo *arrInfo = arr[i];
            //(cellView.addPricetoBuyInfo.productInfo.productId == arrInfo.productInfo.productId)
            //(cellView.addPricetoBuyInfo.productId == arrInfo.productId)
            if (cellView.addPricetoBuyInfo.productId == arrInfo.productId) {
                if (isAdd) {
                    arrInfo.productCount++;
                }else
                {
                    arrInfo.productCount--;
                }
            }
        }
        
    }
    [self setContentProductView];
}


//选择区  更新内容
- (void)chooseAddPricetoBuyConfigInfo:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    for (UIButton *btnHead in [self.heandView subviews]) {
        if ([btnHead isKindOfClass:[UIButton class]]) {
            if (btnHead != btn) {
                btnHead.selected = NO;
            }
        }
    }
    [self setContentProductView];
}




//刷新页面
- (void)setContentProductView
{
    if (!self.headArray.count) {
        return;
    }
    //点击 + -  修改 self.dataDict  中对于model的份数
    
    //写一个方法获取 self.dataDict 份数>0的数字
    
    
    
    UIView *lastView = nil;
    AddPricetoBuyConfigInfo *cInfo = self.headArray[[self getSletedIndex]];
    if (cInfo.tagId) {
        NSArray *arr = [self.dataDict objectForKey:cInfo.tagId];
        int i = 0;
        for (AddPriceBuyCellView *cellView in self.contentProductViewSubviews) {
            if (i < arr.count) {
                cellView.hidden = NO;
                AddPricetoBuyInfo *info = arr[i];
                cellView.addPricetoBuyInfo = info;
                cellView.label_name.text = info.productInfo.productName;
                cellView.label_price.text = MoneySymbol(info.morePrice);
                cellView.label_productCount.text = [NSString stringWithFormat:@"%d",info.productCount];
                [cellView.imageButton sd_setImageWithURL:[NSURL URLWithString:[(info.productInfo.mainCoverImageUrl ? info.productInfo.mainCoverImageUrl : @"") imageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"kenweir3"]];

                lastView = cellView;
            }
            else
            {
                cellView.hidden = YES;
            }
            i ++;
        }
        /*
        for (int i = 0; i < self.contentProductView.subviews.count; i ++) {
            AddPriceBuyCellView *cellView = self.contentProductView.subviews[i];
            if ([cellView isKindOfClass:[AddPriceBuyCellView class]]) {
                
            }
        }
         */
    }
    
    [self.contentProductView setContentSize:CGSizeMake(CGRectGetMaxX(lastView.frame)+10.0, CGRectGetHeight(self.contentProductView.frame))];
    
    
    if ([self.delegate respondsToSelector:@selector(updateHeadConfigData:andDataArray:tableViewCell:)]) {
        [self.delegate updateHeadConfigData:self.headArray andDataArray:self.dataDict tableViewCell:self];
    }
    
}


- (NSInteger)getSletedIndex
{
    
    for (UIButton *btn in [self.heandView subviews]) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.selected) {
                return [[self.heandView subviews] indexOfObject:btn];
            }
        }
    }
    return 0;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
