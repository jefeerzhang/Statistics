# lect001
# 陆震
# 日期：2019/05/30

# R是面向对象的，区分大小写的解释型数组编程语言
# R是基于使用泛型函数的面向对象的编程语言
# R中多数功能是由程序内置函数、用户自编函数和对对象的创建和操作所实现的
# 其中，对象可以是任何能被赋值给变量的东西，包括常量、数据结构、函数甚至图形
# 可以被存储和命名的任何东西都是对象
# 对象是专门的数据结构，存储在RAM中，通过名称或符号访问，名称和符号本身也是可以被操纵的对象
# 由于所有的对象在程序执行时都存储在RAM中，这对大规模数据分析有显著的影响
# 对象的名称由大小写字母、数字0～9、句号和下划线组成
# 名称区分大小写且不能以数字开头，句号被视为无特殊含义的简单字符
# 每一个对象都有某种模式，描述其是如何存储的
# 对象的属性：元信息描述对象的特性。属性能通过attributes()函数罗列出来并能通过attr()函数进行设置
# 对象一个关键的属性是对象的类属性，R中函数使用关于对象类的信息来确定如何处理对象
# 这个类属性决定当对象的副本传递到类似于print()、plot()和summary()这些泛型函数时运行什么代码
# 可使用class()函数读取和设置对象的类

# 面向对象的编程：
# R中有两个分离的面向对象编程的模型：S3、S4模型
# S3模型相对更老、更简单、结构更少，且在R中有最多的应用；S4模型更新且更复杂
# 这里主要集中讨论S3模型

# 泛型函数：
# R使用对象的类来确定当一个泛型函数被调用时采取什么样的行动
summary(women) # summary()函数对women数据框中的每个变量都进行了描述性分析
lm(weight ~ height, data = women) -> fit
summary(fit) # summary()函数对该数据框的线性回归模型进行了描述
# 查看summary()函数的代码
summary # 通过去掉括号查看函数代码，不可见的函数(在方法列表中加星号的函数)不能通过这种方式查看代码
# 返回：
# function (object, ...) 
# UseMethod("summary")
# <bytecode: 0x7fc2fe805690>
# <environment: namespace:base>
# 查看women数据框和fit对象的类
class(women) # 返回值为 "data.frame"
class(fit) # 返回值为 "lm"
# 若summary.data.frame(women)存在，summary(women)执行summary.data.frame(women)，否则执行summary.default(women)
# 同样，若summary.lm(fit)存在，summary(fit)执行summary.lm(fit)，否则执行summary.default(fit)
# UseMethod()函数将对象分派给一个泛型函数，前提是该泛型函数有扩展与对象的类匹配
# 可使用methods()函数列出可获得的S3泛型函数
methods(summary) # 返回的函数个数取决于电脑上安装的包的个数
# 在我的电脑上，独立的summary()函数定义了32类
summary.data.frame # 通过去掉括号查看函数代码
summary.loess # 通过去掉括号查看函数代码，不可见的函数(在方法列表中加星号的函数)不能通过这种方式查看代码
# 此时，可以使用getAnywhere()函数来查看代码
getAnywhere(summary.loess)
# 注：可以通过查看现有代码学习自编函数

# 对象的类可以是任意的字符串，诸如numeric、matrix、data.frame、array、lm、gm、table的类
# 此外，泛型函数不一定是print()、plot()、summary()，任意的函数都可以是泛型的
# 如，下面定义一个名为mymethod()的泛型函数：
# 定义泛型函数
mymethod <- function(x, ...) 
  UseMethod('mymethod') 
mymethod.a <- function(x)
  print('Using A') # mymethod()泛型函数定义为类a的对象
mymethod.b <- function(x)
  print('Using B') # mymethod()泛型函数定义为类b的对象
mymethod.default <- function(x) 
  print('Using Default') # mymethod()泛型函数定义default()函数
1:5 -> x
6:10 -> y
10:15 -> z
'a' -> class(x) # 给对象分配类
'b' -> class(y) # 给对象分配类
mymethod(x) # 相应的函数被调用，返回值为 "Using A"
mymethod(y) # 相应的函数被调用，返回值为 "Using B"
# 因为对象z为integer类，且没有定义好的mymethod.integer()函数，故默认的方法用于对象z
mymethod(z) # 相应的函数被调用，返回值为 "Using Default"
mymethod.a(x) # 返回值为 "Using A"
mymethod.a(y) # 返回值为 "Using A"
# 一个对象可以被分配多个类：
c('a', 'b') -> class(z) # 当对象z被分配到两类时，第一类决定调用哪个泛型函数
mymethod(z) # 返回值为 "Using A"
c('b', 'a') -> class(z)
mymethod(z) # 返回值为 "Using B"
c('c', 'a', 'b') -> class(z) 
# 泛型函数中没有'c'类，即没有mymethod.c()函数，故下一个类'a'被使用，
# R从左到右搜索类的列表，寻找第一个可用的泛型函数
mymethod(z) # 返回值为 "Using A"

