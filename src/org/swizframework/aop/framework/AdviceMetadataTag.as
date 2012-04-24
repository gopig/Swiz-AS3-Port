package org.swizframework.aop.framework
{
    import org.swizframework.reflection.BaseMetadataTag;
    import org.swizframework.reflection.IMetadataTag;

    public class AdviceMetadataTag extends BaseMetadataTag
    {
		/**
		 * Backing variable for read-only <code>execution</code> property.
         *
         * Execution is also the default expression string
		 */
		protected var _execution:String;

        /**
         * Backing variable for read-only <code>arguments<code> property.
         */
        protected var _arguments:Array;

        /**
         * Backing variable for read-only <code>annotation<code> property.
         */
        protected var _annotation:String;

        public function AdviceMetadataTag()
        {
            super();
            defaultArgName = "execution";
        }

		/**
		 * Returns execution (class/method sig) expression which will be used to build the pointcut for the advice.
		 */
		public function get execution():String
		{
			return _execution;
		}

		/**
		 * Returns annotation which can be used to build the pointcut for the advice.
		 */
		public function get annotation():String
		{
			return _annotation;
		}

		/**
		 * Returns arguments array which should be available to the advice method.
		 */
		public function get arguments():Array
		{
			return _arguments;
		}

		// ========================================
		// public methods
		// ========================================

		override public function copyFrom( metadataTag:IMetadataTag ):void
		{
			super.copyFrom( metadataTag );

			if( hasArg( "execution" ) )
			{
				_execution = getArg( "execution" ).value;
			}

			if( hasArg( "annotation" ) )
			{
				_annotation = getArg( "annotation" ).value;
			}

			if( hasArg( "arguments" ) )
			{
				_arguments = getArg( "arguments" ).value.replace(/\ /g,"").split(",");
			}
        }
    }
}