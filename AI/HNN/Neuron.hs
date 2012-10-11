{-# LANGUAGE BangPatterns, RecordWildCards #-}

module Net (Neuron(..), compute, sigmoid, tanh) where
-- tanh is from Prelude

import Data.Vector.Unboxed (Vector, Unbox)
import qualified Data.Vector.Unboxed as U


-- | Our Neuron type, parametrized by the "number" type, which should be:
--   1/ an instance of Num
--   2/ an instance of Data.Vector.Unboxed.Unbox
data Neuron a = Neuron
                { weights     :: !(Vector a)
                , threshold   :: !a
                , activation  :: a -> a
                , activation' :: a -> a
                }

compute :: (Num a, Unbox a) => Neuron a -> Vector a -> a
compute (Neuron{..}) !inputs = activation $ U.sum (U.zipWith (*) weights inputs)
{-# SPECIALIZE compute :: Neuron Double -> Vector Double -> Double #-}
{-# SPECIALIZE compute :: Neuron Float  -> Vector Float  -> Float  #-}
{-# INLINE compute #-}

sigmoid :: Floating a => a -> a
sigmoid !x = 1 / (1 + exp (-x))

sigmoid' :: Floating a => a -> a
sigmoid' !x = case sigmoid x of
  s -> s * (1 - s)
  
{-# SPECIALIZE sigmoid :: Double -> Double #-}
{-# SPECIALIZE sigmoid :: Float  -> Float  #-}
{-# INLINE sigmoid #-}

{-# SPECIALIZE sigmoid' :: Double -> Double #-}
{-# SPECIALIZE sigmoid' :: Float  -> Float  #-}
{-# INLINE sigmoid' #-}