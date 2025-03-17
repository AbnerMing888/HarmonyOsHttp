import AbilityStage from "@ohos.app.ability.AbilityStage";
import { Net, NetLogLevel } from "@abner/http";
import { GlobalInterceptor } from "../interceptor/GlobalInterceptor";


export default class App extends AbilityStage {
  onCreate(): void {
    Net.getInstance().init({
      baseUrl: "https://wanandroid.com", //设置全局的baseurl
      interceptors: [new GlobalInterceptor()], //设置全局拦截器
      isReadCache: true, //读取缓存
      httpContext: this.context
    })
  }
}