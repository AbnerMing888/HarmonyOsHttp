import { rcp } from '@kit.RemoteCommunicationKit';
import { HttpInterceptor } from '@abner/http';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/11/11
 * INTRODUCE:测试拦截器
 * */

export class TestInterceptor extends HttpInterceptor {
  httpIntercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    const promise = next.handle(context)
    console.log("===进入了单个拦截器")
    return promise
  }
}