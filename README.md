# HarmonyOsHttp

**HarmonyOS网络库**，基于Remote Communication Kit（远场通信服务）封装而来，简化了请求方式，增加了常见的业务功能，支持同步、异步、装饰器模式，支持多种返回数据类型，Json、对象、数组，支持数据缓存，支持dialog加载，支持控制台请求信息格式化输出……

**如果你想使用基于http封装的网络库，可以点击直达：[net](https://ohpm.openharmony.cn/#/cn/detail/@abner%2Fnet)**

## 开发环境

DevEco Studio NEXT Developer Beta1,Build Version: 5.0.3.900

Api版本：**12**

modelVersion：5.0.0


## 主要功能点

<p align="center">当前版本：<i><span style="color:#ff0000;">1.0.1</span></i></p>

- 1、**支持全局初始化**
- 2、 **支持统一的BaseUrl**
- 3、 **支持全局错误拦截**
- 4、 **支持拦截器使用**
- 5、 **支持同步方式请求（get/post/delete/put/options/head/trace/connect）**
- 6、 **支持异步方式请求（get/post/delete/put/options/head/trace/connect）**
- 7、 **支持dialog加载**
- 8、 **支持返回Json字符串**
- 9、**支持返回对象**
- 10、 **支持返回数组**
- 11、 **支持返回data一层数据**
- 12、 **支持上传文件**
- 13、 **支持下载文件**
- 14、 **支持全局状态码统一设置，业务层可省去判断**
- 15、 **支持数据缓存，支持多种类型缓存**
- 16、 **支持装饰器模式**

## 快速使用

远程依赖方式使用【推荐】

方式一：在Terminal窗口中，执行如下命令安装三方包，DevEco Studio会自动在工程的oh-package.json5中自动添加三方包依赖。

**建议：在使用的模块路径下进行执行命令。**

```
ohpm install @abner/http
```

方式二：在工程的oh-package.json5中设置三方包依赖，配置示例如下：

```
"dependencies": { "@abner/http": "^1.0.1"}
```

## 一、全局初始化

推荐在AbilityStage进行初始化，初始化一次即可，初始化参数可根据项目需要进行选择性使用。

```typescript
Net.getInstance().init({
  baseUrl: "https://www.xx.cn", //设置全局baseurl
  connectMs: 60000, //允许建立连接的最长时间
  transferMs: 60000, //允许传输数据的最长时间
  netErrorInterceptor: new MyNetErrorInterceptor(), //设置全局错误拦截,需要自行创建,可在这里进行错误处理
  headers: {}, //头参数
  resultTag: [],//接口返回数据data层参数，比如data,items等等
  interceptors:[]//拦截器
})
```

### 初始化属性介绍

初始化属性，根据自己需要选择性使用。

| 属性                     | 类型                       | 概述                                             |
|------------------------|--------------------------|------------------------------------------------|
| baseUrl                | string                   | 可选参数，一般标记为统一的请求前缀，也就是域名                        |
| connectMs              | number                   | 可选参数，默认60秒,允许建立连接的最长时间                         |
| transferMs             | number                   | 可选参数，默认60秒,允许传输数据的最长时间                         | 
| interceptors           | rcp.Interceptor[]        | 设置拦截器                                          |
| inactivityMs           | number                   | 默认0秒,网络传输持续进行                                  |
| netErrorInterceptor    | INetErrorInterceptor     | 可选参数，全局错误拦截器，需继承INetErrorInterceptor           |
| headers                | Object{}                 | 可选参数，全局统一的公共头参数                                |
| cookies                | Object{}                 | cookie                                         |
| resultTag              | Array\<string\>          | 可选参数，主要用于直接返回data层数据对象，接口返回数据参数，比如data,items等等 |
| messageTag             | Array\<string\>          | 返回data层数据时，结果的返回的tag标签，如message errorMessage等等 |
| codeTag                | Record\<string, Object\> | 返回data层数据时，状态的返回tag标签，如code status等等           |
| isReadCache            | boolean                  | 是否读取缓存，默认不读取                                   |
| httpContext            | Context                  | 使用缓存时，传递的上下文，用缓存时必填                            |
| cacheBundleName        | string                   | 包名，     用缓存时必填                                 |
| loadingDialog          | WrappedBuilder\<[]\>     | 全局的dialog                                      |
| closeLog               | boolean                  | 是否关闭日志                                         |
| isLoadingUseMainWindow | boolean                  | 弹出的DialogLoading是否使用主window弹出，默认false不是        |

### 设置请求头拦截

关于全局头参数传递，可以通过以上的header参数或者在请求头拦截里均可。

请求拦截器，主要是以插件形式plugin进行实现，支持多个插件形式，也就是多个拦截器形式，可以用plugin参数传递。
也可以使用addNetPlugins方法形式。


#### 注入拦截器

**初始化注入**

```javascript
Net.getInstance().init({
      baseUrl: "https://www.xxx.cn",
      resultTag: ["data", "items"],
      interceptors: [new GlobalInterceptor()]
    })
```

**方法注入**

```javascript
Net.getInstance().setInterceptors([new GlobalInterceptor()])
```

### 设置全局错误拦截器

名字自定义，实现INetErrorInterceptor接口，可在httpError方法里进行全局的错误处理，比如统一跳转，统一提示等。

```typescript
import { NetError, NetErrorInterceptor } from '@abner/http';

export class MyNetErrorInterceptor extends NetErrorInterceptor {
  httpError(error: NetError) {
    //这里进行拦截错误信息
  }
}
```

### NetError对象

可通过如下方法获取错误code和错误描述信息。

```javascript
/*
   * 返回code
   * */
getCode():number{
  return this.code
}

/*
* 返回message
* */
getMessage():string{
  return this.message
}

```

## 二、异步请求

### 1、请求说明

为了方便数据的针对性返回，目前异步请求提供了三种请求方法，一种是默认的request方法，第二种是requestString方法，第三种是requestObject方法，在实际的开发中，大家可以针对需要，选择性使用。

#### request方法

```typescript
Net.get("url").request<TestModel>((data) => {
  //data 就是返回的TestModel对象
})
```

此方法，针对性返回对应的**data层数据对象**，如下json，则会直接返回需要的data对象，不会携带外层的code、message等其他参数，方便大家直接的拿到数据。

```json
{
  "code": 0,
  "message": "数据返回成功",
  "data": {}
}
```

当然了也可以直接返回数组，比如下面的json，data层是一个数组:

```json
{
  "code": 0,
  "message": "数据返回成功",
  "data": []
}
```

**直接数组层获取**

```typescript
Net.get("url").request<TestModel[]>((data) => {
  //data 就是返回的TestModel[]数组
})

//或者如下

Net.get("url").request<Array<TestModel>>((data) => {
  //data 就是返回的TestModel数组
})
```

可能大家有疑问，如果接口返回的json字段不是data怎么办？如下：

举例一

```json
{
  "code": 0,
  "message": "数据返回成功",
  "items": {}
}
```

举例二

```json
{
  "code": 0,
  "message": "数据返回成功",
  "models": {}
}
```

如果您的数据返回类型字段有多种，如上json,可以通过全局初始化resultTag进行传递或者局部setResultTag传递即可。

**全局设置接口返回数据参数【推荐】**

全局设置，具体设置请查看上边的全局初始化一项，只设置一次即可，不管你有多少种返回参数，都可以统一设置。

```typescript
 Net.getInstance().init({
  resultTag: ["data", "items", "models"]//接口返回数据参数，比如data,items等等
})
```

**局部设置接口返回数据参数**

通过setResultTag方法设置即可。

```typescript
Net.get("")
  .setResultTag(["items"])
  .request<TestModel>((data) => {

  })
```


#### requestString方法

requestString就比较简单，就是普通的返回请求回来的json字符串。

```typescript
Net.get("url").requestString((data) => {
  //data 为 返回的json字符串
})
```

#### requestObject方法

requestObject方法也是获取对象，和request不同的是，它不用设置返回参数，因为它是返回的整个json对应的对象，
也就是包含了code，message等字段。

```typescript
Net.get("url").requestObject<TestModel>((data) => {
  //data 为 返回的TestModel对象
})
```

如果你不想每次在对象中都生成共有字段，比如code,message等等，你可以抽取一个基类，如下：

```typescript
export class ApiResult<T> {
  code: number
  message: string
  data: T
}
```

以后就可以如下请求，code和message就不用再重新写了。

```typescript
Net.get("url").requestObject<ApiResult<TestModel>>((data) => {
  //data 为 返回的ApiResult对象
})
```

#### 回调函数

回调函数有两个，一个成功一个失败，成功回调必调用，失败可选择性调用。

只带成功

```typescript
Net.get("url").request<TestModel>((data) => {
  //data 为 返回的TestModel对象
})
```

成功失败都带

```typescript
Net.get("url").request<TestModel>((data) => {
  //data 为 返回的TestModel对象
}, (error) => {
  //失败
})
```

### 2、get请求

```typescript
 Net.get("url").request<TestModel>((data) => {
  //data 为 返回的TestModel对象
})
```

### 3、post请求

```typescript
Net.post("url").request<TestModel>((data) => {
  //data 为 返回的TestModel对象
})
```

### 4、delete请求

```typescript
 Net.delete("url").request<TestModel>((data) => {
  //data 为 返回的TestModel对象
})
```

### 5、put请求

```typescript
Net.put("url").request<TestModel>((data) => {
  //data 为 返回的TestModel对象
})
```

### 6、其他请求方式

除了常见的请求之外，根据系统api所提供的，也封装了如下的请求方式,只需要更改请求方式即可，比如Net.options

```
OPTIONS
HEAD
TRACE
CONNECT
```

### 7、各个方法调用

| 方法                        | 类型                            | 概述                                                                                                                                                                                                                              |
|---------------------------|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| setHeaders                | Object                        | 单独添加请求头参数                                                                                                                                                                                                                       |
| setBaseUrl                | string                        | 单独替换BaseUrl                                                                                                                                                                                                                     |
| setParams                 | string / Object / ArrayBuffer | 单独添加参数,用于post                                                                                                                                                                                                                   |
| setCookies                | rcp.RequestCookies            | 单独设置Cookies                                                                                                                                                                                                                     |
| setInterceptors           | rcp.Interceptor[]             | 设置拦截器,多个                                                                                                                                                                                                                        |
| setInterceptor            | rcp.Interceptor               | 设置拦截器,单个                                                                                                                                                                                                                        |
| setRequestInterceptors    | 无参                            | 设置仅执行自己的拦截器，不执行全局                                                                                                                                                                                                               |
| setConnectMs              | number                        | 设置连接时间                                                                                                                                                                                                                          |
| setTransferMs             | number                        | 设置传输时间                                                                                                                                                                                                                          |
| setResultTag              | Array\<string\>               | 接口返回数据参数，比如data,items等等，此方法设置后，全局就不生效                                                                                                                                                                                           |
| setCodeTag                | Array\<string\>               | 状态码的返回tag标签，如code status等等，此方法设置后，全局就不生效                                                                                                                                                                                        |
| setMessageTag             | Array\<string\>               | 信息的返回tag标签，如message errorMessage等等，此方法设置后，全局就不生效                                                                                                                                                                                |
| setCustomDialogController | CustomDialogController        | 传递的dialog控制器，用于展示dialog                                                                                                                                                                                                         |
| setCacheType              | CacheType                     | 缓存类型，NO_NETWORK_READ_CACHE:无网络下直接读取缓存,FIRST_REMOTE：先请求网络，请求网络失败后再加载缓存，FIRST_CACHE：先加载缓存，缓存没有再去请求网络， CACHE_AND_REMOTE：先使用缓存，不管是否存在，仍然请求网络，会回调两次，CACHE_AND_REMOTE_DISTINCT：先使用缓存，不管是否存在，仍然请求网络，先把缓存回调，等网络请求回来发现数据是一样的就不会再返回，否则再返回 |
| setPrecisionKeys          | string[]                      | 处理精度参数，传递字段即可                                                                                                                                                                                                                   |
| showDialogLoading         | 无参                            | 显示loading                                                                                                                                                                                                                       |

代码调用如下：

```typescript
Net.get("url")
  .setHeaders({})//单独添加请求头参数
  .setBaseUrl("")//单独替换BaseUrl
  .setParams({})//单独添加参数
  .setConnectMs(10000)//单独设置连接超时
  .setTransferMs(10000)//设置传输时间
  .setResultTag([""])//接口返回数据参数，比如data,items等等
  .setCustomDialogController()//传递的dialog控制器，用于展示dialog
  .request<TestModel>((data) => {
    //data 为 返回的TestModel对象
  })
```

## 三、同步请求

同步请求需要注意，需要await关键字和async关键字结合使用。

```typescript
private async getTestModel(){
  const testModel = await Net.get("url").returnData<TestModel>()
}
```

### 1、请求说明

同步请求和异步请求一样，也是有三种方式，一种是returnData<TestModel>()，第二种是returnData<string>(ReturnDataType.STRING)，第三种是returnData<TestModel>(ReturnDataType.OBJECT)，通过参数的形式，默认直接返回data层数据。

#### 返回data层数据

和异步种的request方法类似，只返回json种的data层对象数据，不会返回code等字段,returnData默认就是返回data层数据。

```typescript
 private async getData(){
  const data = await Net.get("url").returnData<TestModel>()
  //data为 返回的 TestModel对象
}
```

#### 返回Json对象

和异步种的requestObject方法类似，会返回整个json对象，包含code，message等字段，需要传递ReturnDataType.OBJECT。

```typescript
 private async getData(){
  const data = await Net.get("url").returnData<TestModel>(ReturnDataType.OBJECT)
  //data为 返回的 TestModel对象
}
```

#### 返回Json字符串

和异步种的requestString方法类似，需要传递ReturnDataType.STRING。

```typescript
private async getData(){
  const data = await Net.get("url").returnData<string>(ReturnDataType.STRING)
  //data为 返回的 json字符串
}
```

#### 返回错误

异步方式有回调错误，同步方式如果发生错误，也会直接返回错误，结构如下：

```json
{
  "code": 0,
  "message": "错误信息"
}
```

除了以上的错误捕获之外，你也可以全局异常捕获，

### 2、get请求

```typescript

const data = await Net.get("url").returnData<TestModel>()

```

### 3、post请求

```typescript

const data = await Net.post("url").returnData<TestModel>()

```

### 4、delete请求

```typescript

const data = await Net.delete("url").returnData<TestModel>()

```

### 5、put请求

```typescript

const data = await Net.put("url").returnData<TestModel>()

```

### 6、其他请求方式

除了常见的请求之外，根据系统api所提供的，也封装了如下的请求方式,只需要更改请求方式即可，比如Net.options

```
OPTIONS
HEAD
TRACE
CONNECT
```

### 7、各个方法调用

| 方法                        | 类型                            | 概述                                                                                                                                                                                                                              |
|---------------------------|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| setHeaders                | Object                        | 单独添加请求头参数                                                                                                                                                                                                                       |
| setBaseUrl                | string                        | 单独替换BaseUrl                                                                                                                                                                                                                     |
| setParams                 | string / Object / ArrayBuffer | 单独添加参数,用于post                                                                                                                                                                                                                   |
| setCookies                | rcp.RequestCookies            | 单独设置Cookies                                                                                                                                                                                                                     |
| setInterceptors           | rcp.Interceptor[]             | 设置拦截器,多个                                                                                                                                                                                                                        |
| setInterceptor            | rcp.Interceptor               | 设置拦截器,单个                                                                                                                                                                                                                        |
| setRequestInterceptors    | 无参                            | 设置仅执行自己的拦截器，不执行全局                                                                                                                                                                                                               |
| setConnectMs              | number                        | 设置连接时间                                                                                                                                                                                                                          |
| setTransferMs             | number                        | 设置传输时间                                                                                                                                                                                                                          |
| setResultTag              | Array\<string\>               | 接口返回数据参数，比如data,items等等，此方法设置后，全局就不生效                                                                                                                                                                                           |
| setCodeTag                | Array\<string\>               | 状态码的返回tag标签，如code status等等，此方法设置后，全局就不生效                                                                                                                                                                                        |
| setMessageTag             | Array\<string\>               | 信息的返回tag标签，如message errorMessage等等，此方法设置后，全局就不生效                                                                                                                                                                                |
| setCustomDialogController | CustomDialogController        | 传递的dialog控制器，用于展示dialog                                                                                                                                                                                                         |
| setCacheType              | CacheType                     | 缓存类型，NO_NETWORK_READ_CACHE:无网络下直接读取缓存,FIRST_REMOTE：先请求网络，请求网络失败后再加载缓存，FIRST_CACHE：先加载缓存，缓存没有再去请求网络， CACHE_AND_REMOTE：先使用缓存，不管是否存在，仍然请求网络，会回调两次，CACHE_AND_REMOTE_DISTINCT：先使用缓存，不管是否存在，仍然请求网络，先把缓存回调，等网络请求回来发现数据是一样的就不会再返回，否则再返回 |
| setPrecisionKeys          | string[]                      | 处理精度参数，传递字段即可                                                                                                                                                                                                                   |
| showDialogLoading         | 无参                            | 显示loading                                                                                                                                                                                                                       |

代码调用如下：

```typescript
const data = await Net.get("url")
  .setHeaders({})//单独添加请求头参数
  .setBaseUrl("")//单独替换BaseUrl
  .setParams({})//单独添加参数
  .setConnectMs(10000)//单独设置连接超时
  .setTransferMs(10000)//设置传输时间
  .setResultTag([""])//接口返回数据参数，比如data,items等等
  .setCustomDialogController()//传递的dialog控制器，用于展示dialog
  .returnData<TestModel>()
//data为 返回的 TestModel对象
```

## 四、装饰器模式请求

网络库允许使用装饰器的方式发起请求，也就是通过注解的方式，目前采取的是装饰器方法的形式。

#### 1、请求说明

装饰器和同步异步有所区别，只返回两种数据类型，一种是json字符串，一种是json对象，暂时不提供返回data层数据。
在使用的时候，您可以单独创建工具类或者ViewModel或者直接使用，都可以。

##### 返回json字符串

```typescript
@GET("url",{isReturnJson: true})
getData():Promise<string> | undefined {
  return undefined
}
```

##### 返回json对象

```typescript
@GET("url")
 getData():Promise<TestModel> | undefined {
  return undefined
}
```

#### 2、get请求

```typescript
@GET("url")
 getData():Promise<TestModel> | undefined {
  return undefined
}
```

#### 3、post请求

```typescript
@POST("url")
 getData():Promise<TestModel> | undefined {
  return undefined
}
```

#### 4、delete请求

```typescript
@DELETE("url")
 getData():Promise<TestModel> | undefined {
  return undefined
}
```

#### 5、put请求

```typescript
@PUT("url")
private getData():Promise<TestModel> | undefined {
  return undefined
}
```

#### 6、其他请求方式

除了常见的请求之外，根据系统api所提供的，也封装了如下的请求方式,只需要更改请求方式即可，比如@OPTIONS

```
OPTIONS
HEAD
TRACE
CONNECT
```

当然，大家也可以使用统一的NET装饰器，只不过需要自己设置请求方法，代码如下：

```typescript
@NET("url", { method: http.RequestMethod.POST })
 getData():Promise<string> | undefined{
  return undefined
}
```

#### 7、装饰器参数传递

##### 直接参数传递

直接参数，在调用装饰器请求时，后面添加即可,一般针对固定参数。

```typescript
@GET("url", {
  baseUrl: "", //baseUrl
  header: {}, //头参数
  params: {}, //入参
  transferMs: 1000, //连接超时
  connectMs: 1000, //传输时间
  isReturnJson: true,//默认返回json对象
  isShowLoading:true//是否显示DialogLoading
})
private getData():Promise<string> | undefined {
  return undefined
}
```

##### 动态参数传递

动态参数适合参数可变的情况下传递，比如分页等情况。

```typescript
@GET("url")
 getData(data? : HttpOptions):Promise<string> | undefined {
  return undefined
}
```

调用时传递

```typescript
private async doHttp(){
  const data = await this.getData({
    baseUrl: "", //baseUrl
    header: {}, //头参数
    params: {}, //入参
    connectTimeout: 1000, //连接超时
    readTimeout: 1000, //读取超时
    isReturnJson: true,//默认返回json对象
    isShowLoading:true//是否显示DialogLoading
  })
}
```

##### 装饰器参数传递

使用DATA装饰器，DATA必须在上！

```typescript
@DATA({
  baseUrl: "", //baseUrl
  header: {}, //头参数
  params: {}, //入参
  connectTimeout: 1000, //连接超时
  readTimeout: 1000, //读取超时
  isReturnJson: true,//默认返回json对象
  isShowLoading:true//是否显示DialogLoading
})
@GET("url")
 getData():Promise<string> | undefined{
  return undefined
}
```


## 五、上传下载

### 1、上传文件

```typescript
 const multiForm = new rcp.MultipartForm({
  "user_id": "abner_598251622603504",
  "filename": {
    contentType: "image/png",
    remoteFileName: "filename",
    contentOrPath: getContext().cacheDir + "/4b21763a6a7baa1b12c552378b2eb63a.png",
  }
})
Net.post("https://www.xx.cn/xx")
  .setParams(multiForm)
  .requestString(() => {

  })
```

### 2、下载文件

```typescript
 Net.downLoadFile("https://img-blog.csdnimg.cn/img_convert/4b21763a6a7baa1b12c552378b2eb63a.png")
  .setFilePath(getContext().cacheDir + "/4b21763a6a7baa1b12c552378b2eb63a.png")
  .setProgress((receivedSize: number, totalSize: number) => {
    console.log("===Progress==进度：" + receivedSize + "总的大小：" + totalSize)
  })
  .request((result) => {
    console.log("===success:" + result)
  }, (error) => {
    console.log("============" + JSON.stringify(error))
  })
```

#### 方法介绍

| 方法           | 类型      | 概述                                                                              |
|--------------|---------|---------------------------------------------------------------------------------|
| downLoadFile | string  | 下载的地址                                                                           |
| setFilePath  | string  | 下载后保存的路径                                                                        |
| setProgress  | 回调函数    | 监听进度，receivedSize下载大小， totalSize总大小                                             |
| request      | 无       | 请求下载，data类型为DownloadTaskState，有四种状态：START(开始),COMPLETE(完成),PAUSE(暂停),REMOVE(结束) |


## 六、Dialog加载

<p align="center"><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/net/harmonyos_dialog.png" width="200px" /></p>

### 使用系统CustomDialogController

#### 1、定义dialog控制器

NetLoadingDialog是net包中自带的，菊花状弹窗，如果和实际业务不一致，可以更换。

```javascript
private mCustomDialogController = new CustomDialogController({
  builder: NetLoadingDialog({
    loadingText: '请等待...'
  }),
  autoCancel: false,
  customStyle: true,
  alignment: DialogAlignment.Center
})
```

#### 2、调用传递控制器方法

此方法会自动显示和隐藏dialog，如果觉得不合适，大家可以自己定义即可。

```typescript
setCustomDialogController(this.mCustomDialogController)
```

### 使用自定义，支持全局

#### 1、使用

在网络请求的时候，直接调用即可。

```typescript
 showDialogLoading()
```

#### 2、自己自定义

dialog支持自己自定义，只需要在全局初始化时设置即可。

```typescript
//定义全局的Builder
@Builder
function DialogLoading() {
  //自己写视图，或者使用自定义组件都行
  Column() {
    Text("我是自定义的Loading")
  }
}

//在全局初始化的时候，设置即可
Net.getInstance().init({
  loadingDialog: wrapBuilder(DialogLoading)
})

```

## 七、咨询作者

如果您在使用上有问题，解决不了，或者查看精华的鸿蒙技术文章，可扫码进行操作。

<p><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/abner.jpg" width="150"></p>


## 一对一指导【收费】

每个人的时间都是宝贵的，做为开发者的我，已经做到了技术上的免费开源，但仍然有很多问题无法做到及时处理。
也考虑到，鸿蒙是一个新的系统，大家在使用上会遇到各种各样的问题，也为了能够及时的解决及回复问题，大家可以付费进行一对一指导。

### 开源库使用指导

<p><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/h_github_9.png" width="150px" /></p>

**重要信息：一定要在付款时备注您的微信号，我会主动加您！切记！切记！！切记！！！**
**诚信经营，来自一个北漂的老程序员心声！**

**一杯饮料的钱，您可以获取权益如下**

- 1、针对网络库使用1对1辅导使用，并跟踪相关问题排查。
- 2、针对我的所有鸿蒙开源库，1对1辅导使用，并跟踪相关问题排查。
- 3、涉及到我的开源库，您提的业务需求，率先第一时间满足，并及时针对性开发。
- 4、未来我的鸿蒙开源库，可先遣体验。
- 5、鸿蒙脚手架，正在研发中，可首批次体验使用。


## License

```
Copyright (C) AbnerMing, HarmonyOsHttp Open Source Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```





