module Settings.User (
    userArgs, userPackages, userWays, userRtsWays, userTargetDirectory,
    userKnownPackages, integerLibrary,
    trackBuildSystem, buildHaddock, validating, ghciWithDebugger, ghcProfiled,
    dynamicGhcPrograms, laxDependencies
    ) where

import Expression
import Predicates

-- No user-specific settings by default
-- TODO: rename to userArgs
userArgs :: Args
userArgs = mempty

-- Control which packages get to be built
userPackages :: Packages
userPackages = mempty

-- Add new user-defined packages
userKnownPackages :: [Package]
userKnownPackages = []

-- Control which ways are built
userWays :: Ways
userWays = mempty

userRtsWays :: Ways
userRtsWays = mempty

-- Control where build results go (see Settings.Default for an example)
userTargetDirectory :: Stage -> Package -> FilePath
userTargetDirectory = defaultTargetDirectory

-- Choose integer library: integerGmp, integerGmp2 or integerSimple
integerLibrary :: Package
integerLibrary = integerGmp

-- User-defined flags. Note the following type semantics:
-- * Bool: a plain Boolean flag whose value is known at compile time
-- * Action Bool: a flag whose value can depend on the build environment
-- * Predicate: a flag depending on the build environment and the current target

-- Set this to True if you are making any changes in the build system and want
-- appropriate rebuilds to be initiated. Switching this to False speeds things
-- up a little (particularly zero builds).
-- WARNING: a complete rebuild is required when changing this setting.
trackBuildSystem :: Bool
trackBuildSystem = True

validating :: Bool
validating = False

dynamicGhcPrograms :: Bool
dynamicGhcPrograms = False

ghciWithDebugger :: Bool
ghciWithDebugger = False

ghcProfiled :: Bool
ghcProfiled = False

-- When laxDependencies flag is set to True, dependencies on the GHC executable
-- are turned into order-only dependencies to avoid needless recompilation when
-- making changes to GHC's sources. In certain situations this can lead to build
-- failures, in which case you should reset the flag (at least temporarily).
laxDependencies :: Bool
laxDependencies = False

buildHaddock :: Predicate
buildHaddock = return True
