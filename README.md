Swiz-AS3-Port
=============

Swiz AS3 Port
	
	其实没改什么东西，只是把swiz的源码弄下来，去除IFactory之类的flex的依赖，然后根据最新的as3Common调整了一下swiz的源码以及顺手修掉了一个可能是由于多帧加载的一个bug.
	
	demo的话是一个带AOP的demo，SWIZ的demo。它由swiz的as3项目的demo以及 https://github.com/wlepinski/benchmark-aspect-swiz-aop 这个项目组成。
    
    感兴趣的玩家可以参照着这个结构稍微做点东西了。
	
	我是不打算用它做项目了，DI有robotlegs，aop因为在初始化的时候，要把整个swf的类给拿到，这里会卡一下，挺讨厌的，在fp没有多线程之前估计不会考虑。
		
	针对卡一下这个问题也有解决方案，大概就是把程序库尽可能地减少，然后再去改改swiz里面的autoProcesser,让它针对某个loaderinfo去处理。
	
	
	附送给高端成就控的附加资料	
	附带swiz的aop的原理：http://www.as3commons.org/as3-commons-bytecode/proxy.html
	其实aop说白了就是动态的代理类生成，as3Common的bytecode已经内置原生的动态代理生成，用它再做个轮子估计还更好
		
		
		
		
		