{-# LANGUAGE CPP #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE QuantifiedConstraints #-}

#ifndef MIN_VERSION_profunctors
#define MIN_VERSION_profunctors(x,y,z) 1
#endif

module Data.Profunctor.Optic.Types (
    -- * Optic
    Optic, Optic'
  , IndexedOptic, IndexedOptic'
  , CoindexedOptic, CoindexedOptic'
    -- * Equality
  , Equality, Equality'
    -- * Iso
  , Iso, Iso'
    -- * Lens & Colens
  , Lens, Lens', Ixlens, Ixlens'
  , Colens, Colens', Cxlens, Cxlens'
    -- * Prism & Coprism
  , Prism, Prism', Cxprism, Cxprism'
  , Coprism, Coprism'
    -- * Grate
  , Grate, Grate', Cxgrate, Cxgrate'
    -- * Traversal0
  , Traversal0   , Traversal0'  , Ixtraversal0, Ixtraversal0'
  , Cotraversal0 , Cotraversal0'
    -- * Traversal1 & Cotraversal1
  , Traversal1   , Traversal1'  , Ixtraversal1, Ixtraversal1'
  , Cotraversal1 , Cotraversal1', Cxtraversal1, Cxtraversal1'
    -- * Traversal
  , Traversal    , Traversal'   , Ixtraversal , Ixtraversal'
  , Cotraversal  , Cotraversal'
    -- * Fold0
  , Fold0, Ixfold0
    -- * Fold1 & Cofold1
  , Fold1, Ixfold1, Cofold1
    -- * Fold
  , Fold, Ixfold, Cofold
    -- * View & Review
  , PrimView, View, Ixview, PrimReview, Review, Cxview
    -- * Setter & Resetter
  , Setter, Setter', Ixsetter, Ixsetter'
  , Resetter, Resetter', Cxsetter, Cxsetter'
    -- * Common represenable and corepresentable carriers
  , ARepn, ARepn', AIxrepn, AIxrepn'
  , ACorepn, ACorepn', ACxrepn, ACxrepn'
  , between, (&)
  , Coapplicative(..), Coapply(..)
    -- * 'Re'
  , Re(..), re
  , module Export
) where

import Data.Bifunctor (Bifunctor(..))
import Data.Functor.Apply (Apply(..))
import Data.Profunctor.Optic.Import
import Data.Profunctor.Extra as Export (type (+))
import Data.Profunctor.Types as Export
import qualified Control.Arrow as A

-- $setup
-- >>> :set -XCPP
-- >>> :set -XNoOverloadedStrings
-- >>> :load Data.Profunctor.Optic

---------------------------------------------------------------------
-- 'Optic'
---------------------------------------------------------------------

type Optic p s t a b = p a b -> p s t

type Optic' p s a = Optic p s s a a

type IndexedOptic p i s t a b = p (i , a) b -> p (i , s) t

type IndexedOptic' p i s a = IndexedOptic p i s s a a

type CoindexedOptic p k s t a b = p a (k -> b) -> p s (k -> t)

type CoindexedOptic' p k t b = CoindexedOptic p k t t b b

---------------------------------------------------------------------
-- 'Equality'
---------------------------------------------------------------------

type Equality s t a b = forall p. Optic p s t a b

type Equality' s a = Equality s s a a

---------------------------------------------------------------------
-- 'Iso'
---------------------------------------------------------------------

-- | 'Iso'
--
-- \( \mathsf{Iso}\;S\;A = S \cong A \)
--
type Iso s t a b = forall p. Profunctor p => Optic p s t a b

type Iso' s a = Iso s s a a

---------------------------------------------------------------------
-- 'Lens' & 'Colens'
---------------------------------------------------------------------

-- | Lenses access one piece of a product.
--
-- \( \mathsf{Lens}\;S\;A  = \exists C, S \cong C \times A \)
--
type Lens s t a b = forall p. Strong p => Optic p s t a b

type Lens' s a = Lens s s a a

type Ixlens i s t a b = forall p. Strong p => IndexedOptic p i s t a b 

type Ixlens' i s a = Ixlens i s s a a 

type Colens s t a b = forall p. Costrong p => Optic p s t a b 

type Colens' s a = Colens s s a a

type Cxlens k s t a b = forall p. Costrong p => CoindexedOptic p k s t a b

type Cxlens' k s a = Cxlens k s s a a

---------------------------------------------------------------------
-- 'Prism' & 'Coprism'
---------------------------------------------------------------------

-- | Prisms access one piece of a sum.
--
-- \( \mathsf{Prism}\;S\;A = \exists D, S \cong D + A \)
--
type Prism s t a b = forall p. Choice p => Optic p s t a b

type Prism' s a = Prism s s a a

type Cxprism k s t a b = forall p. Choice p => CoindexedOptic p k s t a b

type Cxprism' k s a = Cxprism k s s a a

type Coprism s t a b = forall p. Cochoice p => Optic p s t a b 

type Coprism' t b = Coprism t t b b 

---------------------------------------------------------------------
-- 'Grate'
---------------------------------------------------------------------

-- | Grates access the codomain of a function.
--
--  \( \mathsf{Grate}\;S\;A = \exists I, S \cong I \to A \)
--
type Grate s t a b = forall p. Closed p => Optic p s t a b 

type Grate' s a = Grate s s a a

type Cxgrate k s t a b = forall p. Closed p => CoindexedOptic p k s t a b 

type Cxgrate' k s a = Cxgrate k s s a a

---------------------------------------------------------------------
-- 'Traversal0' & 'Cotraversal0'
---------------------------------------------------------------------

-- | A 'Traversal0' processes 0 or more parts of the whole, with no interactions.
--
-- \( \mathsf{Traversal0}\;S\;A = \exists C, D, S \cong D + C \times A \)
--
type Traversal0 s t a b = forall p. (Choice p, Strong p) => Optic p s t a b 

type Traversal0' s a = Traversal0 s s a a

type Ixtraversal0 i s t a b = forall p. (Choice p, Strong p) => IndexedOptic p i s t a b 

type Ixtraversal0' i s a = Ixtraversal0 i s s a a 

type Cotraversal0 s t a b = forall p. (Choice p, Closed p) => Optic p s t a b

type Cotraversal0' t b = Cotraversal0 t t b b

---------------------------------------------------------------------
-- 'Traversal1' & 'Cotraversal1'
---------------------------------------------------------------------

-- | A 'Traversal1' processes 1 or more parts of the whole, with 'Apply' interactions.
--
-- \( \mathsf{Traversal1}\;S\;A = \exists F : \mathsf{Traversable1}, S \equiv F\,A \)
--
type Traversal1 s t a b = forall p. (Strong p, Representable p, Apply (Rep p)) => Optic p s t a b 

type Traversal1' s a = Traversal1 s s a a

type Ixtraversal1 i s t a b = forall p. (Strong p, Representable p, Apply (Rep p)) => IndexedOptic p i s t a b 

type Ixtraversal1' i s a = Ixtraversal1 i s s a a

type Cotraversal1 s t a b = forall p. (Closed p, Corepresentable p, Coapply (Corep p)) => Optic p s t a b 

type Cotraversal1' s a = Cotraversal1 s s a a

type Cxtraversal1 k s t a b = forall p. (Closed p, Corepresentable p, Coapply (Corep p)) => CoindexedOptic p k s t a b 

type Cxtraversal1' k s a = Cxtraversal1 k s s a a

---------------------------------------------------------------------
-- 'Traversal' & 'Cotraversal'
---------------------------------------------------------------------

-- | A 'Traversal' processes 0 or more parts of the whole, with 'Applicative' interactions.
--
-- \( \mathsf{Traversal}\;S\;A = \exists F : \mathsf{Traversable}, S \equiv F\,A \)
--
type Traversal s t a b = forall p. (Choice p, Strong p, Representable p, Applicative (Rep p)) => Optic p s t a b

type Traversal' s a = Traversal s s a a

type Ixtraversal i s t a b = forall p. (Choice p, Strong p, Representable p, Applicative (Rep p)) => IndexedOptic p i s t a b 

type Ixtraversal' i s a = Ixtraversal i s s a a

type Cotraversal s t a b = forall p. (Choice p, Closed p, Corepresentable p, Coapplicative (Corep p)) => Optic p s t a b

type Cotraversal' t b = Cotraversal t t b b

---------------------------------------------------------------------
-- 'Fold0', 'Fold', 'Fold1' & 'Cofold1'
---------------------------------------------------------------------

-- | A 'Fold0' combines at most one element, with no interactions.
--
type Fold0 s a = forall p. (Choice p, Strong p, forall x. Contravariant (p x)) => Optic' p s a 

type Ixfold0 i s a = forall p. (Choice p, Strong p, forall x. Contravariant (p x)) => IndexedOptic' p i s a 

-- | A 'Fold1' combines 1 or more elements, with 'Semigroup' interactions.
--
type Fold1 s a = forall p. (Strong p, Representable p, Apply (Rep p), forall x. Contravariant (p x)) => Optic p s s a a 

type Ixfold1 i s a = forall p. (Strong p, Representable p, Apply (Rep p), forall x. Contravariant (p x)) => IndexedOptic' p i s a

type Cofold1 t b = forall p. (Closed p, Corepresentable p, Coapply (Corep p), Bifunctor p) => Optic p t t b b

-- | A 'Fold' combines 0 or more elements, with 'Monoid' interactions.
--
type Fold s a = forall p. (Choice p, Representable p, Applicative (Rep p), forall x. Contravariant (p x)) => Optic' p s a

type Ixfold i s a = forall p. (Choice p, Representable p, Applicative (Rep p), forall x. Contravariant (p x)) => IndexedOptic' p i s a

type Cofold t b = forall p. (Choice p, Closed p, Corepresentable p, Coapplicative (Corep p), Bifunctor p) => Optic p t t b b

---------------------------------------------------------------------
-- 'View' & 'Review'
---------------------------------------------------------------------

type PrimView s t a b = forall p. (Profunctor p, forall x. Contravariant (p x)) => Optic p s t a b

type View s a = forall p. (Strong p, forall x. Contravariant (p x)) => Optic' p s a 

type Ixview i s a = forall p. (Strong p, forall x. Contravariant (p x)) => IndexedOptic' p i s a

type PrimReview s t a b = forall p. (Profunctor p, Bifunctor p) => Optic p s t a b

type Review t b = forall p. (Closed p, Bifunctor p) => Optic' p t b

type Cxview k t b = forall p. (Closed p, Bifunctor p) => CoindexedOptic' p k t b

---------------------------------------------------------------------
-- 'Setter' & 'Resetter'
---------------------------------------------------------------------

-- | A 'Setter' modifies part of a structure.
--
-- \( \mathsf{Setter}\;S\;A = \exists F : \mathsf{Functor}, S \equiv F\,A \)
--
type Setter s t a b = forall p. (Choice p, Strong p, Representable p, Applicative (Rep p), Distributive (Rep p)) => Optic p s t a b

type Setter' s a = Setter s s a a

type Ixsetter i s t a b = forall p. (Choice p, Strong p, Representable p, Applicative (Rep p), Distributive (Rep p)) => IndexedOptic p i s t a b

type Ixsetter' i s a = Ixsetter i s s a a 

type Resetter s t a b = forall p. (Choice p, Closed p, Corepresentable p, Coapplicative (Corep p), Traversable (Corep p)) => Optic p s t a b 

type Resetter' s a = Resetter s s a a

type Cxsetter k s t a b = forall p. (Choice p, Closed p, Corepresentable p, Coapplicative (Corep p), Traversable (Corep p)) => CoindexedOptic p k s t a b

type Cxsetter' k t b = Cxsetter k t t b b 

---------------------------------------------------------------------
-- Common 'Representable' and 'Corepresentable' carriers
---------------------------------------------------------------------

type ARepn f s t a b = Optic (Star f) s t a b

type ARepn' f s a = ARepn f s s a a

type AIxrepn f i s t a b = IndexedOptic (Star f) i s t a b

type AIxrepn' f i s a = AIxrepn f i s s a a

type ACorepn f s t a b = Optic (Costar f) s t a b

type ACorepn' f t b = ACorepn f t t b b

type ACxrepn f k s t a b = CoindexedOptic (Costar f) k s t a b

type ACxrepn' f k t b = ACxrepn f k t t b b

-- | Can be used to rewrite
--
-- > \g -> f . g . h
--
-- to
--
-- > between f h
--
between :: (c -> d) -> (a -> b) -> (b -> c) -> a -> d
between f g = (f .) . (. g)
{-# INLINE between #-}

class Functor f => Coapply f where
  cozip' :: f (Either a b) -> Either (f a) (f b)

--TODO coerce
instance Coapply (Const r) where
  cozip' (Const r) = Right (Const r)

-- comonads, tagged, profunctors
class Functor f => Coapplicative f where
  copure :: f a -> a
  cozip :: f (Either a b) -> Either (f a) (f b)

instance Coapplicative Identity where
  copure (Identity a) = a
  cozip (Identity ab) = either (Left . Identity) (Right . Identity) ab

instance Coapplicative (Tagged k) where
  copure (Tagged a) = a
  cozip (Tagged ab) = either (Left . Tagged) (Right . Tagged) ab

instance Coapplicative ((,) r) where
  copure (_, a) = a
  cozip (r, ab) = either (Left . (r,)) (Right . (r,)) ab

instance Coapplicative f => Choice (Costar f) where
  left' (Costar fab) = Costar $ either (Left . fab) (Right . copure) . cozip

{-
class Functor f => Coapply f where
  cozip :: f (Either a b) -> Either (f a) (f b)

instance Coapplicative NonEmpty where
  copure = head
  cozip (Left x :| zs) = Left $ x :| catLefts zs
  cozip (Right y :| zs) = Right $ y :| catRights zs

catLefts = foldr (either (:) (const id)) []
catRights = foldr (either (const id) (:)) []

instance Coapplicative Store where
  copure (Store f s) = f s
  cozip (Store f s)  = case f s of
    Left  a -> Left  (Store (either id (const a) . f) s)
    Right b -> Right (Store (either (const b) id . f) s)

instance Coapplicative Costate where
  copure (Costate _ a) = a
  cozip (Costate f (Left  a)) = Left  (Costate (f . Left ) a)
  cozip (Costate f (Right a)) = Right (Costate (f . Right) a)
-}

---------------------------------------------------------------------
-- 'Re' 
---------------------------------------------------------------------

-- | Reverse an optic to obtain its dual.
--
-- >>> 5 ^. re left'
-- Left 5
--
-- >>> 6 ^. re (left' . from succ)
-- Left 7
--
-- @
-- 're' . 're'  ≡ id
-- @
--
-- @
-- 're' :: 'Iso' s t a b   -> 'Iso' b a t s
-- 're' :: 'Lens' s t a b  -> 'Colens' b a t s
-- 're' :: 'Prism' s t a b -> 'Coprism' b a t s
-- @
--
re :: Optic (Re p a b) s t a b -> Optic p b a t s
re o = (between runRe Re) o id
{-# INLINE re #-}

-- | The 'Re' type and its instances witness the symmetry between the parameters of a 'Profunctor'.
--
newtype Re p s t a b = Re { runRe :: p b a -> p t s }

instance Profunctor p => Profunctor (Re p s t) where
  dimap f g (Re p) = Re (p . dimap g f)

instance Strong p => Costrong (Re p s t) where
  unfirst (Re p) = Re (p . first')

instance Costrong p => Strong (Re p s t) where
  first' (Re p) = Re (p . unfirst)

instance Choice p => Cochoice (Re p s t) where
  unright (Re p) = Re (p . right')

instance Cochoice p => Choice (Re p s t) where
  right' (Re p) = Re (p . unright)

instance (Profunctor p, forall x. Contravariant (p x)) => Bifunctor (Re p s t) where
  first f (Re p) = Re (p . contramap f)

  second f (Re p) = Re (p . lmap f)

instance Bifunctor p => Contravariant (Re p s t a) where
  contramap f (Re p) = Re (p . first f)

---------------------------------------------------------------------
-- Orphan instances 
---------------------------------------------------------------------

instance Apply f => Apply (Star f a) where
  Star ff <.> Star fx = Star $ \a -> ff a <.> fx a

#if !(MIN_VERSION_profunctors(5,4,0))
instance Contravariant f => Contravariant (Star f a) where
  contramap f (Star g) = Star $ contramap f . g
#endif

instance Apply (Costar f a) where
  Costar ff <.> Costar fx = Costar $ \a -> ff a (fx a)

instance Contravariant f => Bifunctor (Costar f) where
  first f (Costar g) = Costar $ g . contramap f

  second f (Costar g) = Costar $ f . g

#if !(MIN_VERSION_profunctors(5,5,0))
instance Cochoice (Forget r) where 
  unleft (Forget f) = Forget $ f . Left

  unright (Forget f) = Forget $ f . Right
#endif


{-
instance Comonad f => Strong (Costar f) where
  first' (Costar f) = Costar . runCokleisli . A.first . Cokleisli $ f

  second' (Costar f) = Costar . runCokleisli . A.second . Cokleisli $ f

#if MIN_VERSION_profunctors(5,4,0)
instance Comonad f => Choice (Costar f) where
  left' (Costar f) = Costar . runCokleisli . A.left . Cokleisli $ f

  right' (Costar f) = Costar . runCokleisli . A.right . Cokleisli $ f
#endif
-}
