#!/usr/bin/env bash

function update_registry() {
    REG_KEY="HKEY_CURRENT_USER\Software\Blizzard Entertainment\Starcraft"
    wine REG ADD "${REG_KEY}" /v bldgnoise /t REG_DWORD /d 00000004 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v ColorCycle /t REG_DWORD /d 00000001 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v CPUThrottle /t REG_DWORD /d 00000001 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v intro /t REG_DWORD /d 00000200 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v introX /t REG_DWORD /d 00000000 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v mscroll /t REG_DWORD /d 00000003 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v kscroll /t REG_DWORD /d 00000003 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v m_mscroll /t REG_DWORD /d 00000003 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v m_kscroll /t REG_DWORD /d 00000003 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v speed /t REG_DWORD /d 00000006 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v tip /t REG_DWORD /d 00000000 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v tipnum /t REG_DWORD /d 00000001 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v trigtext /t REG_DWORD /d 00000000 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v unitnoise /t REG_DWORD /d 00000002 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v UnitPortraits /t REG_DWORD /d 00000002 /f > /dev/null
    wine REG ADD "${REG_KEY}" /v unitspeech /t REG_DWORD /d 00000001 /f > /dev/null
    REG_KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Blizzard Entertainment\Starcraft"
    wine REG ADD "${REG_KEY}" /v StarEdit /t REG_EXPAND_SZ /d "Z:\opt\StarCraft\StarEdit.exe" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v Retail /t REG_EXPAND_SZ /d "y" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v Brood War /t REG_EXPAND_SZ /d "y" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v StarCD /t REG_EXPAND_SZ /d "" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v InstallPath /t REG_EXPAND_SZ /d "Z:\opt\StarCraft\\" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v Program /t REG_EXPAND_SZ /d "Z:\opt\StarCraft\StarCraft.exe" /f > /dev/null
    REG_KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Blizzard Entertainment\Starcraft\DelOpt0"
    wine REG ADD "${REG_KEY}" /v File0 /t REG_EXPAND_SZ /d "spc" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v File1 /t REG_EXPAND_SZ /d "mpc" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v Path0 /t REG_EXPAND_SZ /d "Z:\opt\StarCraft\characters" /f > /dev/null
    wine REG ADD "${REG_KEY}" /v Path1 /t REG_EXPAND_SZ /d "Z:\opt\StarCraft\characters" /f
}

update_registry
