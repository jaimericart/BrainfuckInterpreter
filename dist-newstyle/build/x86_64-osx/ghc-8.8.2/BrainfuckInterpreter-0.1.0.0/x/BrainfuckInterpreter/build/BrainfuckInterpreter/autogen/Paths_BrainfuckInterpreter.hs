{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_BrainfuckInterpreter (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/jaimericart/.cabal/bin"
libdir     = "/Users/jaimericart/.cabal/lib/x86_64-osx-ghc-8.8.2/BrainfuckInterpreter-0.1.0.0-inplace-BrainfuckInterpreter"
dynlibdir  = "/Users/jaimericart/.cabal/lib/x86_64-osx-ghc-8.8.2"
datadir    = "/Users/jaimericart/.cabal/share/x86_64-osx-ghc-8.8.2/BrainfuckInterpreter-0.1.0.0"
libexecdir = "/Users/jaimericart/.cabal/libexec/x86_64-osx-ghc-8.8.2/BrainfuckInterpreter-0.1.0.0"
sysconfdir = "/Users/jaimericart/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "BrainfuckInterpreter_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "BrainfuckInterpreter_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "BrainfuckInterpreter_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "BrainfuckInterpreter_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "BrainfuckInterpreter_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "BrainfuckInterpreter_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
