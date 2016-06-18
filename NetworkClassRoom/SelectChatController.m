//
//  SelectChatController.m
//  Rongyun_Demo1
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SelectChatController.h"
#import "ChatCell.h"
#import <RongIMKit/RongIMKit.h>

static const float kItem_Width                  = 70.0f;            //item的宽,高
static const float kItem_Height                 = 40.0f;

static const float kMin_Item_Spacing            = 10.0f;            //同一行中两个item之间的间隙
static const float kMin_Line_Spacing            = 15.0f;            //相邻行之间的间隙

static const float kSectionInset_Top            = 8.0f;             //section缩进
static const float kSectionInset_Left           = 8.0f;
static const float kSectionInset_Bottom         = 8.0f;
static const float kSectionInset_Right          = 8.0f;

static const float kSectionHeaderView_Height    = 20.0f;            //section的Header高度
static const float kSectionFooterView_Height    = 1.0f;             //section的Footer高度

static NSString *kMy_Cell_Id = @"cellId";
static NSString *kSupplementary_Header_Id = @"supplementaryHeaderId";
static NSString *kSupplementary_Footer_Id = @"supplementaryFooterId";

@interface SelectChatController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_chatArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SelectChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _chatArray = [NSMutableArray array];
    [self requestChatInfo];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //配置布局信息
    self.collectionView
    = [[UICollectionView alloc] initWithFrame:self.view.frame
                         collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    //注册UICollectionViewCell
    [_collectionView registerClass:[ChatCell class] forCellWithReuseIdentifier:kMy_Cell_Id];

}

- (void)requestChatInfo {
    RCUserInfo *user1 = [[RCUserInfo alloc]init];
    user1.userId = @"t1";
    user1.name = @"孙丽珺";
    user1.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
    [_chatArray addObject:user1];
    
    RCUserInfo *user2 = [[RCUserInfo alloc]init];
    user2.userId = @"t2";
    user2.name = @"陈琦";
    user2.portraitUri = @"http://121.42.162.159/upload/123.png";
    [_chatArray addObject:user2];
    
    RCUserInfo *user3 = [[RCUserInfo alloc]init];
    user3.userId = @"t3";
    user3.name = @"李勤";
    user3.portraitUri = @"http://121.42.162.159/upload/123.png";
    [_chatArray addObject:user3];
    
    RCUserInfo *user4 = [[RCUserInfo alloc]init];
    user4.userId = @"s1";
    user4.name = @"宿振宇";
    user4.portraitUri = @"http://121.42.162.159/upload/123.png";
    [_chatArray addObject:user4];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _chatArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMy_Cell_Id forIndexPath:indexPath];
    RCUserInfo *user = [_chatArray objectAtIndex:indexPath.row];
    cell.lbChannel.text = user.name;
    return cell;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCUserInfo *user = [_chatArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TargetId"
                                                        object:user];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kItem_Width, kItem_Height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kSectionInset_Top, kSectionInset_Left, kSectionInset_Bottom, kSectionInset_Right);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMin_Line_Spacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kMin_Item_Spacing;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(10.0f, kSectionHeaderView_Height);  //这里的宽度设置无效
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(10.0f, kSectionFooterView_Height);  //这里的宽度设置无效
}


@end
