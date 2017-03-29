# Pre_CalculateRowHeightDemo
tableView优化之提前计算行高
#前言:

tableView的优化大概就是一下几种:
- 1.cell内部的层级结构尽量的少  - 使用drawRect画
- 2.cell内部的数据尽量提前准备好 尽量少的实时计算 
- MVVM的优势 提前处理model,cell直接拿到最终需要的数据
- 3.所有的控件大小提前计算好,不要每一次都重新计算 
- 4.缓存tableView行高  
- 因为:利用自动布局计算行高很消耗cpu,每次滚动到该cell都要计算.
- 5.利用cpu去异步绘制cell的layer
- layer.drawsAsynchronously = true 
- 这个代码可以使layer 提前绘制
- 6.栅格化 将cel内容渲染成一张图片,在滚动的时候就是一张图片
- layer.shouldRasterize = true
- self.layer.rasterizationScale = UIScreen.main.scale   默认是1x的  设置成屏幕的缩放比例就可以了
- 7.按需加载 -- 按照用户滚动的速度去加载哪个cell

**本篇文章讲一下缓存cell行高**

#正题之前的唠叨:
最开始的时候tableView的行高我们是让tableView自己根据内容去计算的
```
//实现这两句代码
tableView.rowHeight = UITableViewAutomaticDimension;
tableView.estimatedRowHeight = 100;
//然后布局cell的时候为最后一个控件设置底部约束 == cell的底部
```
缺点就是利用自动布局计算行高很消耗cpu,每次滚动到该cell都要计算. 


#正题:


![demoPic.png](http://upload-images.jianshu.io/upload_images/3284263-6aed770970af2830.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


缓存行高原理其实就是提前创建一个cell,为其赋值model后将计算好的行高存起来备用

首先为模型添加一个属性  用来存储行高
```
@interface Status : NSObject
/**
这里是其他属性
*/

/**rowHeight  - 存储计算好的行高*/
@property (nonatomic,assign) CGFloat rowHeight;
@end
```
```
//重写cell的model属性的set方法  -- 每次的cellForRow都会重新赋值  cell要显示的各种属性
- (void)setModel:(Status *)model {
_model = model;
[self.iconView sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
self.nameLabel.text = model.user.name;
self.sourceLabel.text = model.source;
self.createdLabel.text = model.created_at;
self.contentLabel.text = model.text;
}

在cell中添加一个计算行高的方法
- (CGFloat)getMaxY {

[self layoutIfNeeded];//强制更新约束 让cell子控件重新计算frame

return CGRectGetMaxY(self.contentLabel.frame) + margin; //这里就是返回的cell的行高了
}
```

```
@property(nonatomic,strong) NSArray <Status *>*datas;//这里存着数据
//实现tableVIew的这个代理  返回该模型下的cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
return self.datas[indexPath.row].rowHeight;
}
```
顺便说一句
cell构造方法重写的是这个
```
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
[self setupUI];
}
return self;
}

```
setupUI 里各种创建控件和masonry布局 详情见[demo](https://github.com/AnnieAri/Pre_CalculateRowHeightDemo)


计算行高:
```
for (Status *model in self.datas) {
//这个cell只是用来计算 所以随便创建
ARStatusCell *cell = [[ARStatusCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
NSLog(@"cell's frame = %@",NSStringFromCGRect(cell.frame));
cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1000);
cell.model = model;
model.rowHeight = [cell getMaxY];
}
//
```
为什么要改cell得frame呢?
```
Pre_CalculateRowHeightDamo[10935:2085237] -[ARHomeViewController loadData] [Line 50] cell's frame = {{0, 0}, {320, 44}}
//初始化的cell的frame 宽度默认是320  所以要改成屏幕的宽度 高度随便改
```


demo地址:https://github.com/AnnieAri/Pre_CalculateRowHeightDemo

只是简单的实现行高的一种计算  复杂的ui 也可以实现,我在我们的项目中也是使用这种方式.

![demoPic2.png](http://upload-images.jianshu.io/upload_images/3284263-37123c8ffc63755b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
