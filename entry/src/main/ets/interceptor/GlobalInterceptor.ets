import { rcp } from '@kit.RemoteCommunicationKit';
import { HttpInterceptor } from '@abner/http';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/11/11
 * INTRODUCE:全局拦截器，可以在这里进行拦截，设置头参等等逻辑
 * */
export class GlobalInterceptor extends HttpInterceptor {
  async httpIntercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {


    // const promise = await next.handle(context)
    //自定义返回值
    // let response: rcp.Response = {
    //   request: context.request,
    //   headers: promise.headers,
    //   statusCode: promise.statusCode,
    //   toString:()=>"{\"data\":[{\"chapterId\":0,\"chapterName\":\"\",\"columnId\":2,\"id\":26,\"name\":\"Kotlin\",\"subChapterId\":231,\"subChapterName\":\"\",\"url\":\"\",\"userId\":4943},{\"chapterId\":0,\"chapterName\":\"\",\"columnId\":2,\"id\":22,\"name\":\"自定义控件\",\"subChapterId\":37,\"subChapterName\":\"\",\"url\":\"\",\"userId\":4943},{\"chapterId\":0,\"chapterName\":\"\",\"columnId\":2,\"id\":32,\"name\":\"Jetpack\",\"subChapterId\":422,\"subChapterName\":\"\",\"url\":\"\",\"userId\":4943}],\"errorCode\":0,\"errorMsg\":\"\"}",
    //   toJSON: () => null
    // }
    // return Promise.resolve(response)
    let response = next.handle(context)

    return response
  }
}