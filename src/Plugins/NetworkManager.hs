{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Plugins.HelloWorld
-- Copyright   :  (c) Andrea Rossato
-- License     :  BSD-style (see LICENSE)
--
-- Maintainer  :  Jose A. Ortega Ruiz <jao@gnu.org>
-- Stability   :  unstable
-- Portability :  unportable
--
-- A plugin example for Xmobar, a text based status bar
--
-----------------------------------------------------------------------------

module Plugins.NetworkManager where

import Plugins
import DBus
import DBus.Client
import Data.Maybe
import Control.Exception (bracket, catch, SomeException)
import Data.ByteString (ByteString)
import Data.ByteString.Char8 as B ( unpack )
import Control.Monad 

data NetworkManager = NetworkManager
    deriving (Read, Show)

instance Exec NetworkManager where
    alias NetworkManager = "networkManager"
    run   NetworkManager = bracket connectSystem disconnect nMStatus
    rate  NetworkManager = 10

nMStatus :: Client -> IO String
nMStatus client = catch (getConnectedWifiESSID client) handleError
 where
  getConnectedWifiESSID client = do
   activeConnection <- methodGET
     "/org/freedesktop/NetworkManager"
     [toVariant ("org.freedesktop.NetworkManager" :: String) , toVariant ("ActiveConnections" :: String)]
     client
 
   accessPoint <- methodGET
     (head . getFirstVariant $ activeConnection)
     [toVariant ("org.freedesktop.NetworkManager.Connection.Active" :: String) , toVariant ("SpecificObject" :: String)]
     client
 
   reply <- methodGET
     (getFirstVariant accessPoint)
     [toVariant ("org.freedesktop.NetworkManager.AccessPoint" :: String) , toVariant ("Ssid" :: String)]
     client
 
   return $ "Connected to : " ++ (B.unpack $ (getFirstVariant reply :: ByteString))

  getFirstVariant :: IsVariant a => MethodReturn -> a
  getFirstVariant = fromJust . (listToMaybe . methodReturnBody >=> fromVariant >=> fromVariant)
  
  methodGET :: ObjectPath -> [Variant] -> Client -> IO MethodReturn
  methodGET objectPath parameters client = do
      call_ client (methodCall objectPath "org.freedesktop.DBus.Properties" "Get") {  
         methodCallDestination = Just "org.freedesktop.NetworkManager" 
         , methodCallBody = parameters
      }

  handleError :: SomeException -> IO String
  handleError e = return "Not Connected"

