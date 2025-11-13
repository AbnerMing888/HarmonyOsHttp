import { NetError, NetErrorInterceptor } from "@abner/http";


export class MyNetErrorInterceptor extends NetErrorInterceptor {
  httpError(error: NetError): void {
    console.log("全局错误：" + error.getCode())
  }
}