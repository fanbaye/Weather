//
//  LZZCategoryCell.m
//  Weather
//
//  Created by lucas on 5/18/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZCategoryCell.h"

@implementation LZZCategoryCell

@synthesize label = _label;

- (void)dealloc
{
    self.label = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        backImageView.image = [UIImage imageNamed:@"cellBackgroundView"];
        [self.contentView addSubview:backImageView];
        [backImageView release];
        
        self.label  = [[UILabel alloc] initWithFrame:CGRectMake(55, 14, 160, 16)];
        _label.textColor = [UIColor lightGrayColor];
        _label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label];
        [_label release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
