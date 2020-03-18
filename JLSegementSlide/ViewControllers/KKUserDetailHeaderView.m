//
//  KKUserDetailHeaderView.m
//  KLEKT
//
//  Created by Jacklin on 2020/3/8.
//  Copyright © 2020 Team. All rights reserved.
//

#import "KKUserDetailHeaderView.h"

@interface KKUserDetailHeaderView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageContraint;

@end

@implementation KKUserDetailHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

- (instancetype)loadFromNib {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return nibs.count > 0 ? nibs.firstObject : self;
}

- (void)updateBgImageTopContraint:(CGFloat)constant {
    self.topImageContraint.constant = constant;
    [self layoutIfNeeded];
}

@end
