#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ -n "$1" ]; then
    TARGET_DOMAIN=$1
else
    read -p "Hedef Domain (örn: example.com): " TARGET_DOMAIN
fi

if [ -z "$TARGET_DOMAIN" ]; then
    echo -e "${RED}[-] Hata: Lütfen bir hedef domain girin.${NC}"
    exit 1
fi

echo -e "${GREEN}[*] Hedef domain: ${YELLOW}$TARGET_DOMAIN${NC}"
echo -e "${GREEN}[*] Wayback Machine'den *.$TARGET_DOMAIN için URL'ler çekiliyor...${NC}"

curl -s "https://web.archive.org/cdx/search/cdx?url=*.$TARGET_DOMAIN/*&collapse=urlkey&output=text&fl=original" -o wayback_urls.txt

if [ ! -s wayback_urls.txt ]; then
    echo -e "${RED}[-] Wayback Machine'den hiç URL bulunamadı veya bir hata oluştu. Script durduruluyor.${NC}"
    exit 1
fi

cat wayback_urls.txt | uro > waybackUrls.txt

rm wayback_urls.txt
echo -e "${GREEN}[*] Toplam $(wc -l < waybackUrls.txt) eşsiz URL bulundu.${NC}"

RESULTS_DIR="results"
HIGH_IMPACT_DIR="$RESULTS_DIR/temel_zafiyetler"
INFO_DISC_DIR="$RESULTS_DIR/hassas_veri_kesfi"

rm -rf "$RESULTS_DIR"
mkdir -p "$HIGH_IMPACT_DIR"
mkdir -p "$INFO_DISC_DIR"

echo "[*] Potansiyel zafiyetler için URL'ler taranıyor..."
echo "[*] Sonuçlar '$RESULTS_DIR' klasörü altındaki alt klasörlere kaydedilecek."

# ==============================================================
#               TEMEL ZAFİYETLER
# ==============================================================
echo "[*] 'Temel ve Yüksek Etkili Zafiyetler' taranıyor..."

cat waybackUrls.txt | gf xss > "$HIGH_IMPACT_DIR/xss.txt"
cat waybackUrls.txt | gf idor > "$HIGH_IMPACT_DIR/idor.txt"
cat waybackUrls.txt | gf sqli > "$HIGH_IMPACT_DIR/sqli.txt"
cat waybackUrls.txt | gf ssrf > "$HIGH_IMPACT_DIR/ssrf.txt"
cat waybackUrls.txt | gf redirect > "$HIGH_IMPACT_DIR/redirect.txt"
cat waybackUrls.txt | gf lfi > "$HIGH_IMPACT_DIR/lfi.txt"
cat waybackUrls.txt | gf rfi > "$HIGH_IMPACT_DIR/rfi.txt"

# ==============================================================
#              HASSAS VERİ KEŞFİ
# ==============================================================
echo "[*] 'Bilgi İfşası ve Hassas Veri Keşfi' taranıyor..."

cat waybackUrls.txt | gf interestingparams > "$INFO_DISC_DIR/interestingparams.txt"
cat waybackUrls.txt | gf debug_logic > "$INFO_DISC_DIR/debug_logic.txt"
cat waybackUrls.txt | gf ip > "$INFO_DISC_DIR/ip_urls.txt"
cat waybackUrls.txt | gf firebase > "$INFO_DISC_DIR/firebase.txt"

rm waybackUrls.txt



echo -e "\n${GREEN}[*] Tüm taramalar tamamlandı!${NC}"
echo "[*] Sonuçlar aşağıdaki klasör yapısına göre kaydedildi:"
echo "└── ${YELLOW}${RESULTS_DIR}${NC}"
echo "    ├── ${YELLOW}${HIGH_IMPACT_DIR##*/}${NC}"
echo "    │   ├── xss.txt"
echo "    │   ├── idor.txt"
echo "    │   ├── sqli.txt"
echo "    │   └── ..."
echo "    └── ${YELLOW}${INFO_DISC_DIR##*/}${NC}"
echo "        ├── interestingparams.txt"
echo "        ├── debug_logic.txt"
echo "        └── ..."
echo "[*] Metodoloji icin: turgaykara.github.io"

