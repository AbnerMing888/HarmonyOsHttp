import { rcp } from '@kit.RemoteCommunicationKit';
import { HttpInterceptor } from '@abner/http';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/11/11
 * INTRODUCE:全局拦截器，可以在这里进行拦截，设置头参等等逻辑
 * */

export class GlobalInterceptor extends HttpInterceptor {
  httpIntercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    const promise = next.handle(context)
    console.log("===进入了全局拦截器")
    return promise
  }
}