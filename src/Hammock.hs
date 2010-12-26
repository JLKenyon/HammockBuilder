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
import Data.List
import Data.Set (difference, fromList, elems)
    
version = "0.0.1"

data BuildConfig = BuildConfig { _output_dir :: FilePath
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
                                 , top :: [String]
                                 , value :: a
                                 }
                     deriving(Eq, Show)

-- --------------------------------------------------------

mergeConfig :: BuildConfig -> BuildConfig -> BuildConfig
mergeConfig lConfig rConfig = BuildConfig {
                                _output_dir   = _output_dir rConfig
                              , _include_dirs = _include_dirs lConfig ++ _include_dirs rConfig
                              , _link_dirs    = _link_dirs    lConfig ++ _link_dirs    rConfig
                              , _link_libs    = _link_libs    lConfig ++ _link_libs    rConfig
                              , _defines      = _defines      lConfig ++ _defines      rConfig
                              }

instance Monad BuildSystem where
    return a = BuildSystem [] emptyConfig [] a
    m >>= k  = let (BuildSystem p_list p_config p_top p_val) = m
                   (BuildSystem n_list n_config n_top n_val) = k p_val
               in BuildSystem (p_list ++ n_list) (mergeConfig p_config n_config) (p_top ++ n_top) n_val

-- --------------------------------------------------------

emptyConfig = BuildConfig { _output_dir   = "" :: FilePath
                        , _include_dirs = [] :: [FilePath]
                        , _link_dirs    = [] :: [FilePath]
                        , _link_libs    = [] :: [String]
                        , _defines      = [] :: [(String, String)]
                        }

-- --------------------------------------------------------

genActionDot :: Action -> [String]
genActionDot (Action input output _) = ["  " ++ show x ++ " -> " ++ show y ++ "\n" | x <- input, y <- output]

genDot :: BuildSystem a -> String
genDot build = header ++ content ++ footer
    where header = "digraph G {\n"
          footer = "}\n"
          content = concat $ concat $ map genActionDot alist
          -- content = concat $ concat $ map _input alist
          -- content = intercalate ("\n"::FilePath) ((map _input alist)::[FilePath])
          (BuildSystem alist _ _ _) = build

-- --------------------------------------------------------

cpp :: String -> BuildSystem String
cpp fname = BuildSystem [action] emptyConfig [objname] fname
    where action = Action [fname] [objname] emptyConfig
          objname = convert_to_obj fname
          convert_to_obj :: String -> String
          convert_to_obj = flip replaceExtension ".o"

project :: String -> BuildSystem String -> BuildSystem String
project pname build = BuildSystem (new_action : sub_alist) sub_config [pname] pname
    where (BuildSystem sub_alist sub_config sub_top _) = build
          new_action = Action sub_top [pname] sub_config


exe :: String -> BuildSystem String -> BuildSystem String
exe fname build = BuildSystem (new_action : sub_alist) sub_config [fname] fname
    where (BuildSystem sub_alist sub_config sub_top _) = build
          -- This is where I need to do the graph search to determine
          -- which are "un-directed" actions... for now I will
          -- fudge it...
          -- new_action = Action (concat $ map _output sub_alist) [fname] sub_config
          new_action = Action sub_top [fname] sub_config
    

output_dir :: String -> BuildSystem ()
output_dir out_dir =  BuildSystem [] config [] ()
    where config = BuildConfig { _output_dir = out_dir
                               , _include_dirs = []
                               , _link_dirs = []
                               , _link_libs = []
                               , _defines = []
                               }

