# 1Recon
Bu metodoloji, bir hedef domaine ait geçmiş URL'leri kullanarak potansiyel web güvenlik zafiyetlerini hızlıca tespit etmek için hazırlanmıştır.
Tek bir komutla, binlerce URL'yi analiz ederek size test etmeye hazır, kategorize edilmiş zafiyet adayı listeleri sunar.  

Kullanım Rehberi için: turgaykara.github.io

---
  
INSTALLATION:  
```
git clone https://github.com/turgaykara/1Recon.git
cd 1Recon

python3 -m venv myenv
source myenv/bin/activate
pip install -r requirements.txt

go install -v github.com/tomnomnom/gf@latest
go install -v github.com/s0md3v/uro@latest

chmod +x 1Recon.sh
dos2unix 1Recon.sh
```

---

RUN: 
```
bash 1Recon.sh
```

---
  
SOLUTIONS 4 POSSIBLE PROBLEMS :  
```
# 1. Desenlerin tutulacağı ~/.gf dizinini oluştur.
mkdir -p ~/.gf

# 2. Popüler bir gf desen reposunu klonla
git clone https://github.com/1ndianl33t/Gf-Patterns.git

# 3. Klonlanan repodaki tüm .json desen dosyalarını ~/.gf dizinine taşı
mv Gf-Patterns/*.json ~/.gf/

# 4. İndirdiğin gereksiz klasörü temizle
rm -rf Gf-Patterns
