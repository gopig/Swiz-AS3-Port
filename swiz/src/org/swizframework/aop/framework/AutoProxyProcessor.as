package org.swizframework.aop.framework
{
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    
    import mx.utils.ObjectUtil;
    
    import org.as3commons.bytecode.proxy.IClassProxyInfo;
    import org.as3commons.bytecode.proxy.IProxyFactory;
    import org.as3commons.bytecode.proxy.impl.ClassProxyInfo;
    import org.as3commons.bytecode.proxy.impl.ProxyFactory;
    import org.as3commons.bytecode.reflect.ByteCodeType;
    import org.swizframework.aop.interceptor.AfterInterceptor;
    import org.swizframework.aop.interceptor.BeforeInterceptor;
    import org.swizframework.aop.interceptor.MethodInterceptor;
    import org.swizframework.aop.interceptor.ProxyMethodFactory;
    import org.swizframework.aop.support.Advice;
    import org.swizframework.aop.support.Advisor;
    import org.swizframework.aop.support.AdvisorChain;
    import org.swizframework.aop.support.IAdvice;
    import org.swizframework.aop.support.IMethodInterceptor;
    import org.swizframework.aop.support.IMethodInvocation;
    import org.swizframework.aop.support.IPointcut;
    import org.swizframework.aop.support.Pointcut;
    import org.swizframework.core.Bean;
    import org.swizframework.core.BeanFactory;
    import org.swizframework.core.IBeanFactory;
    import org.swizframework.core.ISwiz;
    import org.swizframework.core.SwizManager;
    import org.swizframework.processors.BaseMetadataProcessor;
    import org.swizframework.processors.IFactoryProcessor;
    import org.swizframework.reflection.BaseMetadataTag;
    import org.swizframework.reflection.IMetadataTag;
    import org.swizframework.reflection.MetadataHostMethod;
    import org.swizframework.reflection.MethodParameter;
    import org.swizframework.reflection.TypeDescriptor;

    public class AutoProxyProcessor extends BaseMetadataProcessor implements IFactoryProcessor
    {
        private var ADVICE:String = "Advice";
        private var BEFORE:String = "Before";
        private var AFTER:String = "After";
        private var AROUND:String = "Around";

        private var _advice:Array;
        private var _advisors:Array;
        private var _pendingBeans:Array = new Array();
        private var _beanChains:Dictionary = new Dictionary();

        private var proxyFactory:IProxyFactory;

        public function AutoProxyProcessor()
        {
            super( [ ADVICE, BEFORE, AFTER, AROUND ] );
        }

        public function get advice():Array
        {
            return _advice;
        }

        public function set advice( value:Array ):void
        {
            if( value != null )
            {
                _advice = value;
            }

        }

        override public function init(swiz:ISwiz):void
        {
            super.init(swiz);

            // set up all the advisors
            createAdvisors();
        }

        public function setUpFactory(factory:IBeanFactory):void
        {
            // now process all the beans
            var descXML:XML;
            var methodName:String;
            var accessorName:String;

            var advisor:Advisor;
            var haltBeanFactory:Boolean = false;
            var mdHostMethod:MetadataHostMethod;
			var mdHostObject:*

            // loop over all the beans in the factory, and find advisors, skip prototypes!
            for each( var bean:Bean in factory.beans )
            {
                // will hold the advisorChain for this bean, if we find anything to add
                var advisorChain:AdvisorChain = null;

                // get the type descriptor so we can see all the methods
                descXML = bean.typeDescriptor.description;

                // first, look for method advisors, based on package.class.method as well as annotations
                for each( var mNode:XML in descXML..method )
                {
                    methodName = mNode.@name;
                    for( var i:int = 0; i<_advisors.length; i++ )
                    {
                        advisor = Advisor( _advisors[ i ] );
                        if( advisor.classMatches( bean.typeDescriptor.className ) && advisor.methodNameMatches( methodName ) )
                        {
                            // if the advisor defines an annotation, look for a matching metadata hosts for the method
                            if( advisor.containsAnnotation() )
                            {
								mdHostObject = bean.typeDescriptor.metadataHosts[ methodName ];
                                mdHostMethod = !( mdHostObject is MetadataHostMethod ) ? null : MetadataHostMethod( mdHostObject );
                                if( mdHostMethod != null )
                                {
                                    for each( var mdTag:BaseMetadataTag in mdHostMethod.metadataTags )
                                    {
                                        if( advisor.annotationMatches( mdTag.name ) )
                                        {
                                            advisorChain ||= new AdvisorChain();
                                            advisorChain.addMethodAdvisor( methodName, advisor, mdTag );
                                            // todo: register the metadata for the method too!!
                                        }
                                    }
                                }
                            }
                            else
                            {
                                advisorChain ||= new AdvisorChain();
                                advisorChain.addMethodAdvisor( methodName, advisor );
                            }
                        }
                    }
                }

                // if an advisor chain was created, we rock! make proxy!
                if( advisorChain != null )
                {
                    _pendingBeans.push( bean );
                    _beanChains[ bean ] = advisorChain;
                    haltBeanFactory = true;
                }
            }

            // if we set to halt the bean factory, do it! and make the proxies!!!!!
            if( haltBeanFactory )
            {
                trace( "setting bean factory to wait to complete, creating proxies" );
                BeanFactory( factory ).waitForSetup = true;
                createProxies();
            }
        }

        private function createAdvisors():void
        {
            trace("setting up advisor classes");

            // crap ! swiz init is an issue here!!!
            // create an array of beans from the advice classes
            var adviceBeans:Array = [];
            for( var j:int = 0; j < _advice.length; j++ )
            {
                adviceBeans.push( BeanFactory.constructBean( _advice[ j ], null, swiz.domain ) );
            }

            // now create advisors from each bean
            _advisors = [];

            var adviceClass:Object;
            var typeDescriptor:TypeDescriptor;
            var mdTags:Array;
            var adviceMd:AdviceMetadataTag;
            var adviceMdParams:Array;
            var adviceArgs:Array;
            var pointcut:IPointcut;
            var interceptor:IMethodInterceptor;
            var advice:IAdvice;

            for( var i:int = 0; i < adviceBeans.length; i++ )
            {
                // get the advice class from the bean
                adviceClass = Bean( adviceBeans[ i ] ).source;

                // get type descriptor from the bean
                typeDescriptor = Bean( adviceBeans[ i] ).typeDescriptor;

                // get the before, after ( and around ) tags
                mdTags = [];
                mdTags = mdTags.concat( typeDescriptor.getMetadataTagsByName( "Before" ) );
                mdTags = mdTags.concat( typeDescriptor.getMetadataTagsByName( "After" ) );
                mdTags = mdTags.concat( typeDescriptor.getMetadataTagsByName( "Around" ) );

                // turn all the metadata tags into advice
                for each( var mdTag:IMetadataTag in mdTags )
                {
                    adviceMd = new AdviceMetadataTag();
                    adviceMd.copyFrom(mdTag);

                    // if advice defines annotation for pointcut, it needs to be stored on the pointcut
                    // and the metadata needs to be registered with this processor for all TypeDescriptors
                    if( adviceMd.annotation != null && adviceMd.annotation.length > 0 &&
                        SwizManager.metadataNames.indexOf( adviceMd.annotation ) < 1 )
                    {
                            SwizManager.metadataNames.push( adviceMd.annotation );
                    }

                    adviceMdParams = MetadataHostMethod( adviceMd.host ).parameters;

                    // create an array of argument classes for advice method
                    adviceArgs = null;
                    if( adviceMdParams.length > 0 )
                    {
                        adviceArgs = [];
                        for( var k:int=0; k<adviceMdParams.length; k++ )
                            adviceArgs.push( MethodParameter( adviceMdParams[ k ] ).type );
                    }

                    // create pointcut and advice from metadata and advice method
                    pointcut = new Pointcut( adviceMd.execution, adviceMd.annotation );
                    advice = new Advice( adviceClass[ adviceMd.host.name ], adviceArgs );

                    // create the correct type if interceptor
                    if( adviceMd.name == "Before" )
                        interceptor = new BeforeInterceptor( advice );
                    else if (adviceMd.name == "After" )
                        interceptor = new AfterInterceptor( advice );
                    else if (adviceMd.name == "Around" )
                    {
                        if( adviceArgs.length > 0 && adviceArgs[ 0 ] == IMethodInvocation )
                            interceptor = new MethodInterceptor( advice );
                        else
                            trace( "WARNING!! Around methods MUST defined their first argument as 'invocation:IMethodInvocation' !")
                    }

                    // store
                    _advisors.push( new Advisor( pointcut, interceptor ) );
                }
            }
        }

        private function createProxies():void
        {
            // initialize creation of proxy class

            // ByteCodeType.fromLoader( FlexGlobals.topLevelApplication.stage.loaderInfo );
			var _applicationDomain:ApplicationDomain =LoaderInfo( Object( swiz.dispatcher ).systemManager.loaderInfo).applicationDomain;
			// you must use try catch to handle the fromByteArray. it throw errors sometimes
			try
			{
	            ByteCodeType.fromByteArray(( Object( swiz.dispatcher ).systemManager.loaderInfo.bytes),_applicationDomain);
			} 
			catch(error:Error) 
			{
				//trace(error.message);
			}

            // create proxy factory
            proxyFactory = new ProxyFactory();
            // loop over all the beans we stored and create their proxies
            var classProxyInfo:IClassProxyInfo;
            var chain:AdvisorChain;
            var methodNames:Array;
            for each( var bean:Bean in _pendingBeans )
            {
                chain = AdvisorChain( _beanChains[ bean ] );
                classProxyInfo = proxyFactory.defineProxy( bean.typeDescriptor.type,null,_applicationDomain );
                classProxyInfo.interceptorFactory = new ProxyMethodFactory( chain );

                // add the methods
                methodNames = chain.getAdvisedMethods();
                for( var i:int=0; i<methodNames.length; i++ )
                    classProxyInfo.proxyMethod( methodNames[ i ] );
            }
			
            // now generate the proxy classes and add load events;
            proxyFactory.generateProxyClasses();
            proxyFactory.addEventListener( Event.COMPLETE, handleProxies );
            proxyFactory.addEventListener( IOErrorEvent.VERIFY_ERROR, handleVerifyError );
            proxyFactory.loadProxyClasses();


        }

        private function handleProxies( e:Event ):void
        {
            trace("Proxies loaded! replacing beans!");
            proxyFactory.removeEventListener( Event.COMPLETE, handleProxies );
            proxyFactory.removeEventListener( IOErrorEvent.VERIFY_ERROR, handleVerifyError );

            // swap out the source of each pending bean with a proxy
            for each( var bean:Bean in _pendingBeans )
            {
                bean.source = proxyFactory.createProxy( bean.typeDescriptor.type ) as bean.typeDescriptor.type;
                delete _beanChains[ bean ];
            }

            _pendingBeans = [];

            // now have swiz continue
            BeanFactory( swiz.beanFactory ).waitForSetup = false;
            BeanFactory( swiz.beanFactory ).completeBeanFactorySetup();

        }

        public function handleVerifyError( ioe:IOErrorEvent ):void
        {
            trace("oops, verification error!");
            proxyFactory.removeEventListener( Event.COMPLETE, handleProxies );
            proxyFactory.removeEventListener( IOErrorEvent.VERIFY_ERROR, handleVerifyError );

            trace( ObjectUtil.toString( ioe ) );
        }

    }


    /*
    for each( var aNode:XML in descXML..accessor )
    {
        if( aNode.@access == "readwrite" )
        {
            accessorName = aNode.@name;
            for( var j:int = 0; j<_advisors.length; j++ )
            {
                advisor = Advisor( _advisors[ j ] );
                if( advisor.classMatches( bean.typeDescriptor.className ) && advisor.methodNameMatches( accessorName ) )
                {
                    advisorChain ||= new AdvisorChain();
                    advisorChain.addMethodAdvisor( accessorName, advisor );
                }
            }
        }
    }
    */
}