#!/usr/bin/env python3
"""Load saved Keras H5 model and export TFLite for Flutter."""

from __future__ import annotations

import os
import sys
import types
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
H5_PATH = ROOT / "ai_figma" / "Unet-BrainTumor.h5"
OUT_PATH = ROOT / "assets" / "ai" / "brain_tumor.tflite"


def _patch_keras3_for_segmentation_models() -> None:
    """segmentation-models 1.0.1 expects keras.utils.generic_utils (Keras 2)."""
    import keras

    if not hasattr(keras.utils, "generic_utils"):
        gu = types.SimpleNamespace(
            get_custom_objects=keras.utils.get_custom_objects,
        )
        keras.utils.generic_utils = gu  # type: ignore[attr-defined]


def _load_model():
    os.environ["SM_FRAMEWORK"] = "tf.keras"
    os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

    import tensorflow as tf

    _patch_keras3_for_segmentation_models()
    import segmentation_models as sm  # noqa: F401

    print(f"Loading full model from {H5_PATH} ...")
    try:
        return tf.keras.models.load_model(str(H5_PATH), compile=False)
    except Exception as exc:
        print(f"load_model failed ({exc}), rebuilding architecture...")
        return _build_and_load_weights(tf)


def _build_and_load_weights(tf):
    from tensorflow.keras.layers import (
        BatchNormalization,
        Dense,
        Dropout,
        Flatten,
    )
    from tensorflow.keras.models import Sequential
    import segmentation_models as sm

    conv_base = sm.Unet(backbone_name="resnet34", input_shape=(256, 256, 3))
    model = Sequential(
        [
            conv_base,
            Flatten(),
            Dense(256, activation="relu"),
            BatchNormalization(),
            Dropout(0.4),
            Dense(128, activation="relu"),
            BatchNormalization(),
            Dropout(0.3),
            Dense(32, activation="relu"),
            BatchNormalization(),
            Dense(16, activation="relu"),
            BatchNormalization(),
            Dense(4, activation="softmax"),
        ]
    )
    model.load_weights(str(H5_PATH))
    return model


def _convert_to_tflite(model, tf) -> bytes:
    import tempfile

    strategies = [
        ("concrete_function_builtin", _convert_concrete_builtin),
        ("saved_model_builtin", _convert_saved_model_builtin),
        ("concrete_function_flex", _convert_concrete_flex),
    ]

    last_error: Exception | None = None
    for name, fn in strategies:
        print(f"Trying TFLite strategy: {name} ...")
        try:
            return fn(model, tf)
        except Exception as exc:
            last_error = exc
            print(f"  failed: {exc}")

    raise RuntimeError(f"All TFLite conversion strategies failed: {last_error}")


def _convert_concrete_builtin(model, tf) -> bytes:
    @tf.function(
        input_signature=[
            tf.TensorSpec(shape=[1, 256, 256, 3], dtype=tf.float32, name="input"),
        ]
    )
    def infer(x):
        return model(x, training=False)

    converter = tf.lite.TFLiteConverter.from_concrete_functions([infer.get_concrete_function()])
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
    return converter.convert()


def _convert_concrete_flex(model, tf) -> bytes:
    @tf.function(
        input_signature=[
            tf.TensorSpec(shape=[1, 256, 256, 3], dtype=tf.float32, name="input"),
        ]
    )
    def infer(x):
        return model(x, training=False)

    converter = tf.lite.TFLiteConverter.from_concrete_functions([infer.get_concrete_function()])
    converter.target_spec.supported_ops = [
        tf.lite.OpsSet.TFLITE_BUILTINS,
        tf.lite.OpsSet.SELECT_TF_OPS,
    ]
    converter._experimental_lower_tensor_list_ops = False
    return converter.convert()


def _convert_saved_model_builtin(model, tf) -> bytes:
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        export_path = str(Path(tmp) / "saved_model")
        model.export(export_path)
        converter = tf.lite.TFLiteConverter.from_saved_model(export_path)
        converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
        return converter.convert()


def main() -> int:
    if not H5_PATH.exists():
        print(f"ERROR: Model not found: {H5_PATH}")
        return 1

    try:
        import tensorflow as tf
    except ImportError:
        print("ERROR: pip install tensorflow segmentation-models")
        return 1

    model = _load_model()
    model.summary()

    print("Converting to TFLite (this may take several minutes)...")
    tflite_model = _convert_to_tflite(model, tf)

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_bytes(tflite_model)
    print(f"Saved {OUT_PATH} ({len(tflite_model) / (1024 * 1024):.1f} MB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
