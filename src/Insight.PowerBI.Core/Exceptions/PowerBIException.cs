using System;
using System.Collections.Generic;
using System.Text;

namespace Insight.PowerBI.Core.Exceptions
{
    public class PowerBIException : Exception
    {
        public PowerBIException(string message, Exception? innerException = null) : base(message, innerException) { }
    }
}
