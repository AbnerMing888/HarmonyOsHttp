import AbilityStage from '@ohos.app.ability.AbilityStage';
import { Net } from '@abner/http';
import { GlobalInterceptor } from '../interceptor/GlobalInterceptor';
import { MyNetErrorInterceptor } from '../interceptor/MyNetErrorInterceptor';


export default class App extends AbilityStage {
  onCreate(): void {
    Net.getInstance().init({
      baseUrl: "https://www.xx.com", //设置全局的baseurl
      interceptors: [new GlobalInterceptor()], //设置全局拦截器
      isReadCache: false, //读取缓存
      httpContext: this.context,
      netErrorInterceptor: new MyNetErrorInterceptor()
    })
  }
}
