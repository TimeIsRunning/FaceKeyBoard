//
//  EmShowView.m
//  KeyBoardUserChat
//
//  Created by 金鼎玉铉 on 16/7/26.
//  Copyright © 2016年 whjdyx. All rights reserved.
//

#import "EmShowView.h"
#import "EMCollectionViewCell.h"
NSString *path;
@implementation EmShowView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
         path = [[NSBundle mainBundle] pathForResource:@"funny" ofType:@"plist"];
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        if (self.emType == ENUM_EMTypeEm )
//        {
            _dataArray = [NSArray arrayWithContentsOfFile:path] ;
            _layout.itemSize = CGSizeMake(30, 30);
            
            _layout.minimumInteritemSpacing= (160 - 3*30-20)/2;
            _layout.minimumLineSpacing=(self.bounds.size.width-30*7-20)/6;
            //设置分区的内容偏移
            _layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
//        }
        self.emCollertionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 160) collectionViewLayout:_layout];
        self.emCollertionView.backgroundColor = [UIColor whiteColor];
        self.emCollertionView.pagingEnabled = YES;
        self.emCollertionView.bounces = NO;
        self.emCollertionView.showsVerticalScrollIndicator = NO;
        self.emCollertionView.showsHorizontalScrollIndicator = NO;
        self.emCollertionView.dataSource = self;
        self.emCollertionView.delegate = self;
        
        [self.emCollertionView registerNib:[UINib nibWithNibName:@"EMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.emCollertionView];
        
//        self.delectEmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.delectEmButton.frame = CGRectMake(self.bounds.size.width-40, 120, 30, 30);
//        self.delectEmButton.backgroundColor = [UIColor redColor];
//        [self addSubview:self.delectEmButton];
        
        //Page分页控制
        self.emPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-100, self.bounds.size.height-20, 200, 10)];
        self.emPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        self.emPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.emPageControl.numberOfPages = _dataArray.count / 20+(_dataArray.count%20==0?0:1);
        self.emPageControl.currentPage = 0;
        [self addSubview:self.emPageControl];

    }
    return  self;
}
//- (void)setEmType:(ENUM_EMType)emType
//{
//    if (emType == ENUM_EMTypeEm )
//    {
//        _dataArray = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Places"];
//        layout.itemSize = CGSizeMake(30, 30);
//
//        layout.minimumInteritemSpacing= (160 - 3*30-20)/2;
//        layout.minimumLineSpacing=(self.bounds.size.width-30*7-20)/6;
//        //设置分区的内容偏移
//        layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
//    }
//    else if (emType == ENUM_EMTypeGIF)
//    {
//        _dataArray = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"People"];
//        layout.itemSize = CGSizeMake(40, 40);
//        layout.minimumLineSpacing = (160 - 3*40 -20)/2;
//        layout.minimumInteritemSpacing = (self.bounds.size.width - 40*7 -20)/6;
//        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    }
//    [self.emCollertionView reloadData];
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    self.emPageControl.currentPage = page;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (((_dataArray.count/20)+(_dataArray.count%20==0?0:1))!=section+1) {
        return 21;
//    }
//    else{
//        return _dataArray.count-20*((_dataArray.count/20)+(_dataArray.count%20==0?0:1)-1);
//    };
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (_dataArray.count/20)+(_dataArray.count%20==0?0:1);;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 20)
    {
        [cell.emLabel setBackgroundImage: [UIImage imageNamed:@"delete"] forState:UIControlStateNormal] ;
        cell.emLabel.tag = 1314;
    }
     else
     {
         NSInteger num = indexPath.section*20 + indexPath.row;
         //    NSLog(@"当前的单元格==%ld",num);
         if (num >_dataArray.count-1)
         {
//             if (indexPath.row != 20 && indexPath.section == (_dataArray.count/20)+(_dataArray.count%20==0?0:1) - 1)
//             {
//                 cell.emLabel.enabled = NO;
//             }
             
             //        cell.emLabel.backgroundColor = [UIColor redColor];
             [cell.emLabel setBackgroundImage: [UIImage imageNamed:@""] forState:UIControlStateNormal] ;
             cell.emLabel.tag = 5555;
         }
         else
         {
             [cell.emLabel setBackgroundImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@",_dataArray[num][@"png"]]] forState:UIControlStateNormal] ;
             cell.emLabel.tag = num;
         }
     }
    
    
    
//    cell.emLabel.enabled = NO;

    
        [cell.emLabel addTarget:self action:@selector(emAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)emAction:(UIButton *)sender
{
    NSLog(@"点击的是哪个按钮==%ld",sender.tag);
    if (sender.tag>=_dataArray.count )
    {
        if (sender.tag != 1314)
        {
            return;
        }
        
    }
//    NSNumber *num = [NSNumber numberWithInteger:sender.tag];
    if (sender.tag == 1314)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delectEm" object:self userInfo:nil];
        NSLog(@"选中的是删除按钮");
    }
    else
    {
        NSString *str = _dataArray[sender.tag][@"cht"];
        NSDictionary *dict = @{@"emName":str};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"emName" object:self userInfo:dict];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
*/

@end
