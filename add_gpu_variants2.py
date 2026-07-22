#!/usr/bin/env python3
"""5 исполнений → push → повторить 10 раз. gpu-096..gpu-145"""

import subprocess

GPU_FILE = "lib/data/gpu_components.dart"

WAVES = [
  # Волна 1: RTX 4080 — исполнения
  ("Волна 1: RTX 4080 — ASUS / MSI / Gigabyte / Palit / Zotac", [
    ("gpu-096","ASUS","ROG Strix GeForce RTX 4080 OC",          129990,320,"2625","3.5","345","3","16 ГБ GDDR6X","256 бит","717 ГБ/с","9728","304","112","2205","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","750","Aura Sync RGB","Да","Axial-tech тройной кулер, испарительная камера, DLSS 3","ROG Strix RTX 4080 OC — разгон до 2625 МГц, тройной Axial-tech и испарительная камера для 4K-гейминга.","['ROG Strix OC','2625 МГц Boost','16 ГБ GDDR6X','3.5 слота']"),
    ("gpu-097","MSI","SUPRIM X GeForce RTX 4080",                124990,320,"2610","3.5","337","3","16 ГБ GDDR6X","256 бит","717 ГБ/с","9728","304","112","2205","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","750","Mystic Light RGB","Да","SUPRIM Cooler TORX 5.0 три вентилятора, испарительная камера","MSI SUPRIM X RTX 4080 — три TORX 5.0 Fan и испарительная камера в высшей линейке MSI.","['SUPRIM X','2610 МГц Boost','16 ГБ GDDR6X','TORX 5.0']"),
    ("gpu-098","Gigabyte","AORUS Xtreme GeForce RTX 4080",        122990,320,"2625","3.5","340","3","16 ГБ GDDR6X","256 бит","717 ГБ/с","9728","304","112","2205","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","750","RGB Fusion 2.0","Да","Windforce Stack испарительная камера, LCD Edge View дисплей","Gigabyte AORUS Xtreme RTX 4080 — LCD Edge View дисплей, тройной Windforce Stack и испарительная камера.","['AORUS Xtreme','LCD Edge View','16 ГБ GDDR6X','2625 МГц Boost']"),
    ("gpu-099","Palit","GameRock OC GeForce RTX 4080",            117990,320,"2580","3","330","3","16 ГБ GDDR6X","256 бит","717 ГБ/с","9728","304","112","2205","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","750","ARGB","Да","GameRock тройной кулер испарительная камера ARGB","Palit GameRock OC RTX 4080 — тройной кулер с испарительной камерой и ARGB-подсветкой.","['GameRock OC','2580 МГц Boost','16 ГБ GDDR6X','ARGB']"),
    ("gpu-100","Zotac","Gaming AMP Extreme Airo GeForce RTX 4080",119990,320,"2580","3.5","350","3","16 ГБ GDDR6X","256 бит","717 ГБ/с","9728","304","112","2205","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","750","SPECTRA 2.0 ARGB","Да","IceStorm 3.0 три HDB-вентилятора SPECTRA 2.0 подсветка","Zotac AMP Extreme Airo RTX 4080 — IceStorm 3.0 с тремя HDB и полноцветной SPECTRA-подсветкой.","['AMP Extreme Airo','IceStorm 3.0','16 ГБ GDDR6X','2580 МГц Boost']"),
  ]),

  # Волна 2: RTX 3090 Ti — исполнения
  ("Волна 2: RTX 3090 Ti — ASUS / MSI / Gigabyte / PowerColor / Palit", [
    ("gpu-101","ASUS","ROG Strix GeForce RTX 3090 Ti OC",         109990,450,"1950","3.5","358","3","24 ГБ GDDR6X","384 бит","1008 ГБ/с","10752","336","112","1560","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","850","Aura Sync RGB","Да","Axial-tech тройной кулер испарительная камера DLSS 2","ROG Strix RTX 3090 Ti OC — тройной Axial-tech и испарительная камера для 4K/8K.","['ROG Strix OC','1950 МГц Boost','24 ГБ GDDR6X','450 Вт']"),
    ("gpu-102","MSI","SUPRIM X GeForce RTX 3090 Ti",              107990,450,"1950","3.5","348","3","24 ГБ GDDR6X","384 бит","1008 ГБ/с","10752","336","112","1560","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","850","Mystic Light RGB","Да","SUPRIM Cooler Tri Frozr 3 TORX 5.0 испарительная камера","MSI SUPRIM X RTX 3090 Ti — Tri Frozr 3 с тремя TORX 5.0 и испарительной камерой.","['SUPRIM X','1950 МГц Boost','24 ГБ GDDR6X','TORX 5.0']"),
    ("gpu-103","Gigabyte","AORUS Xtreme GeForce RTX 3090 Ti",     106990,450,"1965","3.5","340","3","24 ГБ GDDR6X","384 бит","1008 ГБ/с","10752","336","112","1560","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","850","RGB Fusion 2.0","Да","Windforce Stack испарительная камера LCD дисплей","Gigabyte AORUS Xtreme RTX 3090 Ti — LCD-дисплей, Windforce Stack и испарительная камера.","['AORUS Xtreme','1965 МГц Boost','24 ГБ GDDR6X','LCD дисплей']"),
    ("gpu-104","Zotac","Gaming AMP Extreme GeForce RTX 3090 Ti",  104990,450,"1950","3.5","355","3","24 ГБ GDDR6X","384 бит","1008 ГБ/с","10752","336","112","1560","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","850","SPECTRA ARGB","Да","IceStorm 3.0 три HDB испарительная камера SPECTRA","Zotac AMP Extreme RTX 3090 Ti — IceStorm 3.0 и SPECTRA ARGB для Ampere-флагмана.","['AMP Extreme','1950 МГц Boost','24 ГБ GDDR6X','IceStorm 3.0']"),
    ("gpu-105","Palit","GameRock Premium GeForce RTX 3090 Ti",    102990,450,"1950","3","342","3","24 ГБ GDDR6X","384 бит","1008 ГБ/с","10752","336","112","1560","HDMI 2.1","DisplayPort 1.4a","1× 16-pin (12VHPWR)","850","ARGB","Да","GameRock Premium тройной кулер испарительная камера ARGB","Palit GameRock Premium RTX 3090 Ti — тройной кулер с испарительной камерой и ARGB.","['GameRock Premium','1950 МГц Boost','24 ГБ GDDR6X','ARGB']"),
  ]),

  # Волна 3: RTX 3080 Ti — исполнения
  ("Волна 3: RTX 3080 Ti — ASUS / MSI / Gigabyte / Palit / Inno3D", [
    ("gpu-106","ASUS","ROG Strix GeForce RTX 3080 Ti OC",          79990,350,"1845","3.5","319","3","12 ГБ GDDR6X","384 бит","912 ГБ/с","10240","320","112","1365","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","750","Aura Sync RGB","Да","Axial-tech тройной кулер испарительная камера DLSS 2","ROG Strix RTX 3080 Ti OC — тройной Axial-tech, разгон до 1845 МГц и Aura Sync.","['ROG Strix OC','1845 МГц Boost','12 ГБ GDDR6X','3.5 слота']"),
    ("gpu-107","MSI","SUPRIM X GeForce RTX 3080 Ti",               77990,350,"1830","3.5","336","3","12 ГБ GDDR6X","384 бит","912 ГБ/с","10240","320","112","1365","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","750","Mystic Light RGB","Да","SUPRIM Cooler Tri Frozr 3 TORX 5.0 испарительная камера","MSI SUPRIM X RTX 3080 Ti — Tri Frozr 3 с TORX 5.0 и Mystic Light.","['SUPRIM X','1830 МГц Boost','12 ГБ GDDR6X','TORX 5.0']"),
    ("gpu-108","Gigabyte","AORUS Master GeForce RTX 3080 Ti",       76990,350,"1830","3","295","3","12 ГБ GDDR6X","384 бит","912 ГБ/с","10240","320","112","1365","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","750","RGB Fusion 2.0","Да","Windforce Stack три вентилятора испарительная камера","Gigabyte AORUS Master RTX 3080 Ti — тройной Windforce Stack и испарительная камера.","['AORUS Master','1830 МГц Boost','12 ГБ GDDR6X','Windforce Stack']"),
    ("gpu-109","Palit","GameRock OC GeForce RTX 3080 Ti",           74990,350,"1815","3","330","3","12 ГБ GDDR6X","384 бит","912 ГБ/с","10240","320","112","1365","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","750","ARGB","Да","GameRock тройной кулер испарительная камера ARGB","Palit GameRock OC RTX 3080 Ti — тройной кулер с испарительной камерой и ARGB.","['GameRock OC','1815 МГц Boost','12 ГБ GDDR6X','ARGB']"),
    ("gpu-110","Inno3D","iChill X4 GeForce RTX 3080 Ti",            73990,350,"1800","3","304","4","12 ГБ GDDR6X","384 бит","912 ГБ/с","10240","320","112","1365","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","750","ARGB","Да","iChill X4 четыре вентилятора испарительная камера ARGB","Inno3D iChill X4 RTX 3080 Ti — уникальный четырёхвентиляторный кулер с испарительной камерой.","['iChill X4','4 вентилятора','12 ГБ GDDR6X','1800 МГц Boost']"),
  ]),

  # Волна 4: RTX 3070 Ti — исполнения
  ("Волна 4: RTX 3070 Ti — ASUS / MSI / Gigabyte / Palit / Zotac", [
    ("gpu-111","ASUS","ROG Strix GeForce RTX 3070 Ti OC",          54990,290,"1845","3","315","3","8 ГБ GDDR6X","256 бит","608 ГБ/с","6144","192","96","1575","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","650","Aura Sync RGB","Да","Axial-tech тройной кулер испарительная камера DLSS 2","ROG Strix RTX 3070 Ti OC — тройной Axial-tech и Aura Sync для 1440p/4K.","['ROG Strix OC','1845 МГц Boost','8 ГБ GDDR6X','3 слота']"),
    ("gpu-112","MSI","Gaming X Trio GeForce RTX 3070 Ti",          52990,290,"1830","3","323","3","8 ГБ GDDR6X","256 бит","608 ГБ/с","6144","192","96","1575","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","650","Mystic Light RGB","Да","Gaming X Trio Tri Frozr 2S TORX 4.0 три вентилятора","MSI Gaming X Trio RTX 3070 Ti — Tri Frozr 2S с тремя TORX 4.0.","['Gaming X Trio','1830 МГц Boost','8 ГБ GDDR6X','TORX 4.0']"),
    ("gpu-113","Gigabyte","AORUS Master GeForce RTX 3070 Ti",       51990,290,"1830","3","286","3","8 ГБ GDDR6X","256 бит","608 ГБ/с","6144","192","96","1575","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","650","RGB Fusion 2.0","Да","Windforce Stack три вентилятора испарительная камера","Gigabyte AORUS Master RTX 3070 Ti — тройной Windforce Stack с испарительной камерой.","['AORUS Master','1830 МГц Boost','8 ГБ GDDR6X','Windforce Stack']"),
    ("gpu-114","Palit","GameRock OC GeForce RTX 3070 Ti",           49990,290,"1815","3","318","3","8 ГБ GDDR6X","256 бит","608 ГБ/с","6144","192","96","1575","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","650","ARGB","Да","GameRock тройной кулер ARGB испарительная камера","Palit GameRock OC RTX 3070 Ti — тройной кулер с ARGB-подсветкой.","['GameRock OC','1815 МГц Boost','8 ГБ GDDR6X','ARGB']"),
    ("gpu-115","Zotac","Gaming AMP Holo GeForce RTX 3070 Ti",       50990,290,"1815","3.5","328","3","8 ГБ GDDR6X","256 бит","608 ГБ/с","6144","192","96","1575","HDMI 2.1","DisplayPort 1.4a","2× 8-pin","650","SPECTRA ARGB","Да","AMP Holo IceStorm 2.0 SPECTRA ARGB голографическая подсветка","Zotac AMP Holo RTX 3070 Ti — голографическая SPECTRA ARGB и IceStorm 2.0.","['AMP Holo','SPECTRA ARGB','8 ГБ GDDR6X','IceStorm 2.0']"),
  ]),

  # Волна 5: RX 6950 XT — исполнения
  ("Волна 5: RX 6950 XT — ASUS / MSI / Gigabyte / PowerColor / Sapphire", [
    ("gpu-116","ASUS","ROG Strix Radeon RX 6950 XT OC",            89990,335,"2394","3.5","310","3","16 ГБ GDDR6","256 бит","576 ГБ/с","4096","256","128","1860","HDMI 2.1","DisplayPort 1.4","2× 8-pin","800","Aura Sync RGB","Да","Axial-tech тройной кулер испарительная камера RDNA 2","ROG Strix RX 6950 XT OC — тройной Axial-tech и разгон до 2394 МГц для 4K AMD.","['ROG Strix OC','2394 МГц Boost','16 ГБ GDDR6','3.5 слота']"),
    ("gpu-117","MSI","Gaming X Trio Radeon RX 6950 XT",            86990,335,"2379","3","322","3","16 ГБ GDDR6","256 бит","576 ГБ/с","4096","256","128","1860","HDMI 2.1","DisplayPort 1.4","2× 8-pin","800","Mystic Light RGB","Да","Gaming X Trio Tri Frozr 2S TORX 4.0 Mystic Light","MSI Gaming X Trio RX 6950 XT — Tri Frozr 2S с тремя TORX 4.0 и Mystic Light.","['Gaming X Trio','2379 МГц Boost','16 ГБ GDDR6','TORX 4.0']"),
    ("gpu-118","Gigabyte","AORUS Xtreme Radeon RX 6950 XT",        87990,335,"2369","3.5","333","3","16 ГБ GDDR6","256 бит","576 ГБ/с","4096","256","128","1860","HDMI 2.1","DisplayPort 1.4","2× 8-pin","800","RGB Fusion 2.0","Да","Windforce Stack испарительная камера LCD дисплей","Gigabyte AORUS Xtreme RX 6950 XT — Windforce Stack, LCD-дисплей и испарительная камера.","['AORUS Xtreme','2369 МГц Boost','16 ГБ GDDR6','LCD дисплей']"),
    ("gpu-119","PowerColor","Red Devil Radeon RX 6950 XT",          87490,335,"2394","3.5","325","3","16 ГБ GDDR6","256 бит","576 ГБ/с","4096","256","128","1860","HDMI 2.1","DisplayPort 1.4","2× 8-pin","800","ARGB","Да","Red Devil тройной кулер испарительная камера ARGB","PowerColor Red Devil RX 6950 XT — тройной кулер с испарительной камерой и ARGB.","['Red Devil','2394 МГц Boost','16 ГБ GDDR6','ARGB']"),
    ("gpu-120","Sapphire","NITRO+ Radeon RX 6950 XT",              88990,335,"2394","3.5","320","3","16 ГБ GDDR6","256 бит","576 ГБ/с","4096","256","128","1860","HDMI 2.1","DisplayPort 1.4","2× 8-pin","800","ARGB","Да","NITRO+ Dual Ball Bearing три вентилятора испарительная камера","Sapphire NITRO+ RX 6950 XT — Dual Ball Bearing и испарительная камера в легендарном исполнении.","['NITRO+','2394 МГц Boost','16 ГБ GDDR6','Dual Ball Bearing']"),
  ]),

  # Волна 6: RX 6800 XT — исполнения
  ("Волна 6: RX 6800 XT — ASUS / MSI / Gigabyte / PowerColor / Sapphire", [
    ("gpu-121","ASUS","TUF Gaming OC Radeon RX 6800 XT",           64990,300,"2310","3","300","3","16 ГБ GDDR6","256 бит","512 ГБ/с","4096","256","128","1825","HDMI 2.1","DisplayPort 1.4","2× 8-pin","750","Aura Sync ARGB","Да","TUF Gaming три Axial-tech Military-grade caps RDNA 2","ASUS TUF Gaming OC RX 6800 XT — тройной Axial-tech с военными конденсаторами.","['TUF Gaming OC','2310 МГц Boost','16 ГБ GDDR6','3 слота']"),
    ("gpu-122","MSI","Gaming X Trio Radeon RX 6800 XT",            62990,300,"2285","3","322","3","16 ГБ GDDR6","256 бит","512 ГБ/с","4096","256","128","1825","HDMI 2.1","DisplayPort 1.4","2× 8-pin","750","Mystic Light RGB","Да","Gaming X Trio Tri Frozr 2 TORX 4.0 Mystic Light","MSI Gaming X Trio RX 6800 XT — Tri Frozr 2 с тремя TORX 4.0.","['Gaming X Trio','2285 МГц Boost','16 ГБ GDDR6','TORX 4.0']"),
    ("gpu-123","Gigabyte","AORUS Master Radeon RX 6800 XT",         63990,300,"2275","3.5","300","3","16 ГБ GDDR6","256 бит","512 ГБ/с","4096","256","128","1825","HDMI 2.1","DisplayPort 1.4","2× 8-pin","750","RGB Fusion 2.0","Да","Windforce Stack три вентилятора испарительная камера","Gigabyte AORUS Master RX 6800 XT — тройной Windforce Stack и испарительная камера.","['AORUS Master','2275 МГц Boost','16 ГБ GDDR6','Windforce Stack']"),
    ("gpu-124","PowerColor","Red Devil Radeon RX 6800 XT",          62490,300,"2310","3.5","305","3","16 ГБ GDDR6","256 бит","512 ГБ/с","4096","256","128","1825","HDMI 2.1","DisplayPort 1.4","2× 8-pin","750","ARGB","Да","Red Devil тройной кулер испарительная камера ARGB","PowerColor Red Devil RX 6800 XT — тройной кулер с ARGB и испарительной камерой.","['Red Devil','2310 МГц Boost','16 ГБ GDDR6','ARGB']"),
    ("gpu-125","Sapphire","NITRO+ Radeon RX 6800 XT",              63490,300,"2310","3","311","3","16 ГБ GDDR6","256 бит","512 ГБ/с","4096","256","128","1825","HDMI 2.1","DisplayPort 1.4","2× 8-pin","750","ARGB","Да","NITRO+ Dual Ball Bearing три вентилятора испарительная камера","Sapphire NITRO+ RX 6800 XT — Dual Ball Bearing и испарительная камера.","['NITRO+','2310 МГц Boost','16 ГБ GDDR6','Dual Ball Bearing']"),
  ]),

  # Волна 7: RTX 3060 Ti — исполнения
  ("Волна 7: RTX 3060 Ti — ASUS / MSI / Gigabyte / Palit / Inno3D", [
    ("gpu-126","ASUS","ROG Strix GeForce RTX 3060 Ti OC",          42990,210,"1845","2.9","300","3","8 ГБ GDDR6","256 бит","448 ГБ/с","4864","152","80","1410","HDMI 2.1","DisplayPort 1.4","2× 8-pin","600","Aura Sync RGB","Да","Axial-tech тройной кулер испарительная камера DLSS 2","ROG Strix RTX 3060 Ti OC — тройной Axial-tech и разгон до 1845 МГц Boost.","['ROG Strix OC','1845 МГц Boost','8 ГБ GDDR6','2.9 слота']"),
    ("gpu-127","MSI","Gaming X Trio GeForce RTX 3060 Ti",          40990,210,"1830","3","285","3","8 ГБ GDDR6","256 бит","448 ГБ/с","4864","152","80","1410","HDMI 2.1","DisplayPort 1.4","2× 8-pin","600","Mystic Light RGB","Да","Gaming X Trio Tri Frozr 2 TORX 4.0 три вентилятора","MSI Gaming X Trio RTX 3060 Ti — Tri Frozr 2 с тремя TORX 4.0.","['Gaming X Trio','1830 МГц Boost','8 ГБ GDDR6','TORX 4.0']"),
    ("gpu-128","Gigabyte","AORUS Master GeForce RTX 3060 Ti",       41990,210,"1815","3","240","3","8 ГБ GDDR6","256 бит","448 ГБ/с","4864","152","80","1410","HDMI 2.1","DisplayPort 1.4","2× 8-pin","600","RGB Fusion 2.0","Да","Windforce Stack три вентилятора испарительная камера","Gigabyte AORUS Master RTX 3060 Ti — тройной Windforce Stack.","['AORUS Master','1815 МГц Boost','8 ГБ GDDR6','Windforce Stack']"),
    ("gpu-129","Palit","GameRock OC GeForce RTX 3060 Ti",           39990,210,"1800","3","288","3","8 ГБ GDDR6","256 бит","448 ГБ/с","4864","152","80","1410","HDMI 2.1","DisplayPort 1.4","2× 8-pin","600","ARGB","Да","GameRock тройной кулер ARGB испарительная камера","Palit GameRock OC RTX 3060 Ti — тройной кулер с ARGB.","['GameRock OC','1800 МГц Boost','8 ГБ GDDR6','ARGB']"),
    ("gpu-130","Inno3D","iChill X3 GeForce RTX 3060 Ti",            38990,210,"1800","2.5","258","3","8 ГБ GDDR6","256 бит","448 ГБ/с","4864","152","80","1410","HDMI 2.1","DisplayPort 1.4","2× 8-pin","600","ARGB","Нет","iChill X3 тройной кулер ARGB компактный","Inno3D iChill X3 RTX 3060 Ti — компактный тройной кулер с ARGB.","['iChill X3','1800 МГц Boost','8 ГБ GDDR6','2.5 слота']"),
  ]),

  # Волна 8: RTX 3060 — исполнения
  ("Волна 8: RTX 3060 — ASUS / MSI / Gigabyte / Palit / Zotac", [
    ("gpu-131","ASUS","Dual OC GeForce RTX 3060",                  35990,170,"1837","2.5","242","2","12 ГБ GDDR6","192 бит","360 ГБ/с","3584","112","48","1320","HDMI 2.1","DisplayPort 1.4","1× 12-pin","650","ARGB","Да","Dual Axial-tech двойной кулер 2.5 слота авторазгон","ASUS Dual OC RTX 3060 — двойной Axial-tech и 2.5 слота.","['Dual OC','1837 МГц Boost','12 ГБ GDDR6','2.5 слота']"),
    ("gpu-132","MSI","Gaming X GeForce RTX 3060",                  34990,170,"1807","2.7","233","2","12 ГБ GDDR6","192 бит","360 ГБ/с","3584","112","48","1320","HDMI 2.1","DisplayPort 1.4","1× 12-pin","650","Mystic Light RGB","Да","Gaming X Tri Frozr 2 два TORX 4.0 Mystic Light","MSI Gaming X RTX 3060 — Tri Frozr 2 с двумя TORX 4.0.","['Gaming X','1807 МГц Boost','12 ГБ GDDR6','TORX 4.0']"),
    ("gpu-133","Gigabyte","Gaming OC GeForce RTX 3060",            34490,170,"1807","2.5","242","3","12 ГБ GDDR6","192 бит","360 ГБ/с","3584","112","48","1320","HDMI 2.1","DisplayPort 1.4","1× 12-pin","650","RGB Fusion 2.0","Да","Windforce 3X три вентилятора RGB Fusion 2.0","Gigabyte Gaming OC RTX 3060 — тройной Windforce 3X и RGB Fusion 2.0.","['Gaming OC','1807 МГц Boost','12 ГБ GDDR6','Windforce 3X']"),
    ("gpu-134","Palit","Dual GeForce RTX 3060",                    32990,170,"1777","2","231","2","12 ГБ GDDR6","192 бит","360 ГБ/с","3584","112","48","1320","HDMI 2.1","DisplayPort 1.4","1× 12-pin","600","Нет","Нет","Dual двойной кулер компактный 2-слот без RGB","Palit Dual RTX 3060 — компактный 2-слотовый двойной кулер без RGB.","['Dual','2 слота','12 ГБ GDDR6','1777 МГц Boost']"),
    ("gpu-135","Zotac","Gaming Twin Edge OC GeForce RTX 3060",      33490,170,"1807","2","230","2","12 ГБ GDDR6","192 бит","360 ГБ/с","3584","112","48","1320","HDMI 2.1","DisplayPort 1.4","1× 12-pin","600","SPECTRA ARGB","Да","Twin Edge компактный 2-слот SPECTRA ARGB","Zotac Twin Edge OC RTX 3060 — компактный 2-слотовый кулер с SPECTRA ARGB.","['Twin Edge OC','SPECTRA ARGB','12 ГБ GDDR6','2 слота']"),
  ]),

  # Волна 9: RX 6700 XT — исполнения
  ("Волна 9: RX 6700 XT — ASUS / MSI / Gigabyte / PowerColor / Sapphire", [
    ("gpu-136","ASUS","TUF Gaming OC Radeon RX 6700 XT",           42990,230,"2620","3","267","3","12 ГБ GDDR6","192 бит","384 ГБ/с","2560","160","64","2321","HDMI 2.1","DisplayPort 1.4","2× 8-pin","650","Aura Sync ARGB","Да","TUF Gaming три Axial-tech Military-grade caps RDNA 2","ASUS TUF Gaming OC RX 6700 XT — тройной Axial-tech с военными конденсаторами.","['TUF Gaming OC','2620 МГц Boost','12 ГБ GDDR6','3 слота']"),
    ("gpu-137","MSI","Gaming X Radeon RX 6700 XT",                 41990,230,"2611","2.7","258","2","12 ГБ GDDR6","192 бит","384 ГБ/с","2560","160","64","2321","HDMI 2.1","DisplayPort 1.4","2× 8-pin","650","Mystic Light RGB","Да","Gaming X Tri Frozr 2 два TORX 4.0 Mystic Light","MSI Gaming X RX 6700 XT — Tri Frozr 2 с двумя TORX 4.0.","['Gaming X','2611 МГц Boost','12 ГБ GDDR6','TORX 4.0']"),
    ("gpu-138","Gigabyte","Gaming OC Radeon RX 6700 XT",           41490,230,"2555","3","253","3","12 ГБ GDDR6","192 бит","384 ГБ/с","2560","160","64","2321","HDMI 2.1","DisplayPort 1.4","2× 8-pin","650","RGB Fusion 2.0","Да","Windforce 3X три вентилятора RGB Fusion 2.0","Gigabyte Gaming OC RX 6700 XT — тройной Windforce 3X.","['Gaming OC','2555 МГц Boost','12 ГБ GDDR6','Windforce 3X']"),
    ("gpu-139","PowerColor","Red Dragon Radeon RX 6700 XT",         39990,230,"2548","2.5","247","2","12 ГБ GDDR6","192 бит","384 ГБ/с","2560","160","64","2321","HDMI 2.1","DisplayPort 1.4","2× 8-pin","600","ARGB","Нет","Red Dragon двойной кулер бюджетное исполнение ARGB","PowerColor Red Dragon RX 6700 XT — доступное двухвентиляторное исполнение с ARGB.","['Red Dragon','2548 МГц Boost','12 ГБ GDDR6','ARGB']"),
    ("gpu-140","Sapphire","Pulse Radeon RX 6700 XT",               41990,230,"2620","2.5","235","2","12 ГБ GDDR6","192 бит","384 ГБ/с","2560","160","64","2321","HDMI 2.1","DisplayPort 1.4","2× 8-pin","650","ARGB","Да","Pulse Dual Ball Bearing двойной кулер ARGB тихий профиль","Sapphire Pulse RX 6700 XT — надёжный Dual Ball Bearing с ARGB.","['Pulse','2620 МГц Boost','12 ГБ GDDR6','Dual Ball Bearing']"),
  ]),

  # Волна 10: RX 6600 XT — исполнения
  ("Волна 10: RX 6600 XT — ASUS / MSI / Gigabyte / PowerColor / Sapphire", [
    ("gpu-141","ASUS","Dual OC Radeon RX 6600 XT",                 32990,160,"2607","2.5","206","2","8 ГБ GDDR6","128 бит","256 ГБ/с","2048","128","64","2359","HDMI 2.1","DisplayPort 1.4","1× 8-pin","500","ARGB","Да","Dual Axial-tech двойной кулер 2.5 слота авторазгон","ASUS Dual OC RX 6600 XT — двойной Axial-tech и 2.5 слота.","['Dual OC','2607 МГц Boost','8 ГБ GDDR6','2.5 слота']"),
    ("gpu-142","MSI","Mech 2X Radeon RX 6600 XT",                  31490,160,"2589","2","191","2","8 ГБ GDDR6","128 бит","256 ГБ/с","2048","128","64","2359","HDMI 2.1","DisplayPort 1.4","1× 8-pin","500","Нет","Нет","Mech 2X двойной кулер компактный 2-слот без RGB","MSI Mech 2X RX 6600 XT — компактный 2-слотовый кулер без RGB.","['Mech 2X','2 слота','8 ГБ GDDR6','2589 МГц Boost']"),
    ("gpu-143","Gigabyte","Eagle OC Radeon RX 6600 XT",            32490,160,"2607","2.5","200","2","8 ГБ GDDR6","128 бит","256 ГБ/с","2048","128","64","2359","HDMI 2.1","DisplayPort 1.4","1× 8-pin","500","RGB","Да","Eagle OC двойной Windforce чередование вентиляторов RGB","Gigabyte Eagle OC RX 6600 XT — двойной Windforce с чередованием.","['Eagle OC','2607 МГц Boost','8 ГБ GDDR6','Windforce 2X']"),
    ("gpu-144","PowerColor","Hellhound Radeon RX 6600 XT",          30990,160,"2589","2.5","210","2","8 ГБ GDDR6","128 бит","256 ГБ/с","2048","128","64","2359","HDMI 2.1","DisplayPort 1.4","1× 8-pin","500","ARGB","Да","Hellhound двойной кулер ARGB","PowerColor Hellhound RX 6600 XT — доступный двойной кулер с ARGB.","['Hellhound','2589 МГц Boost','8 ГБ GDDR6','ARGB']"),
    ("gpu-145","Sapphire","Pulse Radeon RX 6600 XT",               33490,160,"2607","2","211","2","8 ГБ GDDR6","128 бит","256 ГБ/с","2048","128","64","2359","HDMI 2.1","DisplayPort 1.4","1× 8-pin","500","ARGB","Да","Pulse Dual Ball Bearing двойной кулер тихий ARGB","Sapphire Pulse RX 6600 XT — Dual Ball Bearing с ARGB.","['Pulse','2607 МГц Boost','8 ГБ GDDR6','Dual Ball Bearing']"),
  ]),
]

