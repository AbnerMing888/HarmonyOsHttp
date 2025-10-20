import { CacheType, GET, HttpOptions, Net, POST, ReturnDataType } from '@abner/http'
import { ItemBean, ItemNews } from '../model/ItemNews'
import { rcp } from '@kit.RemoteCommunicationKit'
import { ParamType } from '@abner/http/src/main/ets/config/ParamType'
import { DownloadTaskState } from '@abner/http/src/main/ets/model/DownloadTaskState'
import { DataBean } from '../model/DataBean'
import { TestBean } from '../model/TestBean'

@Entry
@Component
struct Index {
  private httpList: string[] =
    ["异步GET获取Json", "异步GET获取对象", "异步GET获取data层",
      "同步GET获取Json", "同步GET获取对象", "同步GET获取data层",
      "异步POST获取Json", "异步POST获取对象", "异步POST获取data层",
      "同步POST获取Json", "同步POST获取对象", "同步POST获取data层",
      "异步DELETE", "同步DELETE", "异步PUT", "同步PUT", "注解方式请求",
      "状态码配置", "设置缓存",
      "设置拦截器", "请求带loading", "下载文件", "上传文件", "设置证书", "POST传递Body", "上传Stream"
      , "下载Stream"
    ]
  @State selectPosition: number = -1

  build() {
    Grid() {
      ForEach(this.httpList, (item: string, index: number) => {
        GridItem() {
          Text(item)
            .fontSize(12)
            .height(50)
            .width("100%")
            .fontWeight(FontWeight.Bold)
            .fontColor(this.selectPosition == index ? Color.White : Color.Black)
            .backgroundColor(this.selectPosition == index ? Color.Red : Color.Transparent)
            .textAlign(TextAlign.Center)
            .border({ width: 1, color: Color.Red, radius: 5 })
        }.onClick(() => {
          this.itemClick(index)
        })
      })
    }
    .width("100%")
    .height("100%")
    .columnsTemplate("1fr 1fr 1fr")
    .columnsGap(10)
    .rowsGap(10)
    .padding({ left: 10, right: 10 })
  }

