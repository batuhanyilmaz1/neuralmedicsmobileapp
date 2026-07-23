# AI Model — `brain_tumor.tflite`

**Status:** Converted from `Unet-BrainTumor.h5` (~157 MB). The model was trained with TensorFlow **2.14**.

To regenerate:

```powershell
python -m venv .venv-convert
.\.venv-convert\Scripts\pip install -r scripts\requirements-convert.txt
.\.venv-convert\Scripts\python.exe scripts\convert_h5_to_tflite.py
```

## Spec

- Input: `[1, 256, 256, 3]` float32, RGB 0–1
- Output: `[1, 4]` softmax — class order is in `lib/features/ai_tumor/tumor_prediction.dart`

If the model file is missing, the app runs in **DEMO** mode.
