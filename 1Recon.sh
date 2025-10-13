#!/bin/bash

echo "Hedef Domain (örn: example.com): "
read TARGET_DOMAIN

echo "[*] Wayback Machine'den *.$TARGET_DOMAIN için URL'ler çekiliyor..."
curl "https://web.archive.org/cdx/search/cdx?url=*.$TARGET_DOMAIN/*&collapse=urlkey&output=text&fl=original"

# Adım 2: Çekilen URL'leri 'uro' ile temizle ve eşsizleştir
cat wayback_urls.txt | uro > waybackUrls.txt

# Adım 3: Artık ihtiyaç duyulmayan ham URL dosyasını sil
rm wayback_urls.txt
echo "[*] Toplam $(wc -l < waybackUrls.txt) eşsiz URL bulundu."

# =================================================================
#               TEMEL VE YÜKSEK ETKİLİ ZAFİYETLER
# =================================================================

# XSS (Cross-Site Scripting) için potansiyel URL'leri bul
cat waybackUrls.txt | gf xss > xss_candidates.txt

# IDOR (Insecure Direct Object References) için potansiyel URL'leri bul
cat waybackUrls.txt | gf idor > idor_candidates.txt

# SQL Injection için potansiyel URL'leri bul
cat waybackUrls.txt | gf sqli > sqli_candidates.txt

# SSRF (Server-Side Request Forgery) için potansiyel URL'leri bul
cat waybackUrls.txt | gf ssrf > ssrf_candidates.txt

# Open Redirect (Açık Yönlendirme) için potansiyel URL'leri bul
cat waybackUrls.txt | gf redirect > redirect_candidates.txt

# LFI (Local File Inclusion) için potansiyel URL'leri bul
cat waybackUrls.txt | gf lfi > lfi_candidates.txt

# RFI (Remote File Inclusion) için potansiyel URL'leri bul
cat waybackUrls.txt | gf rfi > rfi_candidates.txt

# =================================================================
#              BİLGİ İFŞASI VE HASSAS VERİ KEŞFİ
# =================================================================

# İlginç parametreleri (admin, token, secret, api_key vb.) içeren URL'leri bul
cat waybackUrls.txt | gf interestingparams > interestingparams_candidates.txt

# Hata ayıklama (Debug) parametreleri ve sayfaları için URL'leri bul
cat waybackUrls.txt | gf debug_logic > debug_logic_candidates.txt

# URL içinde IP adresi barındıran endpoint'leri bul (SSRF için ipucu olabilir)
cat waybackUrls.txt | gf ip > ip_candidates.txt

# Firebase URL'lerini bul
cat waybackUrls.txt | gf firebase > firebase_candidates.txt

echo "[*] Tüm taramalar tamamlandı!"

echo "[*] Metodoloji icin: turgaykara.github.io"
