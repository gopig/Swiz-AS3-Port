package org.swizframework.aop.support
{
    public class Pointcut implements IPointcut
    {
		private var _pointcutExpression:String;

        private var _packagePattern:String;
        private var _classPattern:String;
        private var _methodPattern:String;

        private var _annotation:String;

        public function Pointcut( expression:String, annotation:String=null )
        {
            _pointcutExpression = expression;
            _annotation = annotation;

            // parse expression to class and method patterns
            // todo: i want to support maybe adding an execusion AND annotation for further filtering, so if no expression is defined, add '*' for all
            if( _pointcutExpression == null && annotation != null )
                _pointcutExpression = "*";
            parseExpression( _pointcutExpression );
        }

        public function get pointcutExpression():String
        {
            return _pointcutExpression;
        }

        public function get packagePattern():String
        {
            return _packagePattern;
        }

        public function get classPattern():String
        {
            return _classPattern;
        }

        public function get methodPattern():String
        {
            return _methodPattern;
        }

        public function get annotation():String
        {
            return _annotation;
        }


        public function methodNameMatches(methodName:String):Boolean
        {
            // pass the method name to patternMatches
            return patternMatches( methodPattern, methodName );
        }

        public function methodMatches( method:Method ):Boolean
        {
            // pass the method name to patternMatches
            return patternMatches( methodPattern, method.getMethodName() );
        }

        public function classMatches( qualifiedClassName:String ):Boolean
        {
            var packageName:String;
            var className:String;

            // if the class name contains '::', switch for '.'
            if( qualifiedClassName.indexOf( "::" ) > -1 )
            {
                packageName = qualifiedClassName.substr( 0, qualifiedClassName.indexOf("::" ) );
                className = qualifiedClassName.substr( qualifiedClassName.indexOf("::" ) + 2);
            }
            else
            {
                packageName = "";
                className = qualifiedClassName;
            }

            // return match on package and class name
            return patternMatches( packagePattern, packageName ) && patternMatches( classPattern, className );
        }

        public function annotationMatches(annotation:String):Boolean
        {
            return this.annotation == annotation;
        }

        public function containsAnnotation():Boolean
        {
            return annotation != null && annotation.length > 0;
        }

        public function patternMatches( expression:String, pattern:String ):Boolean
        {
            var exp : String;
			var searchIx : int;

			if( expression == "*" )
			{
				return true;
			}
			else if( expression.charAt( 0 ) == "*" && expression.charAt( expression.length - 1 ) == "*" )
			{
				exp = expression.substr( 1, expression.length - 2 );
				searchIx = pattern.indexOf( exp );
				return searchIx > -1;
			}
			else if( expression.charAt( 0 ) == "*" )
			{
				exp = expression.substr( 1 );
				searchIx = pattern.indexOf( exp );
				return searchIx == pattern.length - exp.length;
			}
			else if( expression.charAt( expression.length - 1 ) == "*" )
			{
				exp = expression.substr( 0, expression.length - 1 );
				searchIx = pattern.indexOf( exp );
				return searchIx == 0;
			}
			else
			{
				return pattern == expression;
			}

			return true;
        }

        private function parseExpression( expression:String ):void
        {
            // split the expression into class and method expressions
            var sepIx:int = expression.lastIndexOf( "." );

            if( sepIx < 0 )
            {
                _packagePattern = "*";
                _classPattern = "*";
                _methodPattern = expression;
            }
            else
            {
                var pattern:String = expression.substr( 0, sepIx );

                // pull the method pattern off the end
                _methodPattern = expression.substr( sepIx+1 );

                // now split up the class / package pattern
                sepIx = pattern.lastIndexOf( "." );
                if( sepIx < 0 )
                {
					// todo: im an not sure why we would not be using '*' for the package if only a class is configured
                    _packagePattern = "";
                    _classPattern = pattern;
                }
                else
                {
                    _packagePattern = pattern.substr( 0, sepIx );
                    _classPattern = pattern.substr( sepIx+1 );
                    // if the package pattern ends with "..", it means *, all sub packages
                    if( _packagePattern.charAt( _packagePattern.length - 1 ) == "." )
                    {
                        _packagePattern += "*";
                    }
                }
            }
        }
    }
}