def make_dart(g):
    gid,brand,model,price,tdp,boost,slots,length,fans,vram,bus,bw,cuda,tmu,rop,base,hdmi,dp,pwr,psu,light,dbios,feat,desc,ks = g
    return f'''
  Component(
    id: '{gid}',
    name: '{brand} {model}',
    brand: '{brand}',
    model: '{model}',
    category: ComponentCategory.gpu,
    price: {price},
    description: '{desc}',
    specs: {{
      'Архитектура / исполнение': '{brand} custom PCB',
      'Видеопамять': '{vram}',
      'Разрядность шины памяти': '{bus}',
      'Пропускная способность памяти': '{bw}',
      'Интерфейс': 'PCIe 4.0 x16',
      'Шейдерные процессоры': '{cuda}',
      'Текстурные блоки (TMU)': '{tmu}',
      'Блоки растеризации (ROP)': '{rop}',
      'Базовая частота GPU': '{base} МГц',
      'Boost-частота GPU': '{boost} МГц',
      'TDP': '{tdp} Вт',
      'Разъём питания': '{pwr}',
      'Рекомендуемый блок питания': '{psu} Вт',
      'Версия HDMI': '{hdmi}',
      'Версия DisplayPort': '{dp}',
      'Количество подключаемых мониторов': '4',
      'Максимальное разрешение': '3840×2160 (4K)',
      'Выходы': '1× {hdmi}, 3× {dp}',
      'Тип охлаждения': 'Активное воздушное',
      'Количество вентиляторов': '{fans} осевых',
      'Количество занимаемых слотов': '{slots}',
      'Длина карты': '{length} мм',
      'Подсветка': '{light}',
      'Переключатель BIOS': '{dbios}',
      'Предназначена для майнинга': 'Нет',
      'Особенности': '{feat}',
    }},
    keySpecs: {ks},
    powerDraw: {tdp},
    formFactor: 'PCIe 4.0 x16',
  ),'''

GPU_FILE = "lib/data/gpu_components.dart"

for wave_num, (label, gpus) in enumerate(WAVES, 1):
    print(f"\n{'='*58}\n  {label}\n{'='*58}")

    with open(GPU_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    idx = content.rfind("];")
    block = "\n".join(make_dart(g) for g in gpus)
    with open(GPU_FILE, 'w', encoding='utf-8') as f:
        f.write(content[:idx] + block + "\n\n];")

    ids = ", ".join(g[0] for g in gpus)
    msg = f"{label}: {ids}"
    rc = __import__('subprocess').run(
        f'git add {GPU_FILE} && git commit -m "{msg}" && git push origin main',
        shell=True, capture_output=True, text=True)
    print(rc.stdout)
    if rc.returncode != 0:
        print("STDERR:", rc.stderr)
    print(f"Волна {wave_num}/10 готова — {ids}")

print("\nГотово! 50 новых исполнений (gpu-096..gpu-145) запушены в 10 волнах.")
