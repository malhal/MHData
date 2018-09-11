//
//  EventTableViewCell.m
//  MCDDemo
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.viewedKeys = @[@"timestamp"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewsFromCurrentObject{
    [super updateViewsFromCurrentObject];
    //self.textLabel.text = self.event.timestamp.description;
}

- (Event *)event{
    return (Event *)self.object;
}

- (void)setEvent:(Event *)event{
    super.object = event;
}


@end