  itemClick(position: number) {
    this.selectPosition = position
    switch (position) {
      case 0: //异步GET获取Json 参数也可以直接拼接到接口的后面
        Net.get("/popular/column/json")
          .requestString((result) => {
            console.log("===success：" + result)
          }, (err) => {
            console.log("===error：" + err.getMessage())
          })
        break
      case 1: //异步GET获取对象
        Net.get("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).requestObject<ItemNews>((result) => {
          //result 就是 ItemNews对象
          console.log("===success：" + result.message)
        }, (err) => {
          console.log("===error：" + err.getMessage())
        })
        break
      case 2: //异步GET获取data层，支持对象或数组
        Net.post("popular/column/json")
          .request<TestBean[]>((result) => {
            //result 就是 ItemBean[],直接获取data层
            console.log("===success：" + result.length)
          }, (err) => {
            console.log("===error：" + err.getMessage())
          })
        break
      case 3: //同步GET获取Json 参数也可以直接拼接到接口的后面
        this.awaitData(position)
        break
      case 4: //同步GET获取对象
        this.awaitData(position)
        break
      case 5: //同步GET获取data层，支持对象或数组
        this.awaitData(position)
        break
      case 6: //异步POST获取Json
        Net.post("/cert/xx")
          .setParams("", ParamType.Form)
          .setParams({
            "index_type": -1,
            "size": 1,
          }).requestString((result) => {
          console.log("===success：" + result)
        }, (err) => {
          console.log("===error：" + err.getMessage())
        })
        break
      case 7: //异步POST获取对象
        Net.post("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).requestObject<ItemNews>((result) => {
          //result 就是 ItemNews对象
          console.log("===success：" + result.message)
        }, (err) => {
          console.log("===error：" + err.getMessage())
        })
        break
      case 8: //异步POST获取data层
        Net.post("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          })
          .setResultTag(["items"])//如果全局设置了，这里不用设置
          .request<ItemBean[]>((result) => {
            //result 就是 ItemBean[],直接获取data层
            console.log("===success：" + result.length)
          }, (err) => {
            console.log("===error：" + err.getMessage())
          })
        break
      case 9: //同步POST获取Json
        this.awaitData(position)
        break
      case 10: //同步POST获取对象
        this.awaitData(position)
        break
      case 11: //同步POST获取data层，支持对象或数组
        this.awaitData(position)
        break
      case 12: //异步DELETE
        this.awaitData(position)
        break
      case 13: //同步DELETE
        this.awaitData(position)
        break
      case 14: //异步PUT
        this.awaitData(position)
        break
      case 15: //同步PUT
        this.awaitData(position)
        break
      case 16: //注解方式请求
        this.annotate()
        break
      case 17: //状态码配置

        break
      case 18: //设置缓存
        Net.post("/cert/xx")
          .setCacheType(CacheType.FIRST_REMOTE)
          .setParams({
            "index_type": -1,
            "size": 1,
          }).requestString((result) => {
          console.log("===success：" + result)
        }, (err) => {
          console.log("===error：" + err.getMessage())
        })
        break
      case 19: //设置拦截器
        //全局拦截器
        //通过interceptors参数
        // Net.getInstance().init({
        //       interceptors: [new GlobalInterceptor()]//设置全局拦截器
        //     })
        //通过setInterceptors参数
        // Net.getInstance().setInterceptors([new GlobalInterceptor()])

        //单个拦截器
        /*
        Net.post("/cert/xx")
          .setInterceptor(new TestInterceptor())//单独增加拦截器
            // .setRequestInterceptors() //可以通过这个方法，设置只加载自身拦截器，过滤掉全局
          .setParams({
            "index_type": -1,
            "size": 1,
          })
          .requestString((result) => {
            console.log("===success：" + result)
          }, (err) => {
            console.log("===error：" + err.getMessage())
          })
         */
        break
      case 20: //请求带loading
        Net.post("/cert/xx")
          .showDialogLoading()
          .setParams({
            "index_type": -1,
            "size": 1,
          })
          .requestString((result) => {
            console.log("===success：" + result)
          }, (err) => {
            console.log("===error：" + err.getMessage())
          })
        break
      case 21: //下载文件
        Net.downLoadFile("https://img-blog.csdnimg.cn/img_convert/4b21763a6a7baa1b12c552378b2eb63a.png")
          .setFilePath(getContext().cacheDir + "/4b21763a6a7baa1b12c552378b2eb63a.png")
          .setProgress((receivedSize: number, totalSize: number) => {
            console.log("===Progress==进度：" + receivedSize + "总的大小：" + totalSize)
          })
          .request((result) => {
            if (result == DownloadTaskState.COMPLETE) {
              console.log("===success:下载完成")
            }
          }, (error) => {
            console.log("============" + JSON.stringify(error))
          })
        break
      case 22: //上传文件
        const multiForm = new rcp.MultipartForm({
          "userid": "abner_598251622603504",
          "file": {
            contentType: "image/png",
            remoteFileName: "4b21763a6a7baa1b12c552378b2eb63a.png",
            contentOrPath: getContext().cacheDir + "/4b21763a6a7baa1b12c552378b2eb63a.png",
          }
        })

        Net.post("http://10.47.16.204/test/upload.php")
          .setParams(multiForm, ParamType.UploadFromFile)
          .setContext(getContext())
          .setHeaders({ "Content-Type": "multipart/form-data" })
          .requestString((data) => {
            console.log("=================" + data)
          })

        break
      case 23: //证书
        this.annotate2()
        break
      case 24: //post上传body
        Net.post("http://10.47.16.124:8888/queryTest")
          .setParams({ "userName": "abner" }, ParamType.RawDataContent)
          .requestString((data) => {
            console.log("=================" + data)
          })
        break
      case 25: //上传Stream

        Net.UpLoadFromStream("")
        //.setUploadFrom(s)//自行定义 rcp.Stream | rcp.ReadStream | rcp.SyncReadStream
          .request((response) => {

          })
        break
      case 26: //下载Stream
        Net.downLoadToStream("")
        // .setStream()
          .request((response) => {

          })
        break
    }
  }

  async awaitData(type: number) {
    switch (type) {
      case 3: //同步GET获取Json 参数也可以直接拼接到接口的后面
        let result = await Net.get("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).returnData<string>(ReturnDataType.STRING)

        console.log("===success:" + result)
        break
      case 4: //同步GET获取对象
        let itemBean = await Net.get("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).returnData<ItemNews>(ReturnDataType.OBJECT)

        console.log("===success:" + itemBean.message)
        break
      case 5: //同步GET获取data层，支持对象或数组
        let item = await Net.get("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).setResultTag(["items"])//如果全局设置了，这里不用设置
          .returnData<ItemBean[]>()
        console.log("===success:" + item.length)
        break
      case 9: //同步post获取Json 参数也可以直接拼接到接口的后面
        let result2 = await Net.post("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).returnData<string>(ReturnDataType.STRING)

        console.log("===success:" + result2)
        break
      case 10: //同步post获取对象
        let itemBean2 = await Net.post("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).returnData<ItemNews>(ReturnDataType.OBJECT)

        console.log("===success:" + itemBean2.message)
        break
      case 11: //同步post获取data层，支持对象或数组
        let item2 = await Net.post("/cert/xx")
          .setParams({
            "index_type": -1,
            "size": 1,
          }).setResultTag(["items"])//如果全局设置了，这里不用设置
          .returnData<ItemBean[]>()
        console.log("===success:" + item2.length)
        break
      case 12: //异步DELETE
        //和get/post一样,换成delete即可
        break
      case 13: //同步DELETE
        //和get/post一样 换成delete即可
        break
      case 14: //异步PUT
        //和get/post一样 换成put即可
        break
      case 15: //同步PUT
        //和get/post一样 换成put即可
        break
    }

  }

  //注解方式
  async annotate() {
    let result = await this.testParams({ baseUrl: "https://wanandroid.com", isReturnJson: true })
    console.log("===success:" + result)
  }

  @GET("/popular/wenda/json")
  testParams(data?: HttpOptions): Promise<string> | undefined {
    return undefined
  }

  async annotate2() {
    let result = await this.testParams2({ baseUrl: "https://www.vipandroid.com", isReturnJson: true })
    console.log("===success:" + result)
  }

  @GET("/popular/wenda/json")
  testParams2(data?: HttpOptions): Promise<string> | undefined {
    return undefined
  }

  @POST("/cert/xx",{
    baseUrl: "http://www.baidu.com",
    params: {
      "index_type": -1,
      "size": 1,
    },
    isReturnJson: true,
    isShowLoading: true
  })
  test(): Promise<string> | undefined {
    return undefined
  }
}