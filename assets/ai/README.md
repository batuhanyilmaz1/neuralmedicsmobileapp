# AI Model — `brain_tumor.tflite`

**Durum:** `Unet-BrainTumor.h5` dosyasından dönüştürüldü (~157 MB). Model TensorFlow **2.14** ile eğitildi.

Yeniden üretmek için:

```powershell
python -m venv .venv-convert
.\.venv-convert\Scripts\pip install -r scripts\requirements-convert.txt
.\.venv-convert\Scripts\python.exe scripts\convert_h5_to_tflite.py
```

## Spec

- Input: `[1, 256, 256, 3]` float32, RGB 0–1
- Output: `[1, 4]` softmax — sınıf sırası `lib/features/ai_tumor/tumor_prediction.dart` içinde

Model dosyası yoksa uygulama **DEMO** modunda çalışır.
