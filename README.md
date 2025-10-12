# 1Recon
Bu metodoloji, bir hedef domaine ait geçmiş URL'leri kullanarak potansiyel web güvenlik zafiyetlerini hızlıca tespit etmek için hazırlanmıştır.
Tek bir komutla, binlerce URL'yi analiz ederek size test etmeye hazır, kategorize edilmiş zafiyet adayı listeleri sunar.

---
  
INSTALLATION:  
```
git clone https://github.com/turgaykara/1Recon.git
cd 1Recon

python3 -m venv myenv
source myenv/bin/activate
pip install -r requirements.txt

chmod +x 1Recon.sh

dos2unix 1Recon.sh
bash setup.sh
```

---

RUN: 
```
bash 1Recon.sh
```
