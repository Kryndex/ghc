module Settings.Builders.DeriveConstants (
    derivedConstantsPath, deriveConstantsArgs
    ) where

import Expression
import Oracles.Config.Flag
import Oracles.Config.Setting
import Predicates (builder, file)
import Settings.Builders.GhcCabal

derivedConstantsPath :: FilePath
derivedConstantsPath = "includes/dist-derivedconstants/header"

-- TODO: do we need to support `includes_CC_OPTS += -DDYNAMIC_BY_DEFAULT`?
deriveConstantsArgs :: Args
deriveConstantsArgs = builder DeriveConstants ? do
    cFlags <- fromDiffExpr includeCcArgs
    mconcat
        [ file "//DerivedConstants.h"             ? arg "--gen-header"
        , file "//GHCConstantsHaskellType.hs"     ? arg "--gen-haskell-type"
        , file "//platformConstants"              ? arg "--gen-haskell-value"
        , file "//GHCConstantsHaskellWrappers.hs" ? arg "--gen-haskell-wrappers"
        , file "//GHCConstantsHaskellExports.hs"  ? arg "--gen-haskell-exports"
        , arg "-o", arg =<< getOutput
        , arg "--tmpdir", arg derivedConstantsPath
        , arg "--gcc-program", arg =<< getBuilderPath (Gcc Stage1)
        , append . concat $ map (\a -> ["--gcc-flag", a]) cFlags
        , arg "--nm-program", arg =<< getBuilderPath Nm
        , specified Objdump ? mconcat [ arg "--objdump-program"
                                      , arg =<< getBuilderPath Objdump ]
        , arg "--target-os", arg =<< getSetting TargetOs ]

includeCcArgs :: Args
includeCcArgs = do
    confCcArgs <- lift . settingList $ ConfCcArgs Stage1
    mconcat
        [ ccArgs
        , ccWarnings
        , append confCcArgs
        , flag GhcUnregisterised ? arg "-DUSE_MINIINTERPRETER"
        , append $ map ("-I" ++) ghcIncludeDirs -- TODO: fix code duplication
        , arg "-Irts"
        , notM ghcWithSMP ? arg "-DNOSMP"
        , arg "-fcommon" ]
