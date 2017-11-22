//
//  OrderDetailListView.m
//

#import "OrderDetailListView.h"

@implementation OrderDetailListView

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects {
    
    return [self initWithFrame:frame withObjects:objects canReorder:NO];
}

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.objects = [NSMutableArray arrayWithArray:objects];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    _listTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _listTableView.bounces = NO;
    _listTableView.showsHorizontalScrollIndicator = NO;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.backgroundColor = [UIColor clearColor];
//    [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailListCell class]) bundle:nil] forCellReuseIdentifier:@"DetailListCell"];
    [self addSubview:_listTableView];
}

@end
