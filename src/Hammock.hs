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

import System.FilePath.Posix
    
version = "0.0.1"

data BuildConfig = CppConfig { _output_dir :: FilePath
                             , _include_dirs :: [FilePath]
                             , _link_dirs :: [FilePath]
                             , _link_libs :: [String]
                             , _defines :: [(String, String)]
                             }
                   deriving(Eq, Show)
                           
data Action = Action { _input  :: [FilePath]
                     , _output :: [FilePath]
                     , _configuration :: BuildConfig
                     }
              deriving(Eq, Show)

data BuildSystem a = BuildSystem { actionList :: [Action]
                                 , __config :: BuildConfig
                                 , value :: a
                                 }
                     deriving(Eq, Show)

-- --------------------------------------------------------

mergeConfig :: BuildConfig -> BuildConfig -> BuildConfig
mergeConfig lConfig rConfig = undefined

instance Monad BuildSystem where
    return a = BuildSystem [] emptyConfig a
    m >>= k  = let (BuildSystem p_list p_config p_val) = m
                   (BuildSystem n_list n_config n_val) = k p_val
               in BuildSystem (p_list ++ n_list) (mergeConfig p_config n_config) n_val

-- --------------------------------------------------------

emptyConfig = CppConfig { _output_dir   = "" :: FilePath
                        , _include_dirs = [] :: [FilePath]
                        , _link_dirs    = [] :: [FilePath]
                        , _link_libs    = [] :: [String]
                        , _defines      = [] :: [(String, String)]
                        }

-- --------------------------------------------------------

cpp :: String -> BuildSystem String
cpp fname = BuildSystem [action] emptyConfig fname
    where action = Action [fname] [(convert_to_obj fname)] emptyConfig
          convert_to_obj :: String -> String
          convert_to_obj = flip replaceExtension ".o"

project :: String -> BuildSystem String -> BuildSystem String
project pname build = (return pname) :: (BuildSystem String)


exe :: String -> BuildSystem String -> BuildSystem String
exe fname build = (return fname) :: (BuildSystem String)


output_dir :: String -> BuildSystem ()
output_dir dir_name = return () :: (BuildSystem ())

