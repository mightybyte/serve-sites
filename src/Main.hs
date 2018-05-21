{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Text.Encoding
import qualified Data.Text as T
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import System.Directory
import System.Environment
import System.FilePath
import Text.Printf

site :: FilePath -> Snap ()
site root = do
    req <- getRequest
    let domain = T.unpack $ decodeUtf8 $ rqServerAddr req
    serveDirectory (root </> domain)

main :: IO ()
main = do
    args <- getArgs
    case args of
      [] -> printUsage
      (root:_) -> do
        dirExists <- doesDirectoryExist root
        if dirExists
          then quickHttpServe (site root)
          else do
            putStrLn $ unlines
              [ "First argument must be a directory that exists!"
              , ""
              ]
            printUsage

printUsage :: IO ()
printUsage = do
    progName <- getProgName
    printf "Usage: ./%s <server_root>\n" progName