# S3模型的限制：
# S3对象模型的主要限制是：任意的类能被分配到任意的对象上，没有完整性检验。
'lm' -> class(women)
summary(women)
# women数据框被分配到lm类，无意义，且会报错
# 相比之下，S4面向对象编程的模型更加正式、严格，旨在克服由S3方法的结构化程度较低引起的困难
# 在S4方法中，类被定义为具有包含特定类型信息(也就是输入的变量)的槽的抽象对象
# 对象和方法构造在强制执行的规则内被正式定义
# 不过，使用S4模型编程更加复杂且互动更少

# 一次交互式会话期间的所有数据对象都被R保存在内存中，所以R往往受限于可用的内存量
# 在处理大数据集的时候，需要考虑数据集的大小和要应用的统计方法

# R函数由函数和赋值构成，R使用 -> 而非 = 作为赋值符号
rnorm(5) -> x # 创建向量对象x，其包含5个来自标准正态分布的随机偏差
x # 直接输入对象的名称将列出它的内容
print(x)
# 函数c()将其参数组合成一个向量或列表，以这样的形式输入数据
c(1, 3, 5, 2, 11, 9, 3, 9, 12, 3) -> age
c(4.4, 5.3, 7.2, 5.2, 8.5, 7.3, 6.0, 10.4, 10.2, 6.1) -> weight
mean(weight) # 求均值
sd(weight) # 求标准差
cor(age, weight) # 求相关系数
plot(age, weight) # 可视化检查两者趋势关系

# 不加参数运行demo()，查看R中图形的完整演示列表
# demo(image)

# help.start() 打开帮助文档首页
# help(foo) 或 ?foo 查看函数foo的描述(如返回值)
# example(foo) 查看函数foo的使用范例
# apropos('foo', mode='function') 列出名称中含有foo的所有可用函数
# data() 列出当前已加载包中所含的所有可用示例数据集

# 工作空间workspace是当前R的工作环境，存储着所有你定义的对象
# 在当前会话结束时，你可以将当前工作空间保存到一个镜像中，以便在下次启动R时自动载入它
# 使用上下方向键查看命令的历史记录

#当前的工作目录working directory是R读取文件和保存结果的默认目录
# getwd() 查看当前工作目录
# setwd() 设定当前工作目录
# 若需要读入一个不再当前工作目录下的文件，需要在调用语句中写明文件的完整路径
# setwd('C:/myprojects/project1') 路径需要使用正斜杠，R将反斜杠 \ 作为一个转义符
# 注意：setwd()不会创建一个新的、不存在的目录
# 可以使用dir.create()创建新目录，然后用setwd()将当前工作目录指向该新目录
runif(20) -> x # 创建一个包含20个均匀分布随机变量的向量
summary(x) # 生成x的摘要统计量
hist(x) # 生成直方图
# 函数q()结束对话，并询问是否保存工作空间
# 若保存工作空间，命令的历史记录保存到文件.Rhistory中，工作空间(包含所有对象)保存到文件.RData中
ls() # 列出当前工作空间中的对象
# rm(objectlist) 删除对象
# history(#) 显示最近使用的#个命令(默认值为25)
# savehistory('myfile') 保存命令历史到文件myfile.Rhistory中
# save.image('myfile') 保存工作空间到文件myfile.RData中
# save(objectlist, file='myfile') 保存指定对象到一个文件中
# loadhistory('myfile') 载入命令历史文件myfile.Rhistory
# load('myfile') 读取工作空间myfile.RData到当前会话中
# 推荐：在独立的目录中保存项目，即跳转到项目所在目录并双击之前保存的镜像文件即可
# 这样可以启动R，载入保存的工作空间，并设置当前工作目录到这个文件夹中

