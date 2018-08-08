//
//  ZPTableViewCell.m
//  用xib自定义非等高cell
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPTableViewCell.h"
#import "ZPWeibo.h"

@interface ZPTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@end

@implementation ZPTableViewCell

/**
 当UILabel控件内的文字是多行的时候，如果在xib文件中只是单单利用Autolayout给本控件添加一个宽度约束的话则利用这个宽度约束再算本控件内部文字的宽度的时候会算不准，所以一般会产生瑕疵，这一瑕疵在此Demo中的表现为本控件和cell的底端有一段间隙，只要约束一下本控件内文字的最大宽度，这个瑕疵就会被修正了；
 UILabel控件的preferredMaxLayoutWidth属性是当本控件内有多行文字的时候用来约束本控件内文字的最大宽度的；
 当UILabel控件内只有一行文字的时候则上述的瑕疵不会出现则就不用撰写下面的代码了。
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    ZPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    
    return cell;
}

-(void)setWeibo:(ZPWeibo *)weibo
{
    _weibo = weibo;
    
    //防止循环利用的时候出问题
    if (weibo.isVip)
    {
        self.nameLabel.textColor = [UIColor greenColor];
        self.vipImageView.hidden = NO;
    }else
    {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipImageView.hidden = YES;
    }
    
    self.nameLabel.text = weibo.name;
    
    self.iconImageView.image = [UIImage imageNamed:weibo.icon];
    
    //防止循环利用的时候出问题
    if (weibo.picture)
    {
        self.pictureImageView.hidden = NO;
        self.pictureImageView.image = [UIImage imageNamed:weibo.picture];
    }else
    {
        self.pictureImageView.hidden = YES;
    }
    
    self.contentLabel.text = weibo.text;
}

- (CGFloat)height
{
    if (self.pictureImageView.hidden)  //没有配图的时候，取文字的最大Y值
    {
        return CGRectGetMaxY(self.contentLabel.frame) + 10;
    }else  //有配图的时候，取配图的最大Y值
    {
        return CGRectGetMaxY(self.pictureImageView.frame) + 10;
    }
}

@end
