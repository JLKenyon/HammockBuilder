{--
  
  Copyright (c) 2010 John Lincoln Kenyon
  
  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation
  files (the "Software"), to deal in the Software without
  restriction, including without limitation the rights to use,
  copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following
  conditions:
  
  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  OTHER DEALINGS IN THE SOFTWARE.
  
  --}

module Hammock where
    
version = "0.0.1"


--data Action = Action { input  :: FilePath
--                     , output :: FilePath
--                     , command :: String
--                     }
--              deriving(Eq, Show)

data BuildSystem a = BuildSystem
                     deriving(Show)

instance Monad BuildSystem where
    return a = BuildSystem
    m >>= k  = BuildSystem

-- --------------------------------------------------------

--cpp :: FilePath -> BuildSystem String
cpp :: String -> BuildSystem String
cpp fname = (return fname) :: (BuildSystem String)

--project :: String -> BuildSystem a -> BuildSystem String
--project :: String -> t -> BuildSystem String
project :: String -> BuildSystem String -> BuildSystem String
project pname build = (return pname) :: (BuildSystem String)

--exe :: String -> BuildSystem FilePath
--exe :: String -> t -> BuildSystem String
exe :: String -> BuildSystem String -> BuildSystem String
exe fname build = (return fname) :: (BuildSystem String)

--output_dir :: String -> BuildSystem ()
--output_dir :: t -> BuildSystem ()
output_dir :: String -> BuildSystem ()
output_dir dir_name = return () :: (BuildSystem ())