# 输入和输出：
# 函数source('filename')执行脚本文件命令集
# 若文件中不包含路径，R默认该脚本在当前工作目录中
# 惯例，脚本以.R为扩展名，如 source('myscript.R')
# 函数sink('filename')将输出重定向到文件filename中，默认覆盖已有该文件
# 可使用参数append=TRUE将文本追加到该文件后，而不是覆盖它
# 可使用参数split=TRUE将输出同时发送到屏幕和输出文件中
# 不加参数调用sink()，仅向屏幕返回结果
# 注意：sink()只能重定向文本输出，要重定向图形输出，使用以下函数，最后使用dev.off()将输出返回到终端
# bmp('filename.bmp') BMP文件
# jpeg('filename.jpeg') JPEG文件
# pdf('filename.pdf') PDF文件
# png('filename.png') PNG文件
# svg('filename.svg') SVG文件
# 整个输入输出流程如下：
# sink('myoutput', append=TRUE, split=TRUE)
# pdf('mygraphs.pdf')
# source('myscript.R')
# 执行脚本mysript.R，结果显示在屏幕上，此外，文本输出追加到myoutput中，图形输出保存在mygraphs.pdf中

# 包是R函数、数据、预编译代码以一种定义完善的格式组成的集合
# 计算机上存储包的目录称为库library
# 函数.libPaths()显示库所在位置，函数library()显示库中包
# search()显示已加载并可使用的包
# update.packages() 更新已安装的包
# installed.packages() 列出已安装的包的相关信息(如版本号)
# 包的安装是指从某个CRAN镜像站点下载它并将其放入库中的过程
# 安装好以后，必须载入到会话中才能使用包
# help(package='package_name') 输出某个包的简短描述以及包中可用的函数名称和数据集名称的列表
# help() 查看包中任意函数或数据集的描述

# 注意：在调用函数时，即使函数无参数，仍需加上括号()

# 要了解某个函数的返回值，查阅该函数在线帮助文档中的Value部分即可
# 这样可以知道将某个函数的结果赋值到一个对象时，保存的具体内容

# 按照要求的格式创建含有研究信息的数据集，是数据分析的第一步
# 数据集：由数据构成的矩形数组，行为观测(示例)，列为变量(属性)
# 数据集有其数据结构和数据类型(数值型、字符型、逻辑型、复数型和原生型)
# 数据结构：用于存储数据的对象类型，包括标量、向量、矩阵、数组、数据框和列表

# 标量：只含一个元素的向量，用于保存常量(单独的数值)
3 -> f
'US' -> g
TRUE -> h

# 向量：用于存储数值型、字符型或逻辑型数据的一维数组
# 执行组合功能的函数c()可用于创建向量
c(1, 2, 3, 4, -5) -> a # 数值型向量
c('one', 'two') -> b # 字符型向量
c(TRUE, FALSE) -> c # 逻辑型向量
# 注意：单个向量中的数据必须是相同的类型(数值型、字符型或逻辑型)，不可混杂不同类型数据
# 索引：访问向量中的元素
a[3]
a[c(2, 4)] # 向量a中第2个和第4个元素
a[2:4] # 向量a中第2到第4个元素

# 矩阵：二维数组，和向量类似，其中元素必须类型相同，即一个矩阵中只能包含一种数据类型
# 注：矩阵是一个具有维度属性dim的原子向量，包含两个元素(行数和列数)
# 可通过函数matrix()创建矩阵
matrix(1:20, nrow = 5, ncol = 4) # 默认按列填充
matrix(1:20, nrow = 5, ncol = 4, byrow=TRUE, dimnames=list(c('r1', 'r2', 'r3', 'r4', 'r5'), 
                                                           c('c1', 'c2', 'c3', 'c4'))) # 按行填充
# 注意：dimnames包含以字符型向量表示的行列名
c('r1', 'r2', 'r3', 'r4', 'r5') -> row_name
c('c1', 'c2', 'c3', 'c4') -> col_name
matrix(1:20, nrow = 5, ncol = 4, byrow=TRUE, dimnames=list(row_name, col_name)) -> X
# 索引：X[i,]表示矩阵X中的第i行，X[,j]表示第j列，X[i, j]表示第i行第j个元素，其中i和j可为数值型向量
X[3, ]
X[c(1:3), c(2:3)] # 多行多列
# 等价于：
X[1:3, 2:3]
X[c(1:3), c(2:3)] -> Y

# 数组：与矩阵类似，是矩阵的自然推广，不可混杂不同类型数据，维度可以大于2
# 注：数组是一个具有维度属性dim的原子向量，包含三个或更多元素
# 可通过函数array()创建
c('A1', 'A2') -> dim1
c('B1', 'B2', 'B3') -> dim2
c('C1', 'C2', 'C3', 'C4') -> dim3
array(1:24, c(2, 3, 4), dimnames = list(dim1, dim2, dim3)) -> z
# 索引：与矩阵相同
z[1, 2, 3] # 前俩为单个矩阵的维度索引
z[1, 2, 1:3]






