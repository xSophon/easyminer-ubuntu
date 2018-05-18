# easyminer-ubuntu
集成了显卡驱动和挖矿软件的ubuntu挖矿镜像说明

# img镜像下载
https://share.weiyun.com/5qjQfaf
文件有点大，用大于等于16G的u盘/SSD刻录即可。ubuntu下用dd命令可以直接刻录，具体方法自己百度。windows下用什么刻录我不知道，自己想办法。刻录以后直接能用。

# 已经预装的软件说明
- Nvidia驱动与cuda
- AMD挖矿驱动
- screen: 用于远程链接时候session的保持，关闭窗口后重连
- vim: 文本编辑器，使用方式自行百度
- teamviewer: 不习惯ssh的可以用teamviewer进行远程

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
screen -dr easyminer
```


- btm: (挖矿软件目前仅支持N卡)
  - 修改钱包地址，通过编辑`~/easyminer-ubuntu/btm-miner-1.0/address.txt`，格式为btm地址.矿工名

```
# 用docker方式启动btm挖矿，以下为分离0,1,2,3,4,5这5张gpu用于挖btm的案例
NV_GPU=0,1,2,3,4,5 nvidia-docker run -v /home/easyminer/easyminer-ubuntu/btm-miner-1.0:/miner -ti -rm nvidia/cuda sh /miner/run.sh
```
> 为什么要用docker，因为btm的挖矿软件很吃cpu，要i5以上的cpu才能保证6卡不丢算力，所以如果单机有6卡8卡12卡的同学可以用docker分离2-4张gpu来挖btm，其余的继续挖eth，不浪费卡和算力。
> 另外1070，1080,1080ti可以通过多开的方式来增加少许算力。比如1080ti开一个挖矿软件挖矿的时候是170算力，但是开两个进程挖矿的时候每个进程会有130+算力，也就是说80ti实际上btm算力可以达到270

- eth:
  - 修改钱包地址，通过编辑`~/easyminer-ubuntu/claymore_ethminer/mine.sh`中最后一行的eth地址实现，这是Claymore原版挖矿软件，其他参数可以参考官方说明。

- N卡超频和风扇情况复杂，请参考独立文章
这里只能简单说一下：开机自动超频调风扇请参考，`~/.config/autostart/`下面的两个`.sh`文件，里面改超频和风扇数据。在能成功生效前，你需要无显示器启动且用ssh登录计算机。
```
sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
```
然后重启。就这样。

eth:
0x1c8067528a3ccd5f2c756eb5f648d7f2ce96f633

btm:
bm1q7zxv6y0q5y4wghtam0053gc2fxcwgj44v3ljv7

