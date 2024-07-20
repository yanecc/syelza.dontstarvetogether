# syelza.dontstarvetogether

New Syelza mod for Don't Starve Together

https://steamcommunity.com/sharedfiles/filedetails/?id=3287427802

## Features

- [x] Expand the dragon fruit food recipes
- [x] Remake the X juice (full moon blessing)
- [x] Support storing the X juice in the saltbox
- [x] Set a reasonable fresh time for Syelza's food
- [x] Speed up the growth process (max level 10)
- [x] Level down by eating the powcake
- [x] Apply a new method to calculate upgrade probability
  - $P = 1 - \text{FailureFactor} \cdot \tan(\text{PlayerLevel} \cdot 0.1)$
- [x] Add support for new production functionality for Syelza's production tool
- [x] Allow to put the pumpkin pudding into the pot to serve as 1 dairy and 1 sweetener
- [x] Make the unique equipments of Syelza can't be stolen
- [x] Remove the honeyed tag of the tea and the X juice
- [x] Allow to give the branch and Syelza's food to cats
- [x] Add warnings when the durability of Syelza's backpack is low

## Character Food Recipes

```
health hungry sanity
彩虹糕（100天）
120 160 30
4蜂蜜 4蛋 2香蕉

南瓜布丁（100天）
5 66 10
1南瓜/2胡萝卜 2蛋

放松茶叶（200天）
40 0 20
1熟仙人掌肉 1冰

黑夜祝福X（满月物品栏和背包中的变X2，月圆夜制作得到X2）（100天）
-90 40 -3/4currentSanity
2（多汁）浆果 2熟蛙腿 1深色花瓣

黑夜祝福X2（仅在月圆夜可制作，食用后每2秒恢复上限5%-15%的生命或理智，持续20秒，低者优先）（100天）
0 40 0
2（多汁）浆果 2熟蛙腿 1深色花瓣
```