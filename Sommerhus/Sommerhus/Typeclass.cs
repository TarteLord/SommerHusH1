using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace Sommerhus
{
    class Typeclass
    {
        public void TypeWriter(string s)
        {
            for (int i = 0; i < s.Length; i++)
            {
                Console.Write(s[i]);
                Thread.Sleep(20);
            }
        }
    }
}
