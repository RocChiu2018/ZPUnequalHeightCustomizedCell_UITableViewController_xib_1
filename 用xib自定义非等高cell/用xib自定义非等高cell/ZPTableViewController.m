//
//  ZPTableViewController.m
//  用xib自定义非等高cell
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 有如下的三种方式来自定义UITableView控件的非等高cell：
 1、用xib的方式自定义非等高cell；
 2、用storyboard的方式自定义非等高cell；
 3、用代码的方式自定义非等高cell。
 */
#import "ZPTableViewController.h"
#import "ZPWeibo.h"
#import "ZPTableViewCell.h"

@interface ZPTableViewController ()

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSMutableDictionary *heightMutDic;  //存放所有cell的高度

@end

@implementation ZPTableViewController

#pragma mark ————— 懒加载 —————
-(NSMutableDictionary *)heightMutDic
{
    if (_heightMutDic == nil)
    {
        _heightMutDic = [NSMutableDictionary dictionary];
    }
    
    return _heightMutDic;
}

-(NSArray *)models
{
    if (_models == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"statuses" ofType:@"plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in dicArray)
        {
            ZPWeibo *weibo = [ZPWeibo weiboWithDict:dict];
            [tempArray addObject:weibo];
        }
        
        _models = tempArray;
    }
    
    return _models;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark ————— UITableViewDataSource —————
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

/**
 如果此方法中没有调用强制布局(layoutIfNeeded)方法的话则此方法是单纯的构建cell的方法，因为通过cellWithTableView方法能够创建一个自定义cell，但是新创建的这个自定义cell并没有真正显示到屏幕上，所以这个新创建的自定义cell里面的那些子控件(UIImageView,UILabel)也就都没有显示到屏幕上，所以对于没有显示到屏幕上的cell来讲系统是没有办法算出它的具体高度的，要想算出它的具体高度的话就必须要调用强制布局的方法。
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    
    ZPTableViewCell *cell = [ZPTableViewCell cellWithTableView:tableView];
    cell.weibo = [self.models objectAtIndex:indexPath.row];
    
    //强制布局
    [cell layoutIfNeeded];
    
    //把算出来的cell的高度存放到可变字典中
    [self.heightMutDic setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    
    //根据相应的行数取出对应的cell的高度
    return [[self.heightMutDic objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] floatValue];
}

#pragma mark ————— UITableViewDelegate —————
/**
 此方法的作用是设置cell的估计高度。如果代码中没有写这个方法的话则系统会先调用heightForRowAtIndexPath方法，再调用cellForRowAtIndexPath方法。如果写了此方法的话则系统会先调用这个方法，然后调用cellForRowAtIndexPath方法，最后调用heightForRowAtIndexPath方法，从而优化了性能。
 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"estimatedHeightForRowAtIndexPath");

    return 200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
