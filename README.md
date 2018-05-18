# easyminer-ubuntu
集成了显卡驱动和挖矿软件的ubuntu挖矿镜像说明。**系统的用户名密码都是:easyminer**。Ubuntu矿工学院Q群：474604062。

拒绝回答“××能不能挖”这种问题……你见过有哪个显卡挖矿软件是没有Linux版本的？特么驱动都装好了显然是什么都能挖。想要开机自启动等方式请往下阅读。

# img镜像下载
https://share.weiyun.com/5qjQfaf
文件有点大，用大于等于16G的u盘/SSD刻录即可。ubuntu下用dd命令可以直接刻录。windows下用什么刻录我不知道，自己想办法。刻录以后直接能用。
linux下可以用Ubuntu的安装盘引导进入“试用”：
```
# 用fdisk查看分区
sudo fdisk -l

# 比如发现16G的准备做系统的盘是/dev/sdb
sudo dd bs=10M if=/你的img文件路径 of=/dev/sdb
# 其中bs是指缓存大小，填大一点刻录得快一些。if理解为inputfile，也就是输入路径,of立即为outputfile，输出位置。也就是从if位置往of位置克隆
```

# 关于为什么要做镜像
额。因为有些没有用过Linux的同学天天来烦我，心很累……即便写了CUDA的安装教程，安装驱动的时候总会有网络问题或者墙的问题导致各种各样问题。所以做成镜像自己刻盘去吧。在这个镜像不被篡改的前提下我对此系统（除了原版挖矿软件以外）安全无后门这件事情可以承担法律责任。放心使用。会用Ubuntu的当然也就不会下载这个镜像，可以自行安装，但是这份README也会给你一些启发。

- 目前可以实现的是eth的N卡A卡开机自动挖矿调风扇超频。（A卡不需要超频都是刷BIOS的），BTM的N卡开机自动挖矿（挖BTM超频不超频没区别）
- 支持BTM的docker分离GPU挖矿方式，为什么挖btm用docker容器更好请参考下文。
- IMG镜像对大量装机的用户比较方便。

# 已经预装的软件说明
- Nvidia驱动与cuda
- AMD挖矿驱动
- screen: 用于远程链接时候session的保持，关闭窗口后重连
- vim: 文本编辑器，使用方式自行百度
- teamviewer: 不习惯ssh的可以用teamviewer进行远程
- BTM挖矿软件，ETH的Claymore原版挖矿软件

# 下载easyminer-ubuntu
```
git clone https://github.com/xSophon/easyminer-ubuntu
cd easyminer-ubuntu
```

# 更新easyminer-ubuntu
```
cd ~/easyminer-ubuntu
git pull
```

# ubuntu基本命令
- vim编辑器刚打开时候不是编辑模式，键盘敲i进入编辑模式，编辑结束以后按esc退出编辑模式，然后:wq保存退出。

# 开机自动挖矿
通过修改`/etc/rc.local`实现, 刚刻录好的系统默认是开机自动启动btm挖矿
```shell
sudo vim /etc/rc.local
```

在桌面终端命令行或者ssh命令行中通过连接screen查看挖矿程序运行情况
```
# 查看有哪些screen的session
screen -ls
# 如果开机以后发现没有叫easyminer的session，请参考上一步检查一下/etc/rc.local，应该是自动启动的脚本出了问题

# 连接到名叫easyminer的session
screen -dr easyminer
```


- btm: (挖矿软件目前仅支持N卡)
  - 修改钱包地址，通过编辑`~/easyminer-ubuntu/btm-miner-1.0/address.txt`，格式为btm地址.矿工名

```
# 用docker方式启动btm挖矿，以下为分离0,1,2,3,4,5这5张gpu用于挖btm的案例
sudo NV_GPU=0,1,2,3,4,5 nvidia-docker run -v /home/easyminer/easyminer-ubuntu/btm-miner-1.0:/miner -ti -rm nvidia/cuda sh /miner/run.sh
```
> 为什么要用docker，因为btm的挖矿软件很吃cpu，要i5以上的cpu才能保证6卡不丢算力，所以如果单机有6卡8卡12卡的同学可以用docker分离2-4张gpu来挖btm，其余的继续挖eth，不浪费卡和算力。
> 另外1070，1080,1080ti可以通过多开的方式来增加少许算力。比如1080ti开一个挖矿软件挖矿的时候是170算力，但是开两个进程挖矿的时候每个进程会有130+算力，也就是说80ti实际上btm算力可以达到270

- eth:
  - 修改钱包地址，通过编辑`~/easyminer-ubuntu/claymore_ethminer/mine.sh`中最后一行的eth地址实现，这是Claymore原版挖矿软件，其他参数可以参考官方说明。

- N卡超频和风扇情况复杂，这里只能简单说一下，如果遇到自己情况不符合的部分，希望自己解决。笔者实践下列步骤的时候是不接显示器启动且用ssh登录计算机。接显示器的时候会调用到集显，往往会导致xconfig自动生成的配置文件无效。
```
# 首先你需要运行nvidia-xconfig来帮你自动生成一个/etc/X11/xorg.conf，这个文件如果没做好，会导致开机无法进桌面等问题。n卡要超频改风扇需要把coolbits设置为28
sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
# 好，如果现在这个文件是自动生成了。可以用sudo vim /etc/X11/xorg.conf自己欣赏一下里面的内容。然后重启以后再看看这个文件与重启前是否有变化，如果发现跟重启前一样说明搞定了 （注意如果这时候你在layout里看见一个关于集显的内容（Inactive ... Intel之类的）,最好把这一行删掉。）
```

开机自动超频调风扇命令请参考，`~/.config/autostart/`下面的两个`.sh`文件，里面改超频和风扇数据。

就这样。

eth:
0x1c8067528a3ccd5f2c756eb5f648d7f2ce96f633

btm:
bm1q7zxv6y0q5y4wghtam0053gc2fxcwgj44v3ljv7

