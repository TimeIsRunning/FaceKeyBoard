//
//  EmShowView.h
//  KeyBoardUserChat
//
//  Created by 金鼎玉铉 on 16/7/26.
//  Copyright © 2016年 whjdyx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ENUM_EMTypeEm=2,
    ENUM_EMTypeGIF=3,
}ENUM_EMType;
@interface EmShowView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,retain) UICollectionView *emCollertionView;
@property (nonatomic,retain) UIPageControl *emPageControl;
@property (nonatomic,retain) UIButton *emButton;
@property (nonatomic,retain) UIButton *gifButton;
@property (nonatomic,retain) NSArray *dataArray;
@property (nonatomic,retain) UIButton *delectEmButton;
@property (nonatomic,retain) UICollectionViewFlowLayout *layout;
@property (nonatomic,assign) ENUM_EMType emType;
@end
