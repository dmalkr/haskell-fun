-- Derived from John Lato examples:
-- https://github.com/JohnLato/iteratee/blob/master/Examples/word.hs
{-# LANGUAGE BangPatterns #-}
import Data.Iteratee
import qualified Data.Iteratee as I
import qualified Data.ByteString.Char8 as BC

import Data.Char (ord)
import Data.ListLike as LL
import System.Environment (getArgs)

-- | An iteratee to calculate the number of characters in a stream.
--   Very basic, assumes ASCII, not particularly efficient.
numChars :: (Monad m, ListLike s el) => I.Iteratee s m Int
numChars = I.length

-- | An efficient numLines using the foldl' iteratee.
-- Rather than converting a stream, this simply counts newline characters.
numLines :: Monad m => I.Iteratee BC.ByteString m Int
numLines = I.foldl' step 0
 where
     step !acc el = if el == (fromIntegral $ ord '\n') then acc + 1 else acc

main = do
  (fname:_) <- getArgs
  print =<< fileDriverVBuf 65536 (numLines `I.zip` numChars) fname